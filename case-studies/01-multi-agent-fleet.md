# Case study 1: Running a multi-agent AI fleet for a small business

**Role:** architect and operator · **Period:** Sep–Oct 2026

## Problem
One owner runs several businesses and research projects. A single chat assistant could not cover inbox triage, research jobs, monitoring, and remote PCs without losing context, spamming notifications, or taking risky actions unsupervised.

## What I built
- **Coordinator bot ("dr eggbot")** that takes requests from me, delegates them, reviews results, and is the only bot that messages me.
- **5 specialist bots:** IQ-Paper (paper forward-testing), Inbox Manager (Gmail triage, morning digest, urgent bill/OTP alerts), FX-Research (backtesting), Fleet Monitor (live dashboard), IQ Dashboard.
- **2 self-hosted Hermes Agent instances** (Nous Research, open source): *Kai* on a Windows VPS with MetaTrader 5 (demo only), and *Kaze* on a home PC (PC operations).
- **Relay protocol:** the coordinator writes copy-paste instruction blocks ("paste-blocks") for the self-hosted agents, and they reply in a fixed report format.
- **Live Fleet Monitor:** every agent appends JSONL events (heartbeat, run_start/run_end, progress, read/write with sha256). A read-only web dashboard shows status colors and an independent "observed" layer (processes and file changes), and can export a draw.io diagram (.drawio) through the draw.io MCP. See [../examples/fleet-event-schema.md](../examples/fleet-event-schema.md).

## Guardrails
| Rule | Why |
|---|---|
| Approval gate for money, deletion, real trades | Irreversible actions need a human |
| Demo-only trading policy | Research is never a live-money experiment |
| One owner bot per routine type; routines silent when nothing changed | No duplicate alerts, low noise |
| Sub-bots report only to the coordinator | Clear accountability |
| Secret hygiene: mask values, never relay OTP codes | Chat logs are not a vault |
| Data-source labeling (live / delayed / demo / backtest) | Prevents mistaking test data for reality |

## Outcomes (verifiable in artifacts)
- 7 agents operating under one reporting hierarchy, with written rules and shared skills.
- Event schema v2 that stays backward compatible with v1, and a dashboard with no write access to the agents.
- Gmail automations: urgent bill/OTP alert (it reports *that* a code arrived, never the code) and a morning digest.

## Lessons
- Most multi-agent failures are **coordination failures** (duplicate routines, silent stalls), not model failures. The fixes were the *routine gate* and *ETA/late-ping* skills.
- A read-only monitor built on append-only events is cheap and builds trust fast.
