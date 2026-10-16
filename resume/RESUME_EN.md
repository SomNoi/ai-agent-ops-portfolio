# Preeda Wisetsunthonr
**AI Workflow & Agent Operations | Multi-agent automation, agent reliability, research rigor**  
Thailand (Nakhon Phanom) · AI agent systems builder · preda.p3@gmail.com · [LinkedIn](https://www.linkedin.com/in/preeda-wisetsunthonr-7a1503a7/) · [GitHub](https://github.com/SomNoi) · [Portfolio](https://github.com/SomNoi/ai-agent-ops-portfolio)

## Summary
Self-taught AI operator who designs, runs, and hardens a working multi-agent AI system for my own projects. I write agent operating rules and skills the way a manager writes an employee handbook, put approval gates on anything risky, and make agents recover by themselves after crashes. I report results honestly, including negative ones. Brings 18+ years of hands-on production experience (garment workshop owner, CNC machine setter in Japan) plus IT support, design, and inventory roles: used to quality standards, drawings, and accountability.

## Core skills
- **Agent design & orchestration:** coordinator/specialist hierarchy, hand-offs, routine ownership, approval gates (money / deletion / real trades), demo-only policies
- **Agent enablement:** system rules (SOUL.md / WORK_RULES), skill files (SKILL.md), onboarding packs, reusable skills library
- **Reliability / AgentOps:** Windows Task Scheduler autostart, watchdogs with kill-tests, resume-after-restart notes, RAM/disk health alerts, timezone/cron fixes, root-cause analysis, version upgrades
- **Automation & integrations:** Gmail, Google Calendar, Google Drive, Slack, GitHub, MCP connectors; live web dashboards; draw.io export
- **Quant research method:** pre-registration, Bonferroni correction, untouched holdout, realistic costs, Wilson lower-bound pass rules; Python to MQL5 porting
- **Operations & technical (prior roles):** CNC setup & inspection (work offsets, first-part/in-process checks to drawings) · IT support (Windows installs, software deployment & licensing) · Adobe Illustrator / Photoshop · Facebook Ads · inventory management · garment production & quality control
- **Security hygiene:** secret masking, no codes/credentials in chat or logs, data-source labeling

## Selected projects (Sep–Oct 2026)
**Multi-agent AI fleet: architect & operator**

- Run a coordinator bot supervising 5 specialist bots (paper forward-testing, Gmail triage, FX backtesting, live fleet monitor, dashboard) plus 2 self-hosted Hermes Agent (Nous Research, open source) instances: one on a Windows VPS with MetaTrader 5, one on a home PC.
- Hierarchical reporting (sub-bots report only to the coordinator), one owner bot per job type, explicit approval gates for money, deletion, and real trades.

**Agent onboarding pack & shared skills library**

- Wrote work rules plus an 8-skill onboarding pack (task intake, safe Windows inspection, safe disk cleanup, read-only MT5 status, progress/ETA, secret hygiene, failure recovery, supervisor report) with an idempotent installer, backup, and rollback.
- Built shared fleet skills: paste-block relay, ETA/late-ping, secret hygiene, data-source labeling, routine gate.

**Self-healing agent on Windows**

- Boot autostart through Task Scheduler and a 5-minute watchdog. Kill-tests measured recovery at about 20 s and 140 s.
- Root-caused a run-as-SYSTEM bug and a locked-venv update failure; upgraded Hermes v0.20 / v0.21.3 to v0.21.7.

**Agent-driven PC maintenance**

- Agent freed the C: drive from 7.2 GB to about 26–30 GB free using a restore point, a changelog, an undo script, and move-only file organization (no blind deletes).

**Rigorous strategy-research pipeline**

- Ran about 645 pre-registered trials with Bonferroni correction, a 12-month untouched holdout, real broker costs, and a Wilson lower-bound pass rule. **Honest result: no strategy passed.**

- Ported one strategy (REB-H4) from Python to an MQL5 EA. It matched the Python reference on 5/5 days and now runs only as a demo forward test, using a signal-file bridge from Python to MT5.

**Gmail automation & dashboards**

- Urgent bill/OTP alerts that never share the code itself, and a morning digest.
- Live fleet-activity web dashboard with .drawio export via the draw.io MCP.

## Tools
Hermes Agent · MCP · Python (pandas, numba) · PowerShell · Windows Task Scheduler · cron · MetaTrader 5 / MQL5 · Gmail / Calendar / Drive / Slack / GitHub APIs · draw.io · Markdown / Git

## Certifications
**16 AiPASS certificates** (41 AiPASS certificates in total) from the Office of the National Digital Economy and Society Commission (ONDE), online courses via AiPASS, 2026. AI-related:
- AI Agent · Prompt Engineering with GitHub Copilot · Azure AI Zero to Hero · Custom GPT · Automation with AI · Power BI · PDPA x AI · Prompt Engineering 101 · Microsoft 365 Copilots
- Machine Learning (25 Sep 2026) · Data Science, Engineer, Big Data & Visualization (30 Sep 2026)
- 6 Sep 2026: Generative AI และ ChatGPT ทำงานอย่างไร · พื้นฐาน AI: ทักษะจำเป็นในยุค AI · พื้นฐาน AI: เปิดโลก AI สู่โอกาสใหม่ในชีวิตและงาน · การปรับตัวสู่การทำงานยุคใหม่กับ AI · AI เรียนรู้อย่างไร? เปิดเผยเบื้องหลังแบบเข้าใจง่าย

## Experience
**Independent — AI Agent Systems Builder (self-directed)** · Thailand · 2026–present
- Built and operate a coordinator + 5 specialist bots + 2 self-hosted Hermes Agent instances, with approval gates and self-healing (recovery ~20–140 s); see projects above.

**Sewing Operator** · Family-owned garment factory, Thailand · Aug 2026–present
- Production sewing to quality and output targets.

**CNC Machine Setter** · Furuhata Seisakusho (有限会社古旗製作所), Chikuma, Nagano, Japan · 2025–2026 (~1.5 years)
- Set up CNC machines and work offsets; ran machine checks before production.
- Performed first-part and in-process inspection against drawing dimensions; operators only loaded/unloaded parts.

**NR Auto Seats**, Thailand · 2023–2024 (rotated through 4 roles)
- **Installation Technician** (~3 months).
- **IT Support** (~4 months): supported 30 PCs and 2 servers; Windows installs, software deployment and licensing.
- **Graphic Designer** (~4 months): designs in Illustrator and Photoshop; administered Facebook Ads.
- **Stock Manager** (~4 months): ran the goods-in/out system and stock counts, coordinated purchasing, controlled raw materials.

**Owner — Pants-Sewing Workshop** (family business, 2 people), Thailand · 2006–2022 (16 years)
- Subcontractor for Pinky Tailor (premium bespoke tailor, Bangkok); ran intake, production, quality and delivery. Closed due to COVID-19.

**Earlier:** Sewing operator, garment factory, Bangkok · 2001–2006.

## Education
Self-taught in AI and automation; formal schooling to lower secondary (Nakhon Phanom).

## Languages
Thai (native) · English (elementary: reading/listening, basic speaking; writes with AI tools) · Japanese (elementary: basic listening/speaking from 1.5 years working in Japan)
