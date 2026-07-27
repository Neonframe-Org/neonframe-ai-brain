---
name: company-context
description: Loads the company's business context from the user's AI Brain: what the business is, who it serves, its clients, market position, leadership, track record, tools and locale conventions. Use for any task that needs the business rather than just the voice: strategy, client and pitch work, competitor questions, new business, pricing questions, hiring, commercial decisions, briefings, research. Triggers when the user asks about their business, a client, a competitor or the market, or says "give me context", "what do we know about", "help me think through this", "brief me before this meeting", "who are we up against". This skill loads facts. For writing in the company's name, use company-voice.
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

## Fetch in this order

1. `files.company_context`. For anything about the business itself.
2. `files.about_me`. When the question is about the user's role, priorities, or how they work.
3. `files.safety_rules`. Always.

Then, only when the task points at them:

- A named client: search the folder named at `folders.clients` for that client's context file and any dated notes.
- A named project: search the folder named at `folders.projects` for that project's folder.
- Background, or a decision already taken: search the resolved knowledge home by topic, primary then fallback, most recent month first.
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

When a task needs a tool, read the tools and environment section of the company context file and use the tool named there. Do not substitute a tool that is not part of the user's stack.

## When the brain does not resolve

- Index unreachable: say plainly that the AI Brain could not be reached in the file store, then either ask for the relevant file to be pasted or proceed on clearly flagged generic defaults. Never improvise the person's voice, their company's facts, or their safety rules from memory.
- Index reachable but a named file missing: say which file is missing, carry on with what is available, and note that the fix is to update the `resolver` block rather than to guess a new name.
- `brain_version` lower than 4, or no `resolver` block at all: say the brain predates this version of the plugin and ask for the newer brain.

## Afterwards

Business facts, tool changes and confirmed unknowns are context data. The update-my-brain skill captures them.
