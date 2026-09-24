# math-skill

A research-partner skill for deriving mathematics. The partner has the user state falsifiable conjectures before any explanation. It requires complete proofs. It keeps a journal of claims and their status. It seals the finite rational results in Bend with exact arithmetic.

## Install the skill

```bash
# from a local checkout
npx skills add ./math-skill

# from GitHub
npx skills add monotykamary/math-skill
```

## What's inside

- `SKILL.md`: the covenant, the session loop, the journal format, the Bend loop, and the voice rules.
- `references/case-ewma.md`: exponential accumulation, proved completely. Closed form, fixed point, crossing time, threshold feedback.
- `references/case-kalman.md`: sequential estimation. Gaussian conditioning, the Riccati fixed point, and the EWMA as its stateless shadow.
- `references/case-kelly.md`: the Kelly criterion. Log-optimal growth, edge as information.
- `references/case-gibbs.md`: maximum entropy and the Gibbs tilt. The rate function is an entropy deficit.
- `references/case-large-deviations.md`: Chernoff and Cramér. Thresholds decay exponentially, and the rate is a Legendre transform.
- `references/case-gaertner-ellis.md`: thresholds with memory and ruin. The threshold EWMA's exact log-mgf, and the Cramér–Lundberg exponent.
- `references/case-heat-kernel.md`: graph heat diffusion, derived completely. Averaging, Laplacian, heat equation, Chebyshev evaluation. Contains a conjecture refuted by computation.
- `references/case-mixing.md`: how a lazy cycle walk forgets its start. Spectral gap, chi-square decay, certified mixing time.
- `references/case-max-principle.md`: the parabolic maximum principle as a theorem. Heat cannot create hot spots.
- `references/case-burgers.md`: shocks and entropy conditions. Cole–Hopf turns Burgers into heat; the tanh viscous profile pays its bill exactly.
- `references/case-black-scholes.md`: pricing from Brownian motion. The pricing equation is the heat equation.
- `references/case-merton.md`: continuous-time Kelly. The HJB equation, and half-Merton keeping three quarters.
- `references/case-h-theorem.md`: kinetic theory on a finite grid. Entropy never decreases; the bridge to Boltzmann is staked out.
- `references/case-kolmogorov.md`: K41 turbulence from units alone, the 4/5 law, and the intermittency anomaly.
- `references/case-navier-stokes.md`: OpenAI's September 2026 proposed forced breakdown result for Clay (C)/(D). Primary sources, worked energy and concentration calculations, and a pinned Lean audit. The external proof has not been independently checked here.
- `references/case-extremes.md`: block maxima and the three limit laws. Where heavy tails kill the tilt and what replaces it.
- [`bend/`](bend/README.md): the default first-party verifier, pinned to Bend 2.0.27. Seventeen checked public laws cover exact rational EWMA, finite probability in Lean's filtered and maximum forms, the Kalman gain complement, and a square-root-free rational mixing bound. Binary arithmetic has no fixed word-size limit. `python3 bend/check.py` is the certificate gate.
- `lean/`: the unchanged historical Lean 4 / Mathlib sandbox at `v4.33.0`. Its ten completed rational claims remain available for comparison. The original Kalman gain and real-valued mixing goals still contain `sorry` there. Bend proves the gain complement over the rationals and a rational form of the mixing goal; the Lean files are not changed by either.
- [`vendor/openai-navier-stokes/`](vendor/openai-navier-stokes/README.md): the complete, unmodified OpenAI Navier–Stokes and Euler Lean source bundle at a pinned revision, with its Apache-2.0 license, retained author credits, and checksum manifest. It is a separate Lean project; its proofs have not been checked locally.

Curriculum order: ewma, kalman, kelly, gibbs, large-deviations, gaertner-ellis, heat-kernel, mixing, max-principle, burgers, black-scholes, merton, h-theorem, kolmogorov, navier-stokes, extremes.

## Bend setup and verification

Install **Bend 2.0.27** from [Bend upstream](https://bend-lang.com/) and Python 3.10 or newer. The gate checks `bend/bend-version` and refuses other compiler versions.

```bash
bend version
bend guide
python3 bend/check.py
python3 -m unittest discover -s bend/tests -v
```

The test suite checks generated-proof reproducibility, rejection of unsafe/open proofs, and exact arithmetic against Python's `Fraction`, including values above 2^80. Native runtime tests require a working clang 14+ and report a skip when it is unavailable. See [`bend/README.md`](bend/README.md) for representations, theorem mappings, and performance limits. The original real-analysis claims remain outside this certificate.

## Optional historical Lean setup (macOS)

```bash
# toolchain manager + Lean (already pinned by lean/lean-toolchain)
curl https://elan.lean-lang.org/elan-init.sh -sSf | sh -s -- -y
export PATH="$HOME/.elan/bin:$PATH"

cd lean
lake update          # resolves Mathlib at the pinned toolchain tag
lake exe cache get   # downloads precompiled Mathlib (one-time, large)
lake build           # historical sandbox; two declared sorry goals remain
```

Gotcha: `lake clean` invalidates the downloaded Mathlib cache. If a build suddenly recompiles thousands of `Mathlib.*` modules, stop it and run `lake exe cache get && lake build`.

## Third-party proof attribution

The vendored formalizations are credited to OpenAI, with the Formal Conjectures authors credited for adapted statements and definitions. See [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) for attribution and the preserved license. The [vendor README](vendor/openai-navier-stokes/README.md) records the exact revision, copy-integrity checks, and separate build instructions. The full upstream bundle adds about 32 MB of source; downloaded dependencies and compiled caches are excluded.

## The session in one paragraph

The partner locates the last result the user can prove alone. It frames one target above that floor. The user states a falsifiable conjecture. Small computations promote the conjecture to SUPPORTED. A complete derivation or a clean `python3 bend/check.py` certificate for that claim promotes it to PROVEN, and the journal records it in his own words. After three strikes on one wall, the partner changes the representation before changing the claim.
