import MathTutor.Warmup

/-!
# Exercises

Every `sorry` in this file is explicit debt. A session is COMMITTED only when
`lake build` is green with no `sorry` in the files you claim as done.
Work order: 1 → 4. Each comment names the move; the moves come from the
reference derivations, not from thin air.
-/

namespace MathTutor

/-- Exercise 1: the geometric identity from case-ewma.md §2.
Hand proof there: induction, with step `(1-ρ)(Σᵢ₌₀..k ρ^i) = (1-ρ^k) + (1-ρ)ρ^k`.
Lean moves: induction on `k`; rewrite the sum over `range (k+1)` as the sum
over `range k` plus one term (`Finset.sum_range_succ`); then algebra. -/
theorem geom_sum (ρ : ℚ) (k : ℕ) :
    (1 - ρ) * ∑ i ∈ Finset.range k, ρ ^ i = 1 - ρ ^ k := by
  sorry

/-- Exercise 2: the one-step increment, case-ewma.md §3.
`W_{n+1} - W_n = s(1-ρ)ρ^n`. Recommended path: two rewrites by `heat_closed`,
then algebra — this is the 'closed form makes it trivial' lesson. -/
theorem heat_step_increment (s ρ : ℚ) (n : ℕ) :
    heat s ρ (n + 1) - heat s ρ n = s * (1 - ρ) * ρ ^ n := by
  sorry

/-- Exercise 3: cooling between related prompts.
One turn of unrelated input contributes `s = 0`, so heat scales by `ρ`.
The deficit to the fixed point `s` scales by the same factor: unrelated
turns delay, they do not erase. Prove it from the definition of `cool`. -/
def cool (ρ w : ℚ) : ℚ := ρ * w

theorem cool_contracts_deficit (s ρ w : ℚ) : cool ρ w - s = ρ * (w - s) := by
  sorry

/-- Exercise 4: first contact with the Chebyshev side of case-heat-kernel.md.
Define the scalar Chebyshev polynomials by the three-term recurrence and
verify the first two nontrivial ones. `ring` closes goals built from the
unfolded definitions — the skill is naming what the goal looks like before
and after each move. -/
def cheb₁ (x : ℚ) : ℚ := 2 * x ^ 2 - 1

theorem cheb₂_of_recurrence (x : ℚ) : cheb₁ x = 2 * x * x - 1 := by
  sorry

/-- Exercise 5 (case-large-deviations.md §1): Markov's inequality on a
finite probability space with ℚ-valued weights. The indicator trick is the
whole engine: on the threshold-filtered part, replace `X i` by `a`.
Moves: monotonicity of `Finset.sum`, then bound the filtered sum by the
full one using the nonnegativity hypotheses. -/
theorem markov_finset {ι : Type*} [DecidableEq ι] (s : Finset ι) (w X : ι → ℚ)
    (hw : ∀ i ∈ s, 0 ≤ w i) (hX : ∀ i ∈ s, 0 ≤ X i) (a : ℚ) :
    a * (∑ i ∈ s with a ≤ X i, w i) ≤ ∑ i ∈ s, w i * X i := by
  sorry

/-- Exercise 6 (case-max-principle.md §4, discrete maximum principle): a
convex average never exceeds the sample max — the fact behind 'heat cannot
create hot spots' on a graph. Moves: bound each product `w i * v i` by
`w i` times the image max (weights are nonneg), sum, close with the
normalization `hsum`. -/
theorem convex_avg_le_max {ι : Type*} [DecidableEq ι] (s : Finset ι) (hs : s.Nonempty)
    (w v : ι → ℚ) (hw : ∀ i ∈ s, 0 ≤ w i) (hsum : ∑ i ∈ s, w i = 1) :
    ∑ i ∈ s, w i * v i ≤ (s.image v).max' (hs.image v) := by
  sorry

end MathTutor
