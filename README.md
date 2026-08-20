# math-skill — `math-schema`

A tutor skill for learning mathematics like a physicist: conjecture first,
never skip a proof step, keep a falsifiable journal, and let Lean 4 be the
incorruptible verifier. Built for learners who are tired of chatbots that
hand over the punchline.

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
- `references/case-heat-kernel.md` — graph heat diffusion, derived
  completely (averaging → Laplacian → heat equation → Chebyshev evaluation,
  including a conjecture refuted by computation).
- `lean/` — a Lean 4 sandbox pinning `leanprover/lean4:v4.33.0` with
  Mathlib, containing the same case as machine-checked proofs plus
  `sorry`-marked exercises.

## Lean setup (macOS)

```bash
# toolchain manager + Lean (already pinned by lean/lean-toolchain)
curl https://elan.lean-lang.org/elan-init.sh -sSf | sh -s -- -y
export PATH="$HOME/.elan/bin:$PATH"

cd lean
lake update          # resolves Mathlib at the pinned toolchain tag
lake exe cache get   # downloads precompiled Mathlib (one-time, large)
lake build           # verifies MathTutor/ — must stay green, no sorry
```

## The loop in one paragraph

Diagnose what the learner owns. Frame a target without spoilers. He
hypothesizes in falsifiable form; small computations promote the conjecture
to SUPPORTED; a complete derivation or a green `lake build` promotes it to
PROVEN and it lands in `math-journal.md`. Intuition is quoted in his words
after the computation, never handed to him before. When stuck three times,
change the representation, not the claim.
