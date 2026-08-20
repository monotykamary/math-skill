# math-skill

A research-partner skill for deriving mathematics. The partner has the user state falsifiable conjectures before any explanation. It requires complete proofs. It keeps a journal of claims and their status. It seals results in Lean 4.

## Install the skill

```bash
# from a local checkout
npx skills add ./math-skill

# once pushed to GitHub
npx skills add <owner>/math-skill
```

## What's inside

- `SKILL.md`: the covenant, the session loop, the journal format, the Lean loop, and the voice rules.
- `references/case-ewma.md`: exponential accumulation, proved completely. Closed form, fixed point, crossing time, threshold feedback.
- `references/case-kelly.md`: the Kelly criterion. Log-optimal growth, edge as information.
- `references/case-large-deviations.md`: Chernoff and Cramér. Thresholds decay exponentially, and the rate is a Legendre transform.
- `references/case-heat-kernel.md`: graph heat diffusion, derived completely. Averaging, Laplacian, heat equation, Chebyshev evaluation. Contains a conjecture refuted by computation.
- `references/case-max-principle.md`: the parabolic maximum principle as a theorem. Heat cannot create hot spots.
- `references/case-black-scholes.md`: pricing from Brownian motion. The pricing equation is the heat equation.
- `references/case-kolmogorov.md`: K41 turbulence from units alone, the 4/5 law, and the intermittency anomaly.
- `lean/`: a Lean 4 sandbox pinning `leanprover/lean4:v4.33.0` with Mathlib. `Frontier/Proven.lean` certifies the EWMA results. `Frontier/Conjectures.lean` holds six open conjectures.

Curriculum order: ewma, kelly, large-deviations, heat-kernel, max-principle, black-scholes, kolmogorov.

## Lean setup (macOS)

```bash
# toolchain manager + Lean (already pinned by lean/lean-toolchain)
curl https://elan.lean-lang.org/elan-init.sh -sSf | sh -s -- -y
export PATH="$HOME/.elan/bin:$PATH"

cd lean
lake update          # resolves Mathlib at the pinned toolchain tag
lake exe cache get   # downloads precompiled Mathlib (one-time, large)
lake build           # verifies Frontier/ (green, no unexpected sorry)
```

Gotcha: `lake clean` invalidates the downloaded Mathlib cache. If a build suddenly recompiles thousands of `Mathlib.*` modules, stop it and run `lake exe cache get && lake build`.

## The session in one paragraph

The partner locates the last result the user can prove alone. It frames one target above that floor. The user states a falsifiable conjecture. Small computations promote the conjecture to SUPPORTED. A complete derivation or a green `lake build` promotes it to PROVEN, and the journal records it in his own words. After three strikes on one wall, the partner changes the representation before changing the claim.
