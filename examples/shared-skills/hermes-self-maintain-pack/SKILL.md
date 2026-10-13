---
name: hermes-self-maintain-pack
description: >-
  Use when setting up, checking, or upgrading a self-hosted Hermes Agent
  gateway on Windows so it survives reboots, crashes and upgrades without a
  human. Generic checklist; pairs with examples/watchdog.ps1 and
  examples/register-tasks.ps1.
---
# hermes-self-maintain-pack

Keep a Hermes Agent gateway alive on a Windows host (home PC or VPS) with no babysitting.

## 1. Autostart + watchdog (Task Scheduler)
- [ ] **Boot task:** starts the gateway at logon/boot. See [`../../register-tasks.ps1`](../../register-tasks.ps1).
- [ ] **Watchdog task every 5 min:** runs [`../../watchdog.ps1`](../../watchdog.ps1); if the gateway process/port is gone, restart it and log the event.
- [ ] **Run both as the interactive user, NOT `SYSTEM`.** `SYSTEM` resolves home to `C:\Windows\System32\config\systemprofile`, so the agent loads the wrong config, memory and venv and appears "up" but empty.
- [ ] Set "Run only when user is logged on" (or equivalent) so the agent shares the user's profile and desktop.

## 2. Never sign out the logged-on session
- [ ] Disconnect RDP by closing the window — **never "Sign out"**. Sign-out kills the user's processes, including the gateway and watchdog.
- [ ] Disable idle-logoff policies on the host.

## 3. Resume note on boot
- [ ] On start, the agent reads a resume/handoff note (e.g. `HANDOFF.md`) and continues pending work. See [`../session-resume/SKILL.md`](../session-resume/SKILL.md) and [`../handoff/SKILL.md`](../handoff/SKILL.md).
- [ ] The watchdog writes a one-line "restarted at <time>, reason <x>" entry the agent can read.

## 4. Changelog file
- [ ] Keep a `CHANGELOG.md` (or similar) next to the agent config: every config change, upgrade, skill install, with date and rollback note.
- [ ] Back up any file before editing it (`file.bak_<date>`).

## 5. Health-alert cron
- [ ] A scheduled check (e.g. every 30–60 min) reports only when something is wrong: gateway down, RAM or disk above threshold, repeated restarts.
- [ ] Silent when healthy — no "all OK" spam.

## 6. Kill-test to verify (measure the revive)
- [ ] Kill the gateway process on purpose, note the time.
- [ ] Wait for the watchdog to bring it back; record **revive time in seconds** (expect up to one watchdog interval).
- [ ] Repeat after reboot: confirm the boot task alone brings it up.
- [ ] Only call the setup "verified" after both tests pass; otherwise report "unverified".

## 7. Upgrade pitfalls
- [ ] **Stop helper processes first.** Background helpers (MCP servers, browser bridges, Python workers) keep `.pyd`/`.dll` files in the venv locked, so `pip`/upgrade fails half-way. Disable the watchdog task, stop the gateway and every helper, then upgrade.
- [ ] **Normalize path slashes.** Mixed `\` and `/` in config paths can break lookups after an upgrade; pick one style and normalize before comparing or writing paths.
- [ ] Re-enable the watchdog, then re-run the kill-test.
- [ ] Log the upgrade (from → to version) in the changelog.

## 8. Keep replies short
- [ ] Status replies: verdict first, 1–3 lines. Short replies save tokens and keep the agent within budget on long-running hosts.

## Report format
`OK/FAIL · boot task · watchdog · last revive <N>s · disk <x>% · RAM <y>% · next step`
