# Vendored OpenAI Navier–Stokes and Euler formalizations

This directory redistributes the Lean source from
[OpenAI's NavierStokesAndEuler repository][source]. OpenAI is credited as
the author of the project and papers in the upstream
[formalization metadata](upstream/formalization.yaml). The Formal
Conjectures authors are credited for adapted reference statements and
definitions. See [third-party notices](../../THIRD_PARTY_NOTICES.md).

## Provenance and scope

- Commit: `8937a8f4cbc7abaab5e9e97d1cc7f5d2319d9538`.
- Git tree: `8163a2fac282a90cc60b5afbc1f0dc7b2e5c6755`.
- Imported: 2026-09-09.
- License: [Apache License 2.0](upstream/LICENSE).
- Inventory: 2,496 upstream files, including 2,486 Lean files; 32,461,273
  bytes of upstream file content.
- Local changes to upstream files: **none**.

`upstream/` is the complete tracked source tree at that commit. It retains
both the Navier–Stokes and companion Euler developments, Comparator
challenges, original documentation, license, and build configuration.
Keeping the bundle intact preserves the upstream default build targets
and attribution. There is no nested Git repository or submodule.

Git history, downloaded dependencies, and compiled caches are not copied.
Lake resolves dependencies from the preserved
[`lake-manifest.json`](upstream/lake-manifest.json). Those dependencies
have their own licenses; they are outside this source snapshot.

This README, `UPSTREAM.json`, and `SHA256SUMS` were added by math-skill and
sit outside the unchanged upstream tree. The machine-readable provenance
is in [UPSTREAM.json](UPSTREAM.json).

## Check the copy

From the math-skill repository root, using `shasum` (Perl Digest::SHA):

```bash
cd vendor/openai-navier-stokes/upstream
shasum -a 256 -c ../SHA256SUMS
```

The manifest covers every upstream file, including the license and
copyright headers. It detects changed or missing listed files; it does
not detect additional files. Compare the complete inventory with the
pinned Git tree when refreshing the snapshot. Checksums establish copy
integrity, not proof correctness or upstream authorship by themselves.

## Build and inspect the proof

The vendored project pins Lean `v4.34.0-rc2`. Keep this separate from the
skill's learning sandbox in `lean/`, which pins `v4.33.0`. Do not add these
files to `Frontier` or change the sandbox toolchain to accommodate them.

Review the source and dependencies before execution. With `elan`
installed, start from the math-skill repository root:

```bash
cd vendor/openai-navier-stokes/upstream
lake exe cache get
lake build NavierStokes
lake env lean NavierStokes/ComparatorSolution.lean
```

The last command checks the submission adapter and prints its axiom
reports. To build all upstream default targets, including Euler and the
reference challenge modules, run `lake build` in the same directory.
Downloads and compilation can require substantial time, disk, and memory.

For independent proof checking, follow the preserved
[Comparator setup instructions](upstream/ComparatorChallenges/README.md).
They require `landrun`, `lean4export`, and `nanoda_bin` on `PATH`. From the
same upstream project directory:

```bash
lake exe comparator ComparatorChallenges/NavierStokes.json
```

The reference challenge files intentionally contain `sorry` placeholders.
The submitted proof adapters use separate definitions. Inspect the actual
solution dependency closure and axiom reports. A raw placeholder count
across the bundle is not a verdict on the submitted proofs.

## Verification status

At import, the source files were compared byte-for-byte with the pinned
upstream checkout and their checksums were checked. **The Lean build and
Comparator proof checks have not been run locally.** Statements about
proof completion in upstream documentation and metadata are upstream's
reports. Vendoring does not promote the result to a locally PROVEN or
COMMITTED journal entry. Follow the
[case study's audit checklist](../../references/case-navier-stokes.md).

## Updates and modifications

Treat `upstream/` as read-only. Fetch a specific revision into a separate
checkout, review its license and notices, then export its complete tracked
tree. Regenerate the manifest and update the provenance, attribution,
case-study pin, and verification status together. Review the source diff
before accepting an update.

Retain the upstream license and all applicable notices on redistribution.
If an upstream file is modified locally, add a prominent notice in that
file identifying the changes, as required by Apache-2.0 section 4(b), and
record the modification in `UPSTREAM.json`. Prefer separate local wrappers
and documentation to avoid changing the proof snapshot.

[source]: https://github.com/openai/NavierStokesAndEuler/tree/8937a8f4cbc7abaab5e9e97d1cc7f5d2319d9538
