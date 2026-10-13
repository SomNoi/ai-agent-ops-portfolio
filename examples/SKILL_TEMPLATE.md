---
name: my-skill-name            # kebab-case, unique
description: "One line: WHEN to use this skill (the trigger), not what it is"
version: 1.0.0
metadata:
  hermes:                      # optional; Hermes Agent reads this block
    tags: [workflow, example]
    category: my-team
---

# <Skill title>

## When to Use
- Trigger 1 (e.g. "user asks to free up disk space")
- Trigger 2
- NOT for: <nearby tasks that should use another skill>

## Risk level
READ-ONLY | CHANGE (needs approval for the exact action) | FORBIDDEN without explicit approval

## Procedure
1. Restate the goal in one line and what "done" looks like.
2. Check preconditions (disk space, running jobs, credentials present *by name only*).
3. Read-only inspection: <exact safe commands, each with a timeout>.
4. Propose the change: list items, size/impact, and how to undo it. Wait for approval.
5. Act: <exact steps>. Log every change to a changelog.
6. Verify with a read-only re-check.
7. Report (format below).

## Report format
```
RESULT: done | partial | failed | blocked: <one line>
DONE: ...
CHANGED: <item>: before -> after   (or "nothing changed")
FAILED: <error>                     (or "none")
VERIFIED: <how>
NEXT: <next step / approval needed>
```

## Pitfalls
- <Known way this goes wrong, and what to do instead>
- Never print secrets; refer to them by name and mask them (****1234).

## Verification
<One sentence a reviewer can check to confirm the skill was followed.>
