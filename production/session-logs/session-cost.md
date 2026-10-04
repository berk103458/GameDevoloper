# Session Subagent Cost

**Session:** `c5ad507d-65a5-5f99-ae43-45082858bd06`  
**Updated:** 20261004_150104

Subagent spawns this session: **18**

| Agent | Spawns |
|-------|--------|
| art-director | 6 |
| qa-lead | 4 |
| technical-artist | 3 |
| systems-designer | 2 |
| ux-designer | 1 |
| sound-designer | 1 |
| narrative-director | 1 |

Each spawn is a fresh context window that re-reads its own inputs.
To reduce this: lower `modes.review_mode` (`/settings modes.review_mode=solo`)
or `modes.rigor` (`/settings modes.rigor=minimal`).
