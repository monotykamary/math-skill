# Math journal

The research partner reads this file at session start and appends at every
phase change. COMMITTED requires a complete proof or a green `lake build`.
SUPPORTED means numeric or special-case evidence. HYPOTHESIZED means
falsifiable and untested. GAP entries open the next session.

## Claims awaiting verification

1. Equal-weight average heat converges to step-input regardless of start.
   Weighted accumulation cannot be blank, so eventually everything is heat.
2. HYPOTHESIZED: scores accumulate along a conversation. Some conversations
   can lock under silence.

Claim 1 is PROVEN and formalized; see the certificate log and
`lean/Frontier/Proven.lean`. Claim 2 is open.
