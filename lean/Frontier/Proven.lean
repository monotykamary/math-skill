import Mathlib.Algebra.Order.Ring.Star
import Mathlib.Data.Rat.Star
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.NormNum.Ineq
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.Ring

/-!
# Proven: certified results

These theorems seal the hand proofs of `references/case-ewma.md` in Lean.
Read them as the standard for a COMMITTED entry: statement first, complete
proof, fixture checked by computation. No `sorry` lives here.
-/

namespace Frontier

/-- The heat accumulator from case-ewma.md §1:
`W₀ = 0` and `W_{n+1} = (1-ρ)·s + ρ·W_n` for constant input `s`. -/
def heat (s ρ : ℚ) : ℕ → ℚ
  | 0 => 0
  | n + 1 => (1 - ρ) * s + ρ * heat s ρ n

/-- Closed form (case-ewma.md §2): each step forgets a `(1-ρ)`-fraction of
the past, so after `n` steps what remains is the input times `1 - ρ^n`.
Compare the proof structure to the hand proof: same induction, same algebra. -/
theorem heat_closed (s ρ : ℚ) (n : ℕ) : heat s ρ n = s * (1 - ρ ^ n) := by
  induction n with
  | zero => simp [heat]
  | succ n ih =>
      rw [heat, ih]
      ring

/-- Fixture from the production documentation: at `ρ = 1/2`, `s = 1`,
heat after four continuous turns is `15/16 = 0.9375`. -/
theorem heat_fixture_four : heat 1 (1/2 : ℚ) 4 = 15/16 := by
  norm_num [heat_closed]

/-- Crossing fixture (case-ewma.md §4): at `ρ = 1/2`, `s = 3/2`, `θ = 9/10`
turn 1 is below threshold and turn 2 fires, the predicted `k_fire = 2`. -/
theorem heat_crossing_fixture :
    heat (3/2 : ℚ) (1/2) 1 < 9/10 ∧ 9/10 ≤ heat (3/2) (1/2) 2 := by
  constructor <;> norm_num [heat_closed]

/-- Case-ewma.md §5, half of the safety property: on the capped lane
(`s = 1`, `ρ = 1/2`), heat stays strictly below `1` on every finite turn,
so one smoke event raising the threshold to `1.125` bars it permanently. -/
theorem heat_capped_lane_below_one (k : ℕ) : heat 1 (1/2 : ℚ) k < 1 := by
  rw [heat_closed]
  have h : (0 : ℚ) < (1/2 : ℚ) ^ k := by positivity
  linarith

end Frontier
