# Third-party notices

## OpenAI NavierStokesAndEuler

The source under [`vendor/openai-navier-stokes/upstream/`](vendor/openai-navier-stokes/upstream/)
is redistributed from [OpenAI's NavierStokesAndEuler repository][source]
at commit `8937a8f4cbc7abaab5e9e97d1cc7f5d2319d9538`.

The upstream [project metadata](vendor/openai-navier-stokes/upstream/formalization.yaml)
credits **OpenAI** as the author of the project and the papers *Finite
Time Blowup for Navier–Stokes* and *Finite Time Blowup for the Euler
equation*. This repository includes their formalizations as third-party
reference material. We do not claim authorship of those proofs. Inclusion
and attribution do not imply endorsement by OpenAI or other contributors.

The upstream source is licensed under the **Apache License, Version 2.0**.
The full, unchanged license is distributed at
[`vendor/openai-navier-stokes/upstream/LICENSE`](vendor/openai-navier-stokes/upstream/LICENSE).
That license governs the copied source; this notice does not relicense it
or impose new terms. The pinned snapshot contains no upstream `NOTICE`
file. All existing copyright, license, attribution, and modification
notices in the source have been retained.

### Formal Conjectures attribution

The bundle contains the following existing notice:

> Copyright 2026 The Formal Conjectures Authors.

It appears in these retained files:

- [`ComparatorChallenges/NavierStokes.lean`](vendor/openai-navier-stokes/upstream/ComparatorChallenges/NavierStokes.lean)
- [`ComparatorChallenges/Euler.lean`](vendor/openai-navier-stokes/upstream/ComparatorChallenges/Euler.lean)
- [`NavierStokes/ComparatorDefinitions.lean`](vendor/openai-navier-stokes/upstream/NavierStokes/ComparatorDefinitions.lean)
- [`Euler/SolutionDefinitions.lean`](vendor/openai-navier-stokes/upstream/Euler/SolutionDefinitions.lean)

These files identify adaptations from the
[Formal Conjectures project][formal-conjectures] and carry Apache-2.0
notices. Their upstream notices identifying those adaptations are also
preserved. The upstream [Comparator README](vendor/openai-navier-stokes/upstream/ComparatorChallenges/README.md)
acknowledges the Formal Conjectures authors for the reference statement.

### Local redistribution record

Imported on 2026-09-09. The complete tracked upstream tree is copied
without modifications, including the companion Euler proof and upstream
build files. Local provenance documentation and a checksum manifest live
outside `upstream/`; see the [vendor README](vendor/openai-navier-stokes/README.md)
and [UPSTREAM.json](vendor/openai-navier-stokes/UPSTREAM.json).

The copy excludes Git history, downloaded dependencies, and compiled
artifacts. Dependencies fetched later through Lake retain their own
licenses. This import has not been certified by a local Lean build or
independent proof check.

[source]: https://github.com/openai/NavierStokesAndEuler/tree/8937a8f4cbc7abaab5e9e97d1cc7f5d2319d9538
[formal-conjectures]: https://github.com/google-deepmind/formal-conjectures/blob/8bf45ed70d48b2b2a501de9c00b26bfa38c573ee/FormalConjectures/Millenium/NavierStokes.lean
