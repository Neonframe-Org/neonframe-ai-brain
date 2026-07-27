---
name: humanizer
description: Anti-AI slop filter for everything written before it is delivered, in English or Danish. Claude runs this on emails, client notes, proposals, pitch documents, reports, board papers, newsletters, LinkedIn posts, social captions, keynote scripts, case studies, award entries, course content, landing page copy and internal memos. Triggers on any request to draft, write, edit, rewrite, polish, tighten, shorten, proofread or humanise text, and on phrases such as "run the humanizer", "make this sound human", "does this read like AI", "clean this up before I send it" and "make it sound like me". Also triggers on Danish requests to skrive, formulere, rette, omskrive, stramme op, korrekturlæse eller humanisere, and on phrases such as "skriv på dansk", "lyder det her som AI", "gør det mere menneskeligt" and "tjek den inden jeg sender". Resolves the output language, then the spelling, vocabulary, units and register, from the resolver block in the brain index.
---

# Humanizer

Run this filter on every piece of writing before delivery. No exceptions. Draft first, then run the full pass, then deliver.

This file is the router. It decides which language the piece is in, loads the one filter body that applies, and gets out of the way. The body does the work.

## Step 1: resolve the brain

Spelling, vocabulary, units, register and voice are all decisions this brain has already made. Never guess them.

1. Search the connected file store for the file named `AI-BRAIN-INDEX.md`. Use the file store named in that brain's resolver block if it is already known; otherwise search every store that is connected.
2. Read the YAML frontmatter and take `resolver.humanizer_locales`. Treat the value as a list, always, even when it holds one item.
3. Fetch the voice profile named at `resolver.files.voice_profile` before drafting anything that carries a person's name or a company's public voice. This filter strips AI tells; the voice profile supplies the fingerprint. Client-facing writing needs both.

Never block delivery on a failed lookup. Run the filter anyway, say in the reply what was missing, and name which step failed, because each has a different fix:

- **No file store reachable, or the search returned nothing.** Say the AI Brain index could not be found in the file store. The fix is the connector, or the index having been moved or renamed.
- **Index found, but no `resolver` block or no `humanizer_locales` key.** Say the index was found but declares no locales. The fix is the resolver block, not the connector. Apply US spelling as a flagged default for English.
- **Index and locales fine, but `resolver.files.voice_profile` does not resolve.** Say which filename was missing. The fix is the `files` map, not the connector. Run the full language pass anyway; only the voice fingerprint is missing, not the spelling and register.
- **`brain_version` lower than 4.** Say the brain predates this version of the plugin and ask for the newer brain. That needs a rebuild by whoever supplied it, not anything the reader can correct.

Do not infer a country or a language from a personal name, a currency symbol, a time zone, or the phrasing of the request.

## Step 2: decide the output language

The language of the piece being delivered decides everything below. It is not the language of the request: someone can ask in English for a Danish newsletter.

Take the language from what the finished text has to be. If a request genuinely leaves it open, use the language of the source material, and ask once when even that is ambiguous.

## Step 3: load exactly one body

**Danish output.** Load `references/dansk.md` and follow it in full. Stop here; nothing in the English body applies.

**English output.** Load `references/english.md` and follow it in full, then load exactly one locale annex:

- `us` loads `references/locale-us.md`
- `uk` loads `references/locale-uk.md`
- `au` loads `references/locale-au.md`

Ignore `dk` when picking the English annex. A list of `[dk, uk]` means Danish text follows the Danish body and English text follows the British annex. If the list holds more than one English locale, ask once which audience the piece is written for, then apply that annex alone. If the list holds no English locale at all, apply US spelling and say so.

The annex outranks the English body on spelling, vocabulary, units, money and register. Where they appear to disagree, the annex wins.

## Never mix the two languages

Load one body per piece of writing. Never both. A document, an email or a post is written in one language, and a Danish filter applied to English prose (or the reverse) produces exactly the stilted, translated register both bodies exist to remove.

When a task genuinely needs both languages, treat them as two pieces: draft and filter the Danish, then draft and filter the English, and keep them separate to the end.
