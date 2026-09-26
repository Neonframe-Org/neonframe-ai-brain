---
name: morning-briefing
description: Builds the user's morning briefing. Reads their email sent and received, their calendar, and their task list, writes one page, and keeps their action items current. Saves to the task tool named in their company context if it is connected, otherwise writes the briefing in the chat. Triggers on "run my morning briefing", "morning briefing", "daily briefing", "what's on my plate today", "start my day", "catch me up", "what did I miss". Runs the whole sequence without stopping to ask questions.
---

# Morning briefing

Work through the steps in order. Do not stop to ask questions mid run: flag any uncertainty inside the output instead. Keep it light. Do not deep read long threads or large files.

## Resolve the brain first

Read the index once per session. Skip this if it has already been read in this session.

1. Search the connected file store for a file named `AI-BRAIN-INDEX.md`. Search by filename, never by path, because connectors resolve by title.
2. Read the `resolver` block in its YAML frontmatter. It names the person, their role, their company, the file store, the language, the humanizer locales, and every brain filename under `files`.
3. Fetch only the files this task needs, using the exact filenames the `files` map gives. Never hardcode a brain filename. Never guess a filename. Never assume the person's name, their company or their locale: read all three from the block.
4. If two indexes come back, use the one with the highest `brain_version`.
5. Never open anything under `setup/`. That folder is onboarding, not context, and may be deleted.

## Resolve the company layer

Some brains split company truth from personal truth. When the `resolver` block carries a `company_layer` block, the company's facts, voice, prices and shared knowledge live in the tool it names, not in the brain folder. Read the block; never hardcode a page.

- `company_layer.tool`: the connected tool holding the company layer, for example Notion.
- `company_layer.entry`: the entry page. It maps every company topic. Read it once per session when a task needs the company.
- `company_layer.company_context`: what the company is, who it serves, the team, systems of record, tool stack. Use it wherever this skill says `files.company_context`.
- `company_layer.company_voice`: how the company writes. Use it wherever this skill says `files.company_voice`.
- `company_layer.pricing`: the only place prices, durations and inclusions live. Fetch it every time a task needs a figure. Never quote a price from memory, from the brain, or from any other page.
- `company_layer.knowledge`: the shared team knowledge base.
- `company_layer.operating_rules`: dated company decisions and process rules.

When `company_layer` is present, the brain files named at `files.company_context` and `files.company_voice` are short pointers plus the person's own notes. Read them too; they are short. When `company_layer` is absent, everything lives in the brain folder and nothing here changes. If the tool named in `company_layer.tool` is not connected, say so, fall back to the brain files, and flag that company facts may be stale.

Fetch the company context for the tools and environment section (`company_layer.company_context` when present, otherwise `files.company_context`), `files.safety_rules` always, and `files.voice_profile` before drafting any reply.

## Step 0: set the lookback window

Check what day it is today.

- Monday: look back 72 hours, to cover the weekend.
- Any other weekday: look back 24 hours.

Apply the window using whatever date filter the connected email tool supports. Carry the same window into Steps 1 and 3.

## Step 1: email sweep

Search the user's email across the lookback window, sent and received. Skip newsletters, automated notifications and system alerts. For each real message from a real person, tag it:

- REPLY NEEDED: they are waiting on the user.
- BLOCKED: they cannot move without the user's input.
- FYI: context only.
- ESCALATED: the tone shifted, or something is urgent.

For REPLY NEEDED and BLOCKED, draft a short reply inline in the user's voice. Direct, warm, no filler. Never send anything.

## Step 2: calendar

Pull today's events and the next two days. For each meeting give the time, the title, the attendees with external ones flagged, the purpose stated as what needs to be decided rather than the title again, and the prep: a thread or document to read first, or "none".

## Step 3: update the action items

Find the task home. The tools and environment section of the company context file names the task or project tool the user actually works in. If that tool is connected, keep action items there. If no tool is connected, keep the running action list in the chat and ask once where they want it kept. A live task list is state, not knowledge, so it does not belong in the brain, and the conventions file says so.

- Add any new tasks that came out of the email and the meetings inside the lookback window.
- For anything completed, move it to an archive entry dated today, then remove it from the live list.
- Keep the list tight. Never duplicate a task that is already there.

## Step 4: pipeline flags

Only if a CRM or pipeline tool named in the company context is connected. Scan for deals that need a nudge: gone quiet, a chase now due, a stage that should have moved. One line each. If nothing is connected, skip this step.

## Step 5: write the briefing

If the connected task or project tool has a home for daily briefings, save the briefing there as a dated entry. Otherwise write it in the chat, and save a copy to a file only if asked, wherever the user asks for it. A briefing is output, not brain, so it is never filed into the brain folders by default. Use this structure:

```
## Calendar: [day, date]
[Time] [Title] [attendees, external flagged] | Purpose: [outcome needed] | Prep: [what to read, or "none"]
Coming up: [one line per day, next two days]

## Inbox: real people, last 24h, or 72h on Mondays
[Name] ([company]): [REPLY NEEDED / BLOCKED / FYI / ESCALATED]
[What they said, one or two lines]
Draft reply: [only for REPLY NEEDED and BLOCKED]

## Top priority
One item. Two sentences. Point to the email or meeting that makes it the priority.

## Quick wins
Two or three items, one line each, with what each one unblocks.
```

## Writing rules

No filler. Lead each section with what matters most, not with what came in first. Call out anything that looks like it is slipping. The whole briefing reads in five minutes. No em dashes. No double hyphens. Active sentences. Run the `humanizer` skill on the draft before delivering. It picks the language itself and applies the locale the resolver's `humanizer_locales` declares.

## When the brain does not resolve

- Index unreachable: say plainly that the AI Brain could not be reached in the file store, then either ask for the relevant file to be pasted or proceed on clearly flagged generic defaults. Never improvise the person's voice, their company's facts, or their safety rules from memory.
- Index reachable but a named file missing: say which file is missing, carry on with what is available, and note that the fix is to update the `resolver` block rather than to guess a new name.
- `brain_version` lower than 4, or no `resolver` block at all: say the brain predates this version of the plugin and ask for the newer brain.
