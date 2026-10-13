---
name: data-source-label
description: >-
  Use when reporting any price, candle, signal, backtest, or trade stat for
  forex, gold, or binary options.
---
# Label market data sources
Every price, signal, or stat must state:
1. Source: broker or feed (e.g. broker demo feed, historical tick vendor, public quote site).
2. Exact symbol as the source names it (e.g. XAUUSD vs XAUUSD.a, EURUSD-OTC).
3. Timeframe and timezone (e.g. M5, UTC or ICT).
4. Freshness: live, delayed (how much), or historical range (from to).
5. Price type if relevant: bid, ask, or mid.
6. For results: demo or backtest, in-sample or out-of-sample, and with or without costs.
If any of these is unknown, say 'unknown' rather than guessing. Never mix sources in one stat without saying so.
