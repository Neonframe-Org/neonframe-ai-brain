---
name: humanizer
description: Anti-AI slop filter for English writing in any English locale. Claude runs this on every piece of English text before it is delivered: emails, client notes, proposals, pitch documents, reports, board papers, newsletters, LinkedIn posts, social captions, keynote scripts, case studies, award entries, course content, landing page copy, and internal memos. Triggers on any request to draft, write, edit, rewrite, polish, tighten, shorten, proofread or humanise English text, and on phrases such as "run the humanizer", "make this sound human", "does this read like AI", "clean this up before I send it", "check this over", and "make it sound like me". Resolves spelling, vocabulary, units and business register from the resolver block in the brain index, then loads the matching locale annex from its own references folder. For Danish text, the humanizer-danish skill applies instead.
---

# Humanizer: English

Run this filter on every piece of English writing before delivery. No exceptions. Draft first, then run the full pass, then deliver.

## Resolve the locale before editing anything

Spelling, vocabulary, units and register are locale decisions. Never guess them.

1. Search the connected file store for the file named `AI-BRAIN-INDEX.md`. Use the file store named in that brain's resolver block if it is already known; otherwise search every store that is connected.
2. Read the YAML frontmatter of that file and take `resolver.humanizer_locales`. Treat the value as a list, always, even when it holds one item.
3. Load exactly one annex per English locale in the list, from this skill's own references folder:
   - `us` loads `references/locale-us.md`
   - `uk` loads `references/locale-uk.md`
   - `au` loads `references/locale-au.md`
4. Ignore `dk` in that list. Danish text belongs to the Danish humanizer skill. A list of `[dk, uk]` means Danish text follows the Danish skill and English text follows the British annex. Each skill governs its own language and neither overrides the other.
5. If the list holds more than one English locale, ask once which audience the piece is written for, then apply that annex alone. Never blend two locales inside one document.
6. Never block delivery on a failed lookup. Apply this shared body in full, state in the reply that US spelling has been applied as a flagged default, and name which step failed, because each one has a different fix:
   - No file store reachable, or the search returned nothing: say the AI Brain index could not be found in the file store. The fix is the connector or the index having been moved or renamed.
   - Index found, but it carries no `resolver` block or no `humanizer_locales` key: say the index was found but declares no locales. The fix is the resolver block, not the connector.
   - Index and locales fine, but the file named at `resolver.files.voice_profile` does not resolve: say which filename was missing. The fix is the `files` map in the resolver block, not the connector. Run the locale sweep anyway; only the voice fingerprint is missing, not the spelling and register.
   Do not infer a country from a personal name, a currency symbol, a time zone, or the phrasing of the request.
7. The annex outranks this body on spelling, vocabulary, units, money and register. Where the two appear to disagree, the annex wins.

Also fetch the voice profile named at `resolver.files.voice_profile` before drafting anything that carries a person's name or a company's public voice. This filter strips AI tells. The voice profile supplies the fingerprint. Client-facing writing needs both.

## What this filter is

A 25 point self-check plus structural, punctuation, accuracy, formatting and substitution rules. Aim for writing that could only have come from someone who knows the topic, the audience, and their own voice.

## The 25 point check

Run every point. Fix anything that fails. Do not report the checklist to the reader; apply it and hand over clean text.

### Structure and flow

1. **Open with the point.** No warm-up, no context-setting, no restatement of the request. Cut everything before the first real sentence.
2. **Give every paragraph one job.** Split any paragraph doing two things. Cut any paragraph doing nothing.
3. **Land the ending.** The last sentence should feel like an arrival, not a trailing off. Rewrite weak endings.
4. **Delete unnecessary lists.** Write prose as prose. Reserve lists for content that is genuinely list shaped.
5. **Serve the reader, not the writer.** Cut any structure that exists to signal thoroughness rather than to help the reader.

### Sentence level

6. **Read it aloud.** Rewrite any sentence that makes you stumble or that sounds assembled rather than written.
7. **Vary sentence length aggressively.** Check the last five sentences. If three or more run to roughly the same length, break the pattern. Mix long, medium, short, and the occasional fragment.
8. **Never start two consecutive sentences with the same word.** Watch "The" and "This" hardest. Then watch "It", "There", "That", "However", "Additionally", "We".
9. **Make every word earn its place.** Cut adverbs that do not change meaning. Cut habit qualifiers: quite, rather, somewhat, very, actually, really, essentially, certainly, simply, truly.
10. **Cut passive construction.** Find the actor and make them the subject.
11. **Vary sentence openings.** Use introductory clauses, dependent clauses, inverted structures. Do not default to subject then verb in every sentence.
12. **Allow intellectual hesitation.** Real people do not write with total certainty. Use "suggests that", "appears to", "may indicate", "could mean" where the evidence is genuinely partial. Use them as epistemic honesty, never as a hedging habit.

