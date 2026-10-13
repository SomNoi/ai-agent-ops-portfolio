# Case study 2: Onboarding a new AI agent like an employee

## Problem
A freshly installed agent (Kaze, Hermes Agent on a Windows 11 home PC) behaved like an eager intern. It ran whole-drive scans that hung, retried failing commands in loops, and didn't give progress updates.

## Approach
I treated it as staff onboarding: a **handbook** (work rules) plus **standard operating procedures** (skills).

1. **WORK_RULES** appended to the agent's persistent system file (SOUL.md):
   - Operating loop: understand, check skills, plan with an ETA, inspect read-only, act within approval, verify, report.
   - Hard rules: command timeouts of 120 s or less, no whole-drive scans, "stop means stop", progress at least every 5 minutes, stop after 2 failures, secret masking, trading read-only, low-disk guard.
   - A routing table that maps each task type to the skill to load first.
   - A fixed final report: `RESULT / DONE / CHANGED / FAILED / VERIFIED / NEXT`.
2. **8 onboarding skills** (SKILL.md format): task-intake-and-plan, safe-windows-inspection, disk-cleanup-safe, mt5-readonly-status, progress-and-eta, secret-hygiene, failure-recovery, supervisor-report.
3. **Installer** (PowerShell, no admin): checks preconditions, backs up SOUL.md, appends the rules once (idempotent marker), copies the skills, warns on duplicate names, verifies the result, and documents a rollback.
4. **Verification script for the user:** list the skills, reload, start a new session, confirm the rules are loaded, and run a smoke test ("What is C: free space?").

Install paths and behavior were checked against the official Hermes documentation before shipping.

## Shared fleet skills library
Fleet-wide skills reused by every bot: **paste-block relay**, **ETA and late-ping**, **secret hygiene**, **data-source labeling**, **routine gate**. Sanitized copies are in [../examples/shared-skills/](../examples/shared-skills/).

## Outcomes
- A repeatable onboarding pack: 1 rules file, 8 skills, an installer, and an install/verify/rollback guide.
- Templates extracted for reuse: [SKILL_TEMPLATE.md](../examples/SKILL_TEMPLATE.md), [WORK_RULES_TEMPLATE.md](../examples/WORK_RULES_TEMPLATE.md).

## Lessons
- Rules say *what not to do*; skills say *how to do it*. Agents need both.
- Fixed report formats make agent output auditable, and make "unverified" an acceptable answer.
