# Open scope

These entries are debt, not imported axioms or certified laws.

## Unrestricted Kalman gain complement

Historical statement: `r / (p + r) = 1 - p / (p + r)` for arbitrary rational p, r with p + r nonzero. The original `lean/Frontier/Conjectures.lean#gain_complement` still contains `sorry`.

Bend currently provides division only by a `Q.Positive` value. Closing the unrestricted statement needs a certified nonzero signed divisor representation and its inversion laws. The existing positive-division cancellation certificates cover a prerequisite, not the full claim.

## Real-valued mixing transfer

The original `chi_tv_transfer` over all real-valued p and u, using `Real.sqrt`, remains open in the historical Lean sandbox. `chi_tv_transfer_rat` proves the explicitly rational-domain replacement. Extending it to real numbers needs a real-number construction and appropriate algebra/order or approximation theorems.

## Further work

- Verified binary comparison and fast absolute values; the current exact magnitude specification traverses unary values.
- Fraction reduction and denominator-growth control with equality-preservation proofs.
- Certified threshold-filter and maximum-search builders for the explicit finite hypothesis certificates.
- General real analysis, limits, integration, spectral analysis, and PDE formalization.
- Independent review of Bend's proof foundation and compiler trust boundary.

No external/OpenAI proof claim is promoted to a local accomplishment by this migration.