### Voice and register

13. **Sound like this specific person, not a generic writer.** If the text could have been written for anyone, it has not been written for this person.
14. **Match formality to context.** A board paper and a comment under a post are different registers. Check which one this is.
15. **Hold the tone steady.** A lurch from formal to casual and back breaks the reader's trust.
16. **Choose the vocabulary rather than generating it.** AI settles in the middle of the range. Push for precise words, not merely adequate ones. Do not overcorrect into decorative synonyms or forced sophistication.
17. **Leave natural imperfections in.** Real writing has uneven rhythm and phrasing that is not always optimal. Total polish reads as machine output.

### Content

18. **Ground every claim.** Data, citation, or a specific example. Never a vague assertion.
19. **Take a side.** When the task calls for a recommendation, give one. A hedged non-position is worse than a clear recommendation the reader can argue with.
20. **Survive a fact-checker.** Verify statistics, names, dates, prices and regulatory references before delivering.
21. **Kill vague significance claims.** Do not call something crucial, significant, or important without saying precisely why and to whom.

### Banned phrasing, all variants

22. **Corporate and buzzword inflation:**
    - leverage (as a verb)
    - game-changer / paradigm shift / transformative / revolutionary / disruptive / groundbreaking / breakthrough / cutting edge / bleeding edge
    - robust / comprehensive / holistic / seamless / innovative / bespoke
    - empower (used loosely) / unlock potential / unlock value
    - foster / fostering / nurture / nurturing
    - synergy / synergistic / streamline
    - at scale / scalable solutions
    - best in class / world class / industry leading
    - future proof / future ready
23. **Transitions and filler:**
    - it's worth noting / it is important to note / it should be noted / it's important to remember
    - needless to say / it goes without saying / as previously mentioned
    - moreover / furthermore / in addition / additionally / likewise
    - in conclusion / in summary / to sum up / all in all
    - at the end of the day / when all is said and done
    - the fact of the matter is / the reality is / the truth is / here's the thing
    - let's be honest / honestly speaking / great question
    - delve into / dive into / explore / unpack
    - navigate (as metaphor) / landscape (as metaphor) / journey (as metaphor)
24. **Formulaic constructions:**
    - in today's fast-paced world / in today's rapidly evolving landscape / in an ever-changing world
    - the intersection of X and Y
    - not just X but also Y / it's not about X, it's about Y / it's not just about X
    - from X to Y, when X and Y are not a real scale. See the fake ranges rule below
    - by doing X, you can achieve Y, used as a conclusion
    - at its core / essentially / fundamentally
    - plays a significant role in / plays a crucial role in / plays a key role in
    - aims to / seeks to / strives to
    - showcasing / highlighting / underlining / underscoring / placing emphasis on
    - paving the way / laying the groundwork
    - shaping / shaped by / influenced by
    - provides insights into / offers insights
    - it is essential / it is crucial / it is imperative
    - whether you're X or Y, used as an opening
25. **Other tells:**
    - No rhetorical question that answers itself in the next sentence.
    - No triplets. Use three items only when the content genuinely holds three.
    - Do not write "remarked", "noted", "observed" or "showcased" where "said" or "showed" works.
    - Do not write "aligns with" or "in line with". Use "matches", "fits", "supports".
    - Do not write "opt for". Use "choose".
    - Do not write "ascertain". Use "find out" or "determine".
    - Do not write "utilise". Use "use".
    - Punctuation tells are covered in the punctuation rules below.

## Structural rules

These catch patterns the 25 point check does not hit head on. Treat them as hard rules.

**No "despite the challenges" arc.** A positive claim, then "despite" introducing difficulty, then vague optimism resolving it. The shape says nothing. Cut it entirely.

**No participial filler tails.** Phrases tacked onto the end of a sentence that sound analytical and add nothing. "The tool shipped in March, highlighting the team's commitment to quality." Cut after "March". The fact was enough.

**No fake ranges.** "From customer service to product innovation, the company has..." is not a range. A real range needs a real scale: years, prices, headcount, severity, distance. Two unrelated items in a trench coat do not qualify.

**No synonym cycling.** Restating one idea in three different vocabularies to sound thorough is a dead tell. Say it once, sharply.

**No stacked adjectives.** "Vibrant and dynamic" says the same thing twice. One adjective maximum, often none.

**No parallel structure across sections.** Different points deserve different treatment. Vary section length. Let some sections run to a single sentence.

**No challenge then triumph arc.** "At first it was hard, then I learned..." is a template, not a story. Find the specific moment and start there.

**No "may" as a safety blanket.** Reserve "may" for genuine uncertainty. When something is true, say it is true.

