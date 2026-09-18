# Math journal

The research partner reads this file at session start and appends at every
phase change. COMMITTED requires a complete proof or a clean
`python3 bend/check.py` certificate for the exact claim.
SUPPORTED means numeric or special-case evidence. HYPOTHESIZED means
falsifiable and untested. GAP entries open the next session.

## Claims awaiting verification

1. Equal-weight average heat converges to step-input regardless of start.
   Weighted accumulation cannot be blank, so eventually everything is heat.
2. HYPOTHESIZED: scores accumulate along a conversation. Some conversations
   can lock under silence.

Claim 1 is PROVEN and formalized; see the certificate log and
`lean/Frontier/Proven.lean`. Claim 2 is open.

## Bend verifier migration

- VERIFIED: `python3 bend/check.py` checks 11 public laws. The existing rational EWMA claims and the finite Markov/convex bounds have Bend certificates. The finite-carrier and hypothesis formulations are documented in `bend/README.md`.
- VERIFIED: `chi_tv_transfer_rat` proves the square-root-free inequality for finite rational observations with strictly positive rational reference weights. Certificate: `bend/LAWS.bend#chi_tv_transfer_rat`.
- GAP: the original real-valued `chi_tv_transfer` and the unrestricted Kalman `gain_complement` remain open. See `bend/OPEN.md`. No real-analysis certificate follows from the rational theorem.
- IMPLEMENTATION NOTE: these entries record verifier migration, not new learning accomplishments or an intuition attributed to the user. Historical Lean files and OpenAI's separate artifacts are unchanged.
