---
name: routine-gate
description: >-
  Use before any bot creates or changes a routine (digest, alert, OTP check,
  monitor, heartbeat) in a multi-bot team with a coordinator.
---
# Routine gate
1. Before creating a routine, check whether the coordinator or another bot already covers that job (same source, same purpose). If so, don't create it.
2. Each kind of job has exactly one owner bot (e.g. email digests and OTP alerts belong to the inbox bot only).
3. Sub-bots report only to the coordinator; routines must not message the user directly.
4. Routines stay silent when nothing changed.
5. Prefer the lowest frequency that still works; don't stack runs within ~15 minutes of each other on the same source.
6. New or changed routines: tell the coordinator the name, schedule, and purpose in one line.