**No unearned "however" or "yet".** Valid only when what follows genuinely contradicts what came before. Decorative pivots are a machine habit. Delete any "however" that has not earned its place.

**No hedging seesaw.** Pick a side and state it plainly. A counterpoint that deserves acknowledgement gets one sentence, not equal weight.

## Punctuation rules

**Em dashes:** never. Use a comma, semicolon, colon, or a new sentence.

**Double hyphens:** never. If a single hyphen as punctuation is genuinely the only option, use it once per piece at most.

**Exclamation marks:** one per thousand words at most. Enthusiasm comes from word choice.

**Ellipses:** only for a genuine trailing off. Never as a transition. One per piece at most.

**Semicolons:** use them. Machines underuse them; people who write well reach for them naturally.

**Colons:** use them to set up a payoff, and make what follows deliver on it.

**Bold:** never bold a random phrase for emphasis in a post, an email, or a message. Let the words carry it.

**Quotation marks:** pick single or double according to the locale annex, then hold that choice through the whole piece.

**Serial comma:** decide once per piece and stay consistent.

## Accuracy and honesty

**Never invent data, studies, or statistics.** Where no real number exists, write "roughly" or name the uncertainty outright. Fabricated specificity destroys trust faster than honest vagueness.

**Never invent market or sector figures.** Category growth rates, market sizes, benchmark averages and survey findings are all checkable, and the audience checks them. When a number is not to hand, say so.

**Never fabricate a quote.** Paraphrase with attribution, or drop it.

**Attribute precisely.** A named organisation with the month and year of its release beats "research shows". A named person beats "experts say".

**Never present a hypothetical as real.** Signal it with "imagine" or "suppose".

**Take clear positions where the evidence is solid.** Qualify only genuine uncertainty.

**Flag anything you could not verify.** Say which claim needs checking rather than delivering it silently.

## Formatting rules

**No markdown headers in social posts, emails, or casual writing.** An instant tell.

**No emoji used as bullet points.** One or two emoji in a post can be fine. Every line opening with a tick or a flame is slop.

**No hashtag stacks.** Zero to two, worked into the text.

**No markdown in plain text contexts.** Emails, direct messages, chat. Asterisks that render as raw symbols give the whole thing away.

**Sentence case in headings.** Use title case only where the format demands it.

**Keep paragraphs uneven.** Three lines, then one, then four. Blocks of identical size read as generated.

## Push towards the specific

When the writing feels generic, swap general for concrete.

**Be specific, not general.** "Support tickets went from 240 a week to 90 in the two months after the rewrite" beats "significantly improved customer outcomes."

**Show rather than describe.** "A new starter reaches their first finished report in four clicks" beats "an intuitive onboarding experience."

**Use real numbers.** "Eleven people signed up in the first week, four came back the next day" beats "strong early traction."

**Name real things.** "The invoicing spreadsheet the finance team keeps" beats "existing internal systems."

**Include friction, doubt, and mess.** "The first version tested badly and we rebuilt it twice" beats "an iterative design process."

**Use contractions.** "don't" not "do not". "can't" not "cannot". "it's" not "it is".

**Anchor to time, place and context.** "Last Tuesday", "at 2am", "the week the audit landed".

**Reach past the obvious word.** Machines pick the highest probability token. Pick the second or third one when it is more precise.

**Let sentences be ugly sometimes.** Fragment. Or a run-on that keeps going because the thought is not finished yet. That reads human.

**Refuse significance inflation.** Little is groundbreaking, transformative, or unprecedented. Say what the thing actually is and what it actually did.

**Refuse vague expert attribution.** "Experts say" with no names is filler. Name the source, or cut the sentence.

## Final pass

Read the whole piece again, top to bottom.

1. Ask whether it sounds like the specific person it comes from. If not, find the single most wrong element and fix that one.
2. Run the locale sweep at the end of the loaded annex. Those are the errors that slip through most often for this audience.
3. Ask whether a language model following instructions could have produced this, or whether it reads as a person with opinions, constraints and a distinctive voice. Revise until the second answer is the true one.
4. Confirm no em dash, no double hyphen, and at most one hyphen used as punctuation survives.

Deliver only after all four steps pass.

## Technical note

**Perplexity and burstiness.** Detection tools look for low perplexity, meaning predictable word choice, and low burstiness, meaning flat sentence length variation. Counter both by choosing less common but precise vocabulary and by breaking expected patterns in paragraph shape as well as sentence length. Cycling through short, medium, long in sequence is itself a pattern. Vary the rhythm genuinely, including where paragraph breaks fall and where a section ends early.

**Voice consistency.** A specific voice comes from specific constraints: what this person knows, how they habitually phrase things, and what they would never say. Text that could have come from anyone is the strongest tell of all. Read the voice profile from the brain, then write inside its limits.
