---
name: company-voice
description: Writes and edits in the company's name rather than in the user's personal voice, using the company voice file fetched from their AI Brain. Use for anything that speaks as the business: pitch and new business documents, proposals and scopes, case studies, credentials, award entries, website and marketing copy, company social posts, press responses, decks that go to a client. Triggers on "write this as the company", "for the pitch", "draft the proposal", "case study", "credentials", "website copy", "how do we describe this", and on any copy where the business is the speaker. This skill is for the company as speaker. For anything going out in the user's own first person voice, use write-as-me instead. When a piece is signed by the user but speaks for the company, use both.
---

# Write as the company

Fetch the company voice, then write.

## Resolve the brain first

Read the index once per session. Skip this if it has already been read in this session.

1. Search the connected file store for a file named `AI-BRAIN-INDEX.md`. Search by filename, never by path, because connectors resolve by title.
2. Read the `resolver` block in its YAML frontmatter. It names the person, their role, their company, the file store, the language, the humanizer locales, and every brain filename under `files`.
3. Fetch only the files this task needs, using the exact filenames the `files` map gives. Never hardcode a brain filename. Never guess a filename. Never assume the person's name, their company or their locale: read all three from the block.
4. If two indexes come back, use the one with the highest `brain_version`.
5. Never open anything under `setup/`. That folder is onboarding, not context, and may be deleted.

## Fetch in this order

1. `files.company_voice`. Always.
2. `files.company_context`. When the piece needs facts about the business: a pitch, a case study, credentials.
3. `files.voice_profile`. As well, when the piece carries the user's signature.
4. `files.safety_rules`. Always.
5. If a specific client is named, search the folder named at `folders.clients` for that client's context file and read it before writing a word about them.

## Then write

Follow the fetched voice file. Standing rules underneath it:

- Lead with the client's problem, never the company's credentials.
- Tie every capability mentioned to something the client actually needs. No feature dumping.
- Real numbers or no numbers. Never put a vague claim and a hard figure in the same breath.
- Apply the locale conventions recorded in the company context file: financial year, sales tax, currency, units, seasonal timing. Never assume a country.
- No em dashes. No double hyphens. No jargon. No hype.
- Run the `humanizer` skill on English text and `humanizer-danish` on Danish text before delivering, matching whichever locale the resolver's `humanizer_locales` covers.

## Naming clients

Never name a client, or describe their work, in anything external without confirming it is already public. External means a third party, not the client themselves. Check the client's context file for `public_relationship` and `confidential` before assuming. This is a hard rule from the company-safety skill, not a style preference.

## When the brain does not resolve

- Index unreachable: say plainly that the AI Brain could not be reached in the file store, then either ask for the relevant file to be pasted or proceed on clearly flagged generic defaults. Never improvise the person's voice, their company's facts, or their safety rules from memory.
- Index reachable but a named file missing: say which file is missing, carry on with what is available, and note that the fix is to update the `resolver` block rather than to guess a new name.
- `brain_version` lower than 4, or no `resolver` block at all: say the brain predates this version of the plugin and ask for the newer brain.

## Afterwards

Feedback on anything written in the company's name is voice data. The update-my-brain skill captures it.
