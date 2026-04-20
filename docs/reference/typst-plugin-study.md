# Typst Plugin Study Note

This note captures the current understanding of Typst's WebAssembly plugin system and how it could help this resume project in the future.

## Short Answer

Yes: pure Rust logic can run during Typst compilation and pass values back into Typst.

For this project, the most relevant example was computing image metadata such as aspect ratio dynamically during compile time.

The important constraint is that the plugin should not open files itself. Typst should read the file bytes and pass those bytes into the plugin.

## What Typst Officially Supports

Typst has an official `plugin(...)` function that loads a WebAssembly module and exposes its exports as Typst-callable functions.

Key constraints from the official docs:

- Plugins must be WebAssembly modules that follow Typst's plugin protocol.
- Plugins exchange byte buffers with Typst.
- Plugins run in isolation and do not support direct file IO, printing, or similar system access.
- Plugins are expected to be pure. Given the same inputs, they should always return the same outputs.
- Normal WASI builds do not work out of the box; the plugin must target Typst's expected protocol instead.

Implication for this repo:

- A plugin can compute an image aspect ratio during compilation.
- `cv.typ` or a wrapper package would call `read(path, encoding: none)` and pass the image bytes to the plugin.
- The plugin would decode the bytes in Rust and return the result to Typst.
- For this specific repo, Typst-side `measure(image(...))` may already be enough for aspect ratio, so a plugin is not required just for that one value.

## Where `typwire` Fits

[`typwire:0.1.0`](https://typst.app/universe/package/typwire/) looks directly relevant for plugin work.

It provides:

- a Typst-side CBOR encoder for plugin arguments
- Rust-side types and deserialization helpers
- support for a broader set of Typst values than a raw string/bytes-only wrapper

This matters because Typst's official plugin interface is byte-based and fairly low-level. `typwire` can reduce the amount of manual encoding and decoding we would otherwise need to write.

Current caveats from the package page:

- the Typst package version and Rust crate version must match exactly
- decoding from the plugin back into Typst is still listed as missing
- some Typst types are still unsupported

For a first image-aspect-ratio plugin, `typwire` may be optional because a single `float` or string return value is simple enough. It becomes more attractive if we want richer structured data later, such as:

- width and height together
- EXIF-like metadata
- crop suggestions or focal-point data

## Viable First Spike

The smallest useful experiment would be a plugin that accepts image bytes and returns one numeric ratio.

Likely flow:

1. Typst wrapper reads image bytes from a path.
2. The wrapper passes those bytes to a Wasm plugin.
3. Rust decodes the image in memory and computes `width / height`.
4. Typst converts the returned bytes into a usable value for layout logic.

Why this would be a good first spike when Typst-side measurement is not enough:

- it is pure and deterministic
- it avoids plugin file access entirely
- it can remove a manual metadata step when Typst itself cannot provide the needed value
- it tests the real compile-time plugin workflow without taking on a large scope

## What This Does Not Replace

Even if we adopt a plugin for image metadata, it does not automatically mean all preprocessing should move into Typst plugins.

For this repo specifically, a Typst plugin should now be treated as the next step only if we later need richer image metadata or binary parsing beyond what `measure(image(...))` can provide directly.

External scripts may still be simpler when the task needs:

- filesystem writes
- non-pure behavior
- broader automation outside the document model
- easier debugging than a Wasm plugin offers

So the decision rule should be:

- use a Typst plugin when the computation is pure, compile-time, and document-facing
- use external tooling when the work is orchestration-heavy or side-effectful

## Sources

- Typst official plugin docs: <https://typst.app/docs/reference/foundations/plugin/>
- Typst `read` docs: <https://typst.app/docs/reference/data-loading/read/>
- `typwire:0.1.0` package page: <https://typst.app/universe/package/typwire/>
- `typwire` Rust crate docs: <https://docs.rs/typwire/latest/typwire/>
