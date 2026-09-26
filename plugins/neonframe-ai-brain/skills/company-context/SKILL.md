---
name: company-context
description: Loads the company's business context from the user's AI Brain, covering what the business is, who it serves, its clients, market position, leadership, track record, tools and locale conventions. Use for any task that needs the business rather than just the voice, such as strategy, client and pitch work, competitor questions, new business, pricing questions, hiring, commercial decisions, briefings, research. Triggers when the user asks about their business, a client, a competitor or the market, or says "give me context", "what do we know about", "help me think through this", "brief me before this meeting", "who are we up against". This skill loads facts. For writing in the company's name, use company-voice.
---

# Load the business context

Fetch the facts before answering. Never reconstruct the business from memory.

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

1. The company context. When `company_layer` is present, read `company_layer.entry` once, then `company_layer.company_context`; the brain file at `files.company_context` is then a short pointer, read it for the person's own notes. When `company_layer` is absent, `files.company_context` is the whole thing.
2. `company_layer.pricing`, only when the task needs a price, duration or inclusion. Fetch it every time. Never quote a figure from memory or from the brain.
3. `files.about_me`. When the question is about the user's role, priorities, or how they work.
4. `files.safety_rules`. Always.

Then, only when the task points at them:

- A named client: search the folder named at `folders.clients` for that client's context file and any dated notes. If the brain says client context is not held there, use the CRM the company context names.
- A named project: search the folder named at `folders.projects` for that project's folder.
- Background, or a decision already taken: search `company_layer.operating_rules` and `company_layer.knowledge` when present for company decisions and research, and the resolved knowledge home for the person's own, most recent first. Search both layers before saying something is not recorded.
- A recurring document type: check the folder named at `folders.templates` before building a structure from scratch.

Load only what the task needs. Do not crawl the brain.

## Resolve the knowledge home

Read `knowledge_home` from the `resolver` block in the index before writing or reading any knowledge entry. It gives one home for writes and two homes for reads.

1. Write to `primary`. When `primary` is `knowledge_tool`, write to the tool named in `knowledge_home.tool`, and only when that tool is actually connected and responding: find the page, board or database holding the knowledge base and add a dated entry, appending, never overwriting, never duplicating an entry already there.
2. When `primary` is `brain_folder`, or the tool named in `knowledge_home.tool` is not connected, write to the knowledge folder given at `folders.knowledge`, filed by month, one Markdown file per item, named `YYYY-MM-DD_type_short-slug.md`.
3. Read `primary` first and then `fallback`, always both, never only one. Anyone who changed tools mid engagement has older entries sitting in the other home, so run the second search even when the first returns results: silently missing half the knowledge costs more than one extra search.
4. Only after a write genuinely fails: say plainly that the save did not go through, then hand back the finished entry as text ready to paste, with the exact target name. Never offer paste as a shortcut instead of attempting the write.
5. Never default to a tool that `knowledge_home` does not name.

Search only the topic the task needs. Do not read every entry in either home.

## Flag what is missing

Items marked "to confirm" are genuine unknowns, not gaps to fill. When a question lands on one, say it is unconfirmed and ask.

An empty client folder means that context has not been captured yet. Say so rather than reconstructing it from the general company file.

## Locale conventions

Apply the conventions recorded in the company context file to any figure or timeline without being asked: financial year, sales tax rate and whether figures are stated inclusive or exclusive, currency, units, and seasonal timing. Read them from the file. Never assume a country.

## Tools

When a task needs a tool, read the tools and environment section of the company context (the `company_layer.company_context` page when present, otherwise the brain file) and use the tool named there. Do not substitute a tool that is not part of the user's stack.

## When the brain does not resolve

- Index unreachable: say plainly that the AI Brain could not be reached in the file store, then either ask for the relevant file to be pasted or proceed on clearly flagged generic defaults. Never improvise the person's voice, their company's facts, or their safety rules from memory.
- Index reachable but a named file missing: say which file is missing, carry on with what is available, and note that the fix is to update the `resolver` block rather than to guess a new name.
- `brain_version` lower than 4, or no `resolver` block at all: say the brain predates this version of the plugin and ask for the newer brain.

## Afterwards

Business facts, tool changes and confirmed unknowns are context data. The update-my-brain skill captures them.
