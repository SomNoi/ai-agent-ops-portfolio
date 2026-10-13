# Case study 4: Research rigor in an agent-run strategy pipeline

> This is about **method**, not profit. The honest result was that **no strategy passed**.

## Problem
It is easy to "discover" a trading strategy by testing hundreds of variants and keeping the lucky one. I wanted a pipeline, run largely by an AI research agent, that would protect against fooling myself.

## Method
- **Pre-registration:** each hypothesis and its pass criteria were written *before* testing. Each spec file's hash and UTC timestamp were logged, and the file was made read-only.
- **Trial log:** every parameter set and symbol was recorded, about **645 trials** in total.
- **Multiple-testing correction:** a Bonferroni-adjusted t threshold (about 3.78 at 645 trials), plus a deflated Sharpe ratio per candidate.
- **Walk-forward:** 24-month in-sample and 6-month out-of-sample windows, with no overlap.
- **12-month untouched holdout,** enforced in code. Loaders truncate the data before the holdout start, and the holdout may only be used once per finalist.
- **Realistic costs:** session-based broker spreads, commission, slippage, swaps, and blocked rollover/weekend entries, with sensitivity runs at 1x / 1.5x / 2x costs.
- **Binary-outcome check:** a pass needs the **Wilson lower bound** of the win rate to be above breakeven, not just the point estimate.

## Result
- **0 strategies passed** the full bar. Several near-misses failed the minimum trade count or later checks, and were reported as failures.
- No finalist meant the holdout was **never spent**.

## Engineering follow-through
- One strategy (REB-H4) was ported from the Python reference to an **MQL5 Expert Advisor**. It matched the Python signals on **5/5 days**.
- It now runs as a **demo-account forward test only**, fed by a **signal-file bridge** (Python writes signals, the EA reads them).

## Lessons
- A negative result reached honestly is a real deliverable. It saved money and time.
- Put the guardrails (holdout lock, trial log, pre-registration hashes) **in code**, so an agent cannot skip them.
