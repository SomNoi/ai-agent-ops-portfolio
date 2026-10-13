<!-- Sanitized copy of the live Fleet Monitor event schema. Paths and endpoints are placeholders. -->
# Fleet Monitor — event schema (v2, backward compatible with v1)

The Fleet Monitor dashboard (served locally; any remote access via a private tunnel, not documented here)
is **read-only**. It shows each agent's status from events the agents append to their own file,
plus an independent "Observed" layer (processes + recent file changes in owned dirs).

## Where to write

Append **one JSON object per line** (JSONL) to your own file only:

    <fleet-dir>/events/<agent-slug>.jsonl

Slugs: `dr-eggbot`, `iq-paper`, `iq-dashboard`, `fx-research`, `inbox-manager`, `fleet-monitor`, `kai`

Never rewrite/truncate files. Keep each line < 4 KB. The monitor reads the last ~1 MB / 1000 events per file.

## Fields

| field          | req | value |
|----------------|-----|-------|
| schema_version | no  | `2` for v2 events (missing = 1) |
| ts             | yes | ISO 8601 with offset, e.g. `2026-10-11T11:50:00+07:00` |
| agent          | yes | your slug |
| type           | yes | v1: `heartbeat` `run_start` `run_end` `result` `error` `alert` `handoff`; v2 adds: `progress` `read` `write` |
| status         | no  | `ok` \| `warn` \| `error` |
| summary        | yes | short human text (< 200 chars) |
| to             | no  | target agent slug (for `handoff`) |
| task           | no  | short task name; ties `run_start` / `progress` / `run_end` together |
| pct            | no  | 0–100 progress (for `progress`) |
| source         | no  | for `read`: URL, MCP `server/tool` name, or file path |
| path           | no  | for `write`: absolute path of the file written |
| bytes          | no  | for `write`: file size in bytes after writing |
| sha256         | no  | for `write`: hex sha256 of the file after writing |
| data           | no  | small JSON object with extra details |

v1 events stay valid as-is.

## Rules

- **No secrets ever**: no API keys, tokens, OTPs, passwords, cookies, session ids, account credentials.
- For `read` events with URLs: **strip the query string** (or at least any token/key/sig params) and any
  `user:pass@` part. Prefer `https://host/path` only.
- `write` paths should be absolute and under `<workspace>` or `<home>` (others are shown as unverifiable).
- Write the `write` event **after** the file is closed, so size/sha256/mtime verify.

## How the dashboard interprets events

- Status: **red** last event is error; **amber** last event `status: warn` or older than 26 h;
  **green** < 26 h and not error/warn; **grey** no events (shows "active (observed)" if processes or
  recent file changes are seen in your dirs).
- Current task: latest `run_start`/`progress` for a `task` with no later `run_end` for that task; `pct` is shown as a bar.
- Graph: agent→source edges from `read`, agent→file edges from `write`, agent→agent edges from `handoff`
  (most recent few per agent).
- Write verification (server side): file exists, size == `bytes`, sha256 matches (files ≤ 200 MB), and the
  file was not modified after the event (mtime ≤ `ts` + 2 s; if a later mtime has identical sha256 it still verifies). Badges: verified / mismatch (with reason) / unverifiable.

## Bash examples

```bash
EV=<fleet-dir>/events/fx-research.jsonl; NOW=$(date --iso-8601=seconds)
# run_start / progress / run_end for one task
echo "{\"schema_version\":2,\"ts\":\"$NOW\",\"agent\":\"fx-research\",\"type\":\"run_start\",\"task\":\"wf-backtest\",\"summary\":\"walk-forward started\"}" >> $EV
echo "{\"schema_version\":2,\"ts\":\"$(date --iso-8601=seconds)\",\"agent\":\"fx-research\",\"type\":\"progress\",\"task\":\"wf-backtest\",\"pct\":40,\"summary\":\"4/10 folds\"}" >> $EV
echo "{\"schema_version\":2,\"ts\":\"$(date --iso-8601=seconds)\",\"agent\":\"fx-research\",\"type\":\"run_end\",\"task\":\"wf-backtest\",\"status\":\"ok\",\"summary\":\"done\"}" >> $EV
# read (URL without query string)
echo "{\"schema_version\":2,\"ts\":\"$(date --iso-8601=seconds)\",\"agent\":\"fx-research\",\"type\":\"read\",\"source\":\"https://data.example.com/feed/EURUSD\",\"summary\":\"EURUSD ticks\"}" >> $EV
# write (auto size + sha256)
F=<workspace>/fx-research/out/report.csv
echo "{\"schema_version\":2,\"ts\":\"$(date --iso-8601=seconds)\",\"agent\":\"fx-research\",\"type\":\"write\",\"path\":\"$F\",\"bytes\":$(stat -c %s "$F"),\"sha256\":\"$(sha256sum "$F" | cut -d' ' -f1)\",\"summary\":\"report written\"}" >> $EV
```

## Python helper

```python
import json, datetime, hashlib, os, pathlib, urllib.parse

def _now():
    return datetime.datetime.now().astimezone().isoformat(timespec="seconds")

def _clean_url(s):
    if s and "://" in s:
        u = urllib.parse.urlsplit(s)
        host = u.hostname or ""
        if u.port: host += f":{u.port}"
        return urllib.parse.urlunsplit((u.scheme, host, u.path, "", ""))  # drop query, fragment, user:pass
    return s

def emit(agent, type_, summary, **kw):
    """kw: status, to, task, pct, source, path, bytes, sha256, data"""
    ev = {"schema_version": 2, "ts": _now(), "agent": agent, "type": type_, "summary": summary}
    if type_ == "read" and kw.get("source"):
        kw["source"] = _clean_url(kw["source"])
    if type_ == "write" and kw.get("path") and os.path.isfile(kw["path"]):
        p = os.path.abspath(kw["path"]); kw["path"] = p
        h = hashlib.sha256()
        with open(p, "rb") as f:
            for chunk in iter(lambda: f.read(1 << 20), b""):
                h.update(chunk)
        kw.setdefault("bytes", os.path.getsize(p))
        kw.setdefault("sha256", h.hexdigest())
    ev.update({k: v for k, v in kw.items() if v is not None})
    out = pathlib.Path("<workspace>/fleet/events") / f"{agent}.jsonl"
    out.parent.mkdir(parents=True, exist_ok=True)
    with out.open("a") as f:
        f.write(json.dumps(ev, ensure_ascii=False) + "\n")

# examples
emit("iq-paper", "run_start", "paper session", task="paper-eurusd")
emit("iq-paper", "progress", "30/100 trades", task="paper-eurusd", pct=30)
emit("iq-paper", "read", "candles", source="iq-option-mcp/get_candles")
emit("iq-paper", "write", "ledger saved", path="<workspace>/iq-paper/ledger.csv")  # bytes+sha256 auto
emit("iq-paper", "run_end", "session done", task="paper-eurusd", status="ok")
emit("iq-paper", "handoff", "results ready for review", to="dr-eggbot")
```

Kai (external, Windows VPS) cannot write here; dr eggbot may relay Kai updates into `kai.jsonl`
with `"data": {"relayed_by": "dr-eggbot"}`.
