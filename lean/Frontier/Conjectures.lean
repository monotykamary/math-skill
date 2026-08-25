import Frontier.Proven
import Mathlib.Algebra.Order.Ring.Star
import Mathlib.Analysis.Real.Sqrt
import Mathlib.Data.Rat.Star
import Mathlib.Tactic.Ring

/-!
# Conjectures

The six original conjectures below are closed: no sorries survive the
classic belt. The debt has moved outward, following the new reference
cases. Each comment names the move; the moves come from the reference
derivations, not from thin air.
-/

namespace Frontier

/-- Conjecture 1 (closed): the geometric identity from case-ewma.md §2.
Hand proof there: induction. -/
theorem geom_sum (ρ : ℚ) (k : ℕ) :
    (1 - ρ) * ∑ i ∈ Finset.range k, ρ ^ i = 1 - ρ ^ k := by
  induction k with
  | zero => simp
  | succ k ih =>
      rw [Finset.sum_range_succ, mul_add, ih]
      ring

/-- Conjecture 2 (closed): the one-step increment, case-ewma.md §3.
Two rewrites by heat_closed, then algebra. -/
theorem heat_step_increment (s ρ : ℚ) (n : ℕ) :
    heat s ρ (n + 1) - heat s ρ n = s * (1 - ρ) * ρ ^ n := by
  rw [heat_closed, heat_closed]
  ring

/-- Conjecture 3 (closed): cooling between related prompts.
One turn without input applies the linear contraction w -> ρ * w, so
every distance shrinks by exactly ρ: the deficit against the image of
any reference value is multiplied by ρ. Deficit to a held fixed point
is the ewma case with the reference at the future fixed point. -/
def cool (ρ w : ℚ) : ℚ := ρ * w

theorem cool_contracts_deficit (s ρ w : ℚ) : cool ρ w - cool ρ s = ρ * (w - s) := by
  unfold cool
  rw [mul_sub]

/-- Conjecture 4 (closed): first contact with the Chebyshev side of
case-heat-kernel.md. The three-term recurrence defines the polynomials;
this identity is the first one it must reproduce. -/
def cheb₁ (x : ℚ) : ℚ := 2 * x ^ 2 - 1

theorem cheb₂_of_recurrence (x : ℚ) : cheb₁ x = 2 * x * x - 1 := by
  unfold cheb₁
  ring

/-- Conjecture 5 (closed, case-large-deviations.md §1): Markov's
inequality on a finite probability space with ℚ-valued weights. The
indicator trick is the whole engine: on the threshold-filtered part,
every X i sits above a, and the rest of the sum is nonnegative slack. -/
theorem markov_finset {ι : Type*} [DecidableEq ι] (s : Finset ι) (w X : ι → ℚ)
    (hw : ∀ i ∈ s, 0 ≤ w i) (hX : ∀ i ∈ s, 0 ≤ X i) (a : ℚ) :
    a * (∑ i ∈ s with a ≤ X i, w i) ≤ ∑ i ∈ s, w i * X i := by
  calc
    a * (∑ i ∈ s with a ≤ X i, w i) ≤ ∑ i ∈ s with a ≤ X i, w i * X i := by
      rw [Finset.mul_sum]
      refine Finset.sum_le_sum ?_
      intro i hi
      have his : i ∈ s := (Finset.mem_filter.mp hi).1
      have haX : a ≤ X i := (Finset.mem_filter.mp hi).2
      have hmul : a * w i ≤ X i * w i := mul_le_mul_of_nonneg_right haX (hw i his)
      rwa [mul_comm (X i) (w i)] at hmul
    _ ≤ ∑ i ∈ s, w i * X i := by
      refine Finset.sum_le_sum_of_subset_of_nonneg ?_ ?_
      · exact Finset.filter_subset (fun i => a ≤ X i) s
      · intro i his _hin
        exact mul_nonneg (hw i his) (hX i his)

/-- Conjecture 6 (closed, case-max-principle.md §4): a convex average
never exceeds the image max. Bound each product by the weight times the
max, sum, close with the normalization. -/
theorem convex_avg_le_max {ι : Type*} [DecidableEq ι] (s : Finset ι) (hs : s.Nonempty)
    (w v : ι → ℚ) (hw : ∀ i ∈ s, 0 ≤ w i) (hsum : ∑ i ∈ s, w i = 1) :
    ∑ i ∈ s, w i * v i ≤ (s.image v).max' (hs.image v) := by
  let M : ℚ := (s.image v).max' (hs.image v)
  calc
    ∑ i ∈ s, w i * v i ≤ ∑ i ∈ s, w i * M := by
      refine Finset.sum_le_sum ?_
      intro i hi
      have hmem : v i ∈ s.image v := Finset.mem_image.mpr ⟨i, hi, rfl⟩
      have hle : v i ≤ M := by
        dsimp [M]
        rw [← congrArg (fun h : (s.image v).Nonempty => (s.image v).max' h)
          (Subsingleton.elim ⟨v i, hmem⟩ (hs.image v))]
        exact Finset.le_max' (s.image v) (v i) hmem
      exact mul_le_mul_of_nonneg_left hle (hw i hi)
    _ = (∑ i ∈ s, w i) * M := by rw [Finset.sum_mul]
    _ = M := by rw [hsum, one_mul]

/- The open watch list follows the new reference cases, one per line. -/

/-- Open 7 (case-kalman.md §2): the Kalman gain complement.
The posterior variance update P' = P R/(P+R) pairs with the gain
K = P/(P+R) through 1 - K = R/(P+R). Moves: div_self, sub_div, ring
mind the p+r nonzero hypothesis; it is exactly the denominator the
closed form divides by. -/
theorem gain_complement (p r : ℚ) (hpr : p + r ≠ 0) :
    r / (p + r) = 1 - p / (p + r) := by
  sorry

/-- Open 8 (case-mixing.md §4): the total variation to chi-square
transfer. This is the Cauchy-Schwarz step that turns the spectral
decay of chi-square into the mixing time bound; over ℝ with the
uniform normalization. Moves: sq nonneg, the Finset Cauchy-Schwarz
form sum_sq_mul? plus ordering; the reference proof is one
Cauchy-Schwarz application. -/
theorem chi_tv_transfer {ι : Type*} [Fintype ι] (p u : ι → ℝ)
    (hupos : ∀ i, 0 < u i) :
    (∑ i, |p i - u i|) ^ 2 ≤ (∑ i, u i) * (∑ i, (|p i - u i| / Real.sqrt (u i)) ^ 2) := by
  sorry

end Frontier
