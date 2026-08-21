# math-skill

A research-partner skill for deriving mathematics. The partner has the user state falsifiable conjectures before any explanation. It requires complete proofs. It keeps a journal of claims and their status. It seals results in Lean 4.

## Install the skill

```bash
# from a local checkout
npx skills add ./math-skill

# from GitHub
npx skills add monotykamary/math-skill
```

## What's inside

- `SKILL.md`: the covenant, the session loop, the journal format, the Lean loop, and the voice rules.
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
- `references/case-extremes.md`: block maxima and the three limit laws. Where heavy tails kill the tilt and what replaces it.
- `lean/`: a Lean 4 sandbox pinning `leanprover/lean4:v4.33.0` with Mathlib. `Frontier/Proven.lean` certifies the EWMA results. `Frontier/Conjectures.lean` closes the original six conjectures and holds two open watch-list entries.

Curriculum order: ewma, kalman, kelly, gibbs, large-deviations, gaertner-ellis, heat-kernel, mixing, max-principle, burgers, black-scholes, merton, h-theorem, kolmogorov, extremes.

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
