---
name: write-as-me
description: Writes and edits in the user's own name and voice, using the voice profile fetched from their AI Brain. Use for anything going out under their own name: emails, replies, social posts, client notes, keynote scripts and abstracts, internal messages, board and advisory papers, award entries, comments. Triggers on "write as me", "draft this", "in my voice", "tidy this up", "make this sound like me", "reply to this for me", "rewrite this so it sounds like me", and on any writing or editing that speaks in the first person under the user's own name. This skill is for the user speaking as themselves. For copy that speaks in the company's name, such as a pitch, proposal, case study or website page, use company-voice instead. When a piece is signed by the user but speaks for the company, use both.
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

## Fetch in this order

1. `files.voice_profile`. Always.
2. `files.company_voice`. Only when the piece speaks in the company's name rather than the user's own.
3. `files.company_context`. When the piece needs a fact about the business, or when a figure, date or timeline needs the locale conventions applied.
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
