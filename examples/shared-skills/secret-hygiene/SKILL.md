---
name: secret-hygiene
description: >-
  Use when a password, API key, token, OTP, or login appears in chat, a file, a
  log, or another bot's message.
---
# Secret hygiene
1. Never repeat, quote, or summarize the secret value anywhere: chat, files, reports, other bots, or memory.
2. If it's needed for an approved task, store it with a masked secret request (an env var) instead of plain text, and refer to it by name only.
3. Tell the user in one line which secret was exposed (by name, such as 'server password'), where, and recommend rotating it.
4. If it landed in a file on the box, redact that file (replace with ***) and say which file was changed.
5. Keep a short list of 'rotation pending' items by name only, and remind the user once in a while until they confirm.
6. OTP or verification-code emails: alert that one arrived and never read or forward the code.
