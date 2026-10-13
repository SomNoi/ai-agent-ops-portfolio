# Case study 3: Self-healing agents on Windows

## Problem
Self-hosted agents on Windows went offline silently after reboots, crashes, or failed updates. Nobody noticed until a task was missed.

## What I did
- **Boot autostart** through Windows Task Scheduler (runs at logon as the agent's own user).
- **5-minute watchdog task** that checks whether the gateway process is alive and responding and restarts it if not. A sanitized, generalized version is in [../examples/watchdog.ps1](../examples/watchdog.ps1); it adds a restart back-off and a resume note as reusable hardening.
- **Kill-tests:** I killed the agent on purpose and measured recovery. It came back in about **20 s** in one scenario and about **140 s** in another (detection within the watchdog interval, plus restart).
- **Resume-after-restart notes:** after any restart, the agent's first message states the last task, its state, and that it did *not* retry automatically.
- **Health alerts** for low RAM and low disk, raised before they cause crashes.
- **Timezone/cron fixes:** schedules defined in an explicit timezone, so routines stop firing at the wrong hour.

## Root-cause work
| Symptom | Root cause | Fix |
|---|---|---|
| Agent started but had no config/skills | Task ran as **SYSTEM**, so its home folder pointed at the wrong profile | Run the task as the agent's interactive user |
| Update failed half-way | Running process **locked the Python venv** files | Stop the gateway and watchdog, update, then restart and verify |
| Version drift | Old builds (v0.20 / v0.21.3) | Upgraded to **v0.21.7** with verification steps |

## Outcomes
- Agents come back without a human after crashes and reboots, verified by kill-tests.
- Failures are reported in an incident format (`INCIDENT / CONTAINED / CAUSE / IMPACT / NEXT`) instead of retried in a loop.

## Lessons
- Test recovery by actually killing the process. Uptime claims without a kill-test are guesses.
- A watchdog needs a back-off, or it turns a broken update into a restart storm.
