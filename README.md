# math-skill — `math-schema`

A mentorship skill for proving mathematics like a working researcher:
conjecture first, never skip a proof step, keep a falsifiable journal, and
let Lean 4 be the incorruptible verifier. Built for people who intend to
reach the frontier, not people who want the punchline handed to them.

## Install the skill

```bash
# from a local checkout
npx skills add ./math-skill

# once pushed to GitHub
npx skills add <owner>/math-skill
```

## What's inside

- `SKILL.md` — the tutor covenant, session loop, journal format, Lean loop.
- `references/case-ewma.md` — exponential accumulation, proved completely
  (closed form, fixed point, crossing time, threshold feedback).
- `references/case-kelly.md` — the Kelly criterion: log-optimal growth,
  edge = information (quant).
- `references/case-large-deviations.md` — Chernoff/Cramér: thresholds
  decay exponentially; rate = Legendre transform (probability, risk).
- `references/case-heat-kernel.md` — graph heat diffusion, derived
  completely (averaging → Laplacian → heat equation → Chebyshev evaluation,
  including a conjecture refuted by computation).
- `references/case-max-principle.md` — the parabolic maximum principle:
  heat cannot create hot spots, as a theorem (PDE rigor).
- `references/case-black-scholes.md` — Black–Scholes from Brownian motion;
  the pricing PDE is the heat equation (finance capstone).
- `references/case-kolmogorov.md` — K41 turbulence from units alone; the
  4/5 law; intermittency and the C^{1/3} threshold (physics frontier).

Curriculum order: ewma → kelly → large-deviations → heat-kernel →
max-principle → black-scholes → kolmogorov.
- `lean/` — a Lean 4 sandbox pinning `leanprover/lean4:v4.33.0` with
  Mathlib: `Frontier/Proven.lean` seals the EWMA case's results as checked
  theorems; `Frontier/Conjectures.lean` holds six `sorry`-marked conjectures.

## Lean setup (macOS)

```bash
# toolchain manager + Lean (already pinned by lean/lean-toolchain)
curl https://elan.lean-lang.org/elan-init.sh -sSf | sh -s -- -y
export PATH="$HOME/.elan/bin:$PATH"

cd lean
lake update          # resolves Mathlib at the pinned toolchain tag
lake exe cache get   # downloads precompiled Mathlib (one-time, large)
lake build           # verifies Frontier/ — must stay green, no sorry
```

## The loop in one paragraph

Diagnose what the researcher owns. Frame a target without spoilers. He
hypothesizes in falsifiable form; small computations promote the conjecture
to SUPPORTED; a complete derivation or a green `lake build` promotes it to
PROVEN and it lands in `math-journal.md`. Intuition is quoted in his words
after the computation, never handed to him before. When stuck three times,
change the representation, not the claim.
