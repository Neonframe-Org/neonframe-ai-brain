---
name: write-as-me
description: Writes and edits in the user's own name and voice, using the voice profile fetched from their AI Brain. Use for anything going out under their own name, such as emails, replies, social posts, client notes, keynote scripts and abstracts, internal messages, board and advisory papers, award entries, comments. Triggers on "write as me", "draft this", "in my voice", "tidy this up", "make this sound like me", "reply to this for me", "rewrite this so it sounds like me", and on any writing or editing that speaks in the first person under the user's own name. This skill is for the user speaking as themselves. For copy that speaks in the company's name, such as a pitch, proposal, case study or website page, use company-voice instead. When a piece is signed by the user but speaks for the company, use both.
---

# Write as the user

Fetch the voice, then write. Never draft first and check the profile afterwards.

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

## Fetch in this order

1. `files.voice_profile`. Always.
2. The company voice (`company_layer.company_voice` when present, otherwise `files.company_voice`). Only when the piece speaks in the company's name rather than the user's own.
3. The company context (`company_layer.company_context` when present, otherwise `files.company_context`). When the piece needs a fact about the business, or when a figure, date or timeline needs the locale conventions applied. A price comes from `company_layer.pricing`, fetched, never recalled.
4. `files.safety_rules`. Always, per the company-safety skill.

## Then write

Follow the fetched profile. Do not override it with what follows. These are the standing rules sitting underneath it:

- Apply the spelling, units and register for the user's locale. They are recorded in the company context file and enforced by the humanizer. Never assume a country.
- No em dashes. No double hyphens. Use a comma, a colon, or a new sentence.
- No jargon, no AI filler, no motivational register, no hype.
- Contractions. Short sentences. Lead with the point.
- Run the `humanizer` skill before delivering. It picks the language itself and applies the locale the resolver's `humanizer_locales` declares.

## Confidence

Read the `status` field in the fetched profile. If it is anything other than `active`, treat the profile as incomplete: write from it, and say the match is directional if asked. Never invent a voice characteristic that is not in the file.

## When the brain does not resolve

- Index unreachable: say plainly that the AI Brain could not be reached in the file store, then either ask for the relevant file to be pasted or proceed on clearly flagged generic defaults. Never improvise the person's voice, their company's facts, or their safety rules from memory.
- Index reachable but a named file missing: say which file is missing, carry on with what is available, and note that the fix is to update the `resolver` block rather than to guess a new name.
- `brain_version` lower than 4, or no `resolver` block at all: say the brain predates this version of the plugin and ask for the newer brain.

## Afterwards

Every correction the user makes to a draft is voice data. The update-my-brain skill captures it.
