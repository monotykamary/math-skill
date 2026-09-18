# Exact Bend sandbox

Bend **2.0.5** is the default first-party verifier. Python **3.10+** runs the gate and tests. Neither Lean nor Mathlib is needed for this sandbox.

```sh
python3 bend/check.py
python3 -m unittest discover -s bend/tests -v
```

The gate checks 11 public laws across the local proof dependency closure. It rejects changed compiler versions, missing public proofs, unused production modules, unsafe declarations, holes, floating-point/effectful certificate code, external imports, and any checker result other than `All terms check.`. Bend's exit status alone does not suffice: `@unsafe` definitions can exit zero with a warning.

## What is proved

`LAWS.bend` is the mathematical contract. `PROOF.bend` supplies its paired definitions. Review domain or hypothesis changes explicitly; do not weaken a law to obtain a green gate.

| Public law | Scope and historical counterpart |
|---|---|
| `heat_closed` | Original recurrence and closed form, all signed rational inputs and all natural step counts |
| `heat_fixture_four` | Exact 15/16 fixture |
| `heat_crossing_fixture` | Exact 3/2 input, 1/2 retention, 9/10 threshold crossing |
| `heat_capped_lane_below_one` | Strict bound at every finite step, with positive gap 1/2^n |
| `geom_sum` | Original finite geometric-sum identity |
| `heat_step_increment` | Original rational increment identity |
| `cool_contracts_deficit` | Original rational cooling identity |
| `cheb_two_of_recurrence` | Original degree-two Chebyshev identity; squaring is explicit multiplication |
| `markov_finset` | Finite-list generalization: any selected subset with certificates that selected values reach the threshold |
| `convex_avg_le_max` | Finite-list generalization: any certified common upper bound, with weights summing to one |
| `chi_tv_transfer_rat` | New rational analogue of the open real-valued mixing goal |

For Markov, `Finite.Samples` contains nonnegative weights and observations, a selection flag, and a separate `Above` hypothesis certificate. Selecting exactly the observations above the threshold gives the original filtered-set case. A threshold-filter builder is not supplied.

For convex averages, `Finite.Rows` contains nonnegative weights and arbitrary signed values. `AllBelow` certifies each value's bound; the theorem also takes an exact normalization proof. Choosing the maximum gives the original maximum case. A maximum-search builder is not supplied. Lists may repeat entries; a finite set is a special case. These formulations expose hypotheses formerly discharged by Mathlib.

The rational mixing theorem states, for any finite list of rational p_i and strictly positive rational u_i:

```text
(sum |p_i - u_i|)^2 <= (sum u_i) * (sum (|p_i - u_i|^2 / u_i))
```

`MomentProof.bend` proves weighted Cauchy–Schwarz by induction using a nonnegative sum-of-squares defect. `MixingProof.bend` transports that result through proved positive-division identities. No square root, floating-point tolerance, probability normalization, or analytic axiom is used. This does not discharge the original theorem over all real numbers.

## Exact representation and trust boundary

- `Exact/Natural.bend` defines an unbounded inductive natural-number model and proves its semiring laws by structural induction.
- `Exact/Binary.bend` implements canonical unbounded binary integers. `BinaryProof.bend` proves the denotation of increment, addition, and multiplication in that model.
- `Q.Number` represents `(positive - negative) / denominator`. Both numerator parts are binary naturals. The denominator has a strictly positive datatype, so zero denominators cannot be constructed.
- Fractions are not reduced. Use `Q.Eq`, not structural equality: 1/2 and 2/4 have different representations. `Q.Eq` wraps an exact natural cross-product equality. The wrapper prevents eager expansion of large unary numerals during theorem application. Congruence and transitivity are proved, including cancellation of the positive denominator.
- `Q.Le` carries a nonnegative rational slack and an equality certificate. `Q.Lt` carries a strictly positive slack. These are propositions with witnesses, not Boolean numerical tests.
- `Q.div_positive` is total division by a statically positive rational. General signed division is not part of this API.
- `Exact/Decision.bend` proves the soundness of binary cross-product reflection for concrete equality certificates. It does not accept unchecked host-language equality results.

The Python scripts in `tools/` are **untrusted proof generators**. Every generated step is checked by Bend against induction lemmas. They introduce no axioms and are not run by the certificate gate. Committed certificates can be checked without executing a generator. This still trusts Bend 2.0.5 and its bundled Base/checker. It is not an independent soundness audit or a proof of compiler correctness.

## Runtime limits

Numerators and denominators are not bounded by Bend's machine-word `Nat`. The runtime tests include signed arithmetic above 2^80 and the strict EWMA gap after 80 steps. `Nat` is used for iteration counts and the convenience constructor `Binary.from_nat`; Bend's runtime limit on those counts still applies.

Core binary addition and multiplication run directly on digits. Unreduced fractions can grow. `Magnitude.bend` deliberately uses a simple verified unary-model comparison and conversion for absolute values. It is exact but can be very slow or exhaust memory on large numeric magnitudes. It is a reference specification and proof foundation, not a high-performance mixing calculator. Binary comparison, reduction, and faster certified magnitude computation are future optimizations.

The tests compare executable arithmetic against Python `Fraction` on the JS backend. Native tests require clang 14+; an unavailable compiler is reported as a skip. GPU execution is not tested.

## Regenerate and extend

```sh
for script in bend/tools/build_*_proofs.py; do
  python3 "$script"
done
python3 bend/check.py
python3 -m unittest discover -s bend/tests -v
```

Regeneration is deterministic and tested in a temporary copy. New statements belong in `LAWS.bend`, paired proofs in `PROOF.bend`, and the reviewed public inventory in `check.py`. Keep unfinished claims in `OPEN.md`. Do not import an open claim into a certified module.

`../lean/` remains unchanged as a historical comparison, including its two original open goals. The OpenAI vendor tree, its audit case, attribution, and separate Lean build remain outside this sandbox.
