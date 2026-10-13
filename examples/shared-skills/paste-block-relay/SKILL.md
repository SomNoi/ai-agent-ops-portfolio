---
name: paste-block-relay
description: >-
  Use when writing any instruction the user will relay to an external agent
  (e.g. a self-hosted agent on a chat app) by copy-paste from a phone.
---
# Relay message as one paste block
1. Put the whole instruction in ONE fenced code block, with no other code blocks in the reply.
2. Write it in English, imperative, self-contained: target (account/symbol/file), exact action, limits (what NOT to touch), and what to report back and when.
3. Keep it short enough for one chat message (under ~1,000 characters). No markdown inside the block.
4. Outside the block, one or two sentences in the user's language only: what it does and why.
5. Never put passwords, tokens, or OTPs in the block.
6. When the reply comes back, summarize it briefly; don't echo the long text.
