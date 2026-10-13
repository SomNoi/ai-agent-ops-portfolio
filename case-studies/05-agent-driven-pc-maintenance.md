# Case study 5: Agent-driven PC maintenance, safely

## Problem
The home PC's C: drive had only **7.2 GB free**, which caused instability, including for the agent running on it. Letting an AI "clean up" a drive is risky.

## Approach (agent executes, human approves)
1. **Inspect read-only:** size named folders one at a time with timeouts. No whole-drive scans.
2. **Safety net first:** a System Restore point, a changelog of every action, and an **undo script** generated before any change.
3. **Propose:** list each candidate with its size and risk. The human approves exact items.
4. **Act conservatively:** use built-in cleanup for caches and temp files, and **move-only** organization for personal files (moved, never deleted).
5. **Verify:** re-measure free space, then report in the standard format with before and after values.

## Outcome
- C: free space went from **7.2 GB to about 26–30 GB**, with no data loss and every step reversible through the undo script.

## Lessons
- For agents, *reversibility* is the key safety property: restore point, changelog, undo script, and moves instead of deletes.
- The low-disk guard rule (warn under 5 GB, write nothing big under 2 GB) stops this problem from recurring silently.
