---
name: eta-and-late-ping
description: >-
  Use when starting or delegating any job that takes more than a few minutes, so
  the user never has to ask whether it's done.
---
# ETA and late ping
1. When starting or delegating a long job, state an ETA in minutes (e.g. ~20 min), based on a realistic estimate.
2. When delegating to another bot, require it to report by the ETA: done, or a new ETA with the reason.
3. If the ETA passes with no result, check the real state (process, files, worker status) before saying anything.
4. Proactively tell the user in one line: what is late, why, and the new ETA. Never claim it's still working without checking.
5. If it's stuck or failed, say so plainly and give the next step.
6. Deliver the result as soon as it lands; don't wait to be asked.
