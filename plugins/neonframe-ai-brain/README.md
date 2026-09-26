# Neonframe AI Brain

Eight skills that make Claude work the way you do.

Your AI Brain is a folder of plain text files in your own cloud storage. It holds how you write, how your company writes, what the business is, and the rules you want followed. These skills read it when they need it, so you never have to explain yourself twice.

## What each skill does

| Skill | What it does |
|---|---|
| `write-as-me` | Anything going out in your name: emails, posts, notes, scripts. Reads your voice profile first. |
| `company-voice` | Anything speaking as the company: pitches, case studies, marketing. |
| `company-context` | Business, client, competitor and market questions. Reads what the company actually is. |
| `company-safety` | Your guardrails. Applies on every task, whether or not you mention it. |
| `update-my-brain` | Writes durable facts back into the brain when something changes. |
| `offload-my-brain` | Turns a link, screenshot, article or rough note into a clean saved entry. |
| `morning-briefing` | One page each morning: email, calendar, tasks, what needs you. |
| `humanizer` | Strips AI tells from anything you write, in English or Danish, and applies your spelling and register. |

## How they find your brain

Every skill looks for one file: `AI-BRAIN-INDEX.md` in your AI Brain folder. That file names everything else, along with your locale and where the brain lives.

Two things follow from that. Keep the index at the top level of the folder and keep its name exactly as it is. And if you rename any other file in the brain, update the index to match, and everything keeps working.

## Two layers, if you want them

Some teams keep the company's facts somewhere the whole team reads, such as a Notion workspace, and keep the personal files in the brain folder. The index can say so with an optional `company_layer` block naming the pages for the company context, the company voice, the prices, the operating rules and the shared knowledge base. When the block is there, the skills read the company from those pages and the person from the folder. When it is not, everything lives in the folder and nothing changes. Prices always come from the one page the block names, fetched every time, never quoted from memory.

## What they never do

- They hold no copy of your information. Everything is read from your folder at the moment it is needed, so editing a file updates every device at once with nothing to reinstall.
- They never send, post, schedule or purchase anything on your behalf. They draft, then stop.
- They never read your `setup/` folder. That is one-time onboarding, not context, and you can delete it once you are set up.

## If something stops working

A skill that cannot reach your brain says which step failed, because each one has a different fix:

- **The index was not found in your file store.** Either the connector is disconnected, or `AI-BRAIN-INDEX.md` has been renamed or moved out of the top level of the folder.
- **The index was found, but it declares no `resolver` block.** The file is reachable, but the block every skill reads is missing or incomplete. That needs whoever built your brain, not your connector.
- **The index was found, but a file it names is missing.** The fix is the `resolver` block inside the index, not the connector.
- **Your brain is older than the plugin expects.** Get in touch and we will bring it up to date.

No skill ever guesses at your voice or your company's facts to cover a failed lookup.

## Installing, reinstalling, updating, and reading the source

Everything lives at [github.com/Neonframe-Org/neonframe-ai-brain](https://github.com/Neonframe-Org/neonframe-ai-brain): the install steps, the update command, and the full readable text of all eight skills.

There are three ways in, best first. Add the marketplace, which is one step and keeps itself current. Upload the plugin `.zip` by hand, if your network blocks GitHub. Or, only if that is blocked too, add the eight skills one archive at a time from `setup/offline-skills/`. Neither hand-upload route updates itself, so move to the marketplace when your network allows.

Support: support@neonframe.io

Built by Neonframe. neonframe.io
