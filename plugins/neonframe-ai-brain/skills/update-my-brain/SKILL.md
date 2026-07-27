---
name: update-my-brain
description: Keeps the user's AI Brain current in the connected file store. Runs quietly in the background of every session. Detects when the user corrects a draft, rejects phrasing, states a preference, confirms a fact, changes a process, names a new client or tool, or makes a decision, and captures it into the right brain file without being asked. Also triggers on "update my brain", "save this to my brain", "review my brain", "is my brain up to date", "add this to my voice profile". Captures as it goes and reports in one line at the end.
---

# Update the brain

The brain is a set of Markdown files in the connected file store. Keep them true, continuously, without being asked. Treat this the way you would treat memory: notice, capture, file.

## Resolve the brain first

Read the index once per session. Skip this if it has already been read in this session.

1. Search the connected file store for a file named `AI-BRAIN-INDEX.md`. Search by filename, never by path, because connectors resolve by title.
2. Read the `resolver` block in its YAML frontmatter. It names the person, their role, their company, the file store, the language, the humanizer locales, and every brain filename under `files`.
3. Fetch only the files this task needs, using the exact filenames the `files` map gives. Never hardcode a brain filename. Never guess a filename. Never assume the person's name, their company or their locale: read all three from the block.
4. If two indexes come back, use the one with the highest `brain_version`.
5. Never open anything under `setup/`. That folder is onboarding, not context, and may be deleted.

## Capture as it happens

Watch every session for these signals. When one appears, write it. Do not ask first and do not queue it for the end. The right hand column names the resolver key, so fetch the filename it points to.

| Signal | Destination |
|---|---|
| Rewrote your draft, rejected a word, said "I'd never say that" or "too formal" | `files.voice_profile` |
| Changed how you should approach a task, or stated a working preference | `files.about_me` |
| Feedback on a pitch, proposal, case study, or anything in the company's name | `files.company_voice` |
| A new or lost client, a service, positioning, team or tool change | `files.company_context` |
| A pricing change | `files.company_context`, the current rates pointer only. Never write the figure itself |
| A new confidentiality constraint, or a client's own policy on AI use | `files.safety_rules` |
| A detail about a named client worth keeping | A `[ClientName]/` context file inside the folder named at `folders.clients` |
| A decision, insight, or piece of research worth keeping | The resolved knowledge home |
| A project or engagement ended, or a pitch was won or lost | The resolved knowledge home, as an outcome entry |
| A document structure that worked | The folder named at `folders.templates` |
| An answer to anything marked "to confirm" | Wherever that item sits |

## Resolve the knowledge home

Read `knowledge_home` from the `resolver` block in the index before writing or reading any knowledge entry. It gives one home for writes and two homes for reads.

1. Write to `primary`. When `primary` is `knowledge_tool`, write to the tool named in `knowledge_home.tool`, and only when that tool is actually connected and responding: find the page, board or database holding the knowledge base and add a dated entry, appending, never overwriting, never duplicating an entry already there.
2. When `primary` is `brain_folder`, or the tool named in `knowledge_home.tool` is not connected, write to the knowledge folder given at `folders.knowledge`, filed by month, one Markdown file per item, named `YYYY-MM-DD_type_short-slug.md`.
3. Read `primary` first and then `fallback`, always both, never only one. Anyone who changed tools mid engagement has older entries sitting in the other home, so run the second search even when the first returns results: silently missing half the knowledge costs more than one extra search.
4. Only after a write genuinely fails: say plainly that the save did not go through, then hand back the finished entry as text ready to paste, with the exact target name. Never offer paste as a shortcut instead of attempting the write.
5. Never default to a tool that `knowledge_home` does not name.

Every other row in the table above is a brain file edited in place. Those follow the writing rules further down, not this block.

### Outcomes get three lines

An outcome entry is the capture that pays off later, because every pitch, proposal and case study draws on it. Three lines, no more:

- What was done. The work itself, in one line.
- What drove the result. Why it landed, or why it did not. This is the part worth having.
- What to reuse. The structure, argument or approach to carry into the next one.

Write it when the work ends, not weeks later. If the reason it worked is genuinely unclear, say so rather than inventing a cause.

### Prices are pointed at, never copied

A rate change updates where the live prices live, not the number. When the user mentions a new rate, check that the current rates pointer in the company context file still names the right source, and correct the pointer if it has moved. Never write the figure into the brain. A stale number in the brain gets quoted with confidence months later, which is worse than having no number at all.

Infer from what the user does, not only from what they say. When they rewrite a sentence, the edit is the instruction: capture what changed and why, not that they edited.

## Writing back

The file store connector reads and writes the brain on every surface. So the default is simple: make the change, then report in one line.

If a write genuinely fails on this surface, or the connector needs reauthenticating, never skip it silently and never imply it saved when it did not. Say so, then hand over the exact text and the exact filename ready to paste. Either way the capture happens.

## How to write

1. Fetch the target file so you edit the live version.
2. Write the change as a durable instruction, phrased for a future reader with no memory of this conversation. "Prefers 'get in touch' over 'reach out'" beats "asked me to change reach out today".
3. Corrections replace the outdated line. Never leave both versions.
4. Update `last_updated` in the frontmatter.
5. For a new file, follow the schema in the file named at `files.conventions` and give it a searchable filename.

Keep entries to one or two lines. A brain that doubles in length every month is being hoarded, not maintained. When a file passes roughly 300 lines, split it or cut the weakest entries.

## Report, do not ask

At the end of a session where you wrote something, one line: "Saved to your brain: [what], in [file]." Nothing more. If the user disagrees, they will say so, and that correction is itself a capture.

## Promote status

When a file stops being guesswork, raise its `status`: `draft-thin` to `draft` to `active`. When a file reaches `active`, remove any status warning block from the top of it.

## When asked to review the brain

A review is a sweep, not a capture, and it is worth running quarterly. Read the index and the frontmatter of each brain file first, not the full bodies, then report one short list:

- Files whose `last_updated` is more than 90 days old.
- Files still marked `draft` or `draft-thin`, and what would move them to `active`.
- Any "to confirm" item still unanswered, quoted so it can be answered on the spot.
- Files past roughly 300 lines that need splitting or cutting.
- Anything that contradicts something newer elsewhere in the brain. Name both and ask which is true.

Fix what this conversation settles. Ask about the rest rather than guessing, and never delete a file as part of a review.

## The two things to ask about

Write everything else automatically. Ask first only when:

- The change would loosen a rule in the safety rules file. Never do that without an explicit, specific instruction.
- You would remove content rather than replace it, and you are not certain it is superseded.

Never invent a voice characteristic, a client fact, or a business detail to fill a gap. An honest "to confirm" beats a guess, because a guess written into the brain gets repeated for months.

## When the brain does not resolve

- Index unreachable: say plainly that the AI Brain could not be reached in the file store, then either ask for the relevant file to be pasted or proceed on clearly flagged generic defaults. Never improvise the person's voice, their company's facts, or their safety rules from memory.
- Index reachable but a named file missing: say which file is missing, carry on with what is available, and note that the fix is to update the `resolver` block rather than to guess a new name.
- `brain_version` lower than 4, or no `resolver` block at all: say the brain predates this version of the plugin and ask for the newer brain.
