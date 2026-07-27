# Neonframe AI Brain

The Claude plugin that reads your AI Brain.

Your AI Brain is a folder of plain text files in your own cloud storage. It holds how you write, how your company writes, what the business is, and the rules you want followed. This plugin adds eight skills that read those files at the moment they're needed, so you never explain yourself twice.

The folder is yours. The plugin only reads it.

## Install

You need your AI Brain folder in your own cloud storage first, and that storage connected to Claude. Your setup guide covers both. If the plugin can't reach the folder, the skills will tell you so rather than guess.

### In the Claude app

1. Open **Customize** in the left sidebar.
2. Go to the **Plugins** tab.
3. Under **Personal plugins**, click **+**, then **Add marketplace**.
4. Choose **Add from a repository** and enter:

```
Neonframe-Org/neonframe-ai-brain
```

5. Find **Neonframe AI Brain** in the list and click **Install**.

That's it. The skills work in chat on the web, in the Chat tab in Claude Desktop, and in Claude Cowork.

### In Claude Code

Type these two in Claude Code itself, not in a terminal:

```
/plugin marketplace add Neonframe-Org/neonframe-ai-brain
```

```
/plugin install neonframe-ai-brain@neonframe-ai-brain
```

### If your network blocks GitHub

Some corporate networks block this repository, so the marketplace add above will fail. There's a backup: a `.zip` of the same plugin that you upload by hand.

1. Your setup folder has it, at `setup/offline-plugin/`. If you don't have that folder, the same file is in [`dist/`](dist/) here, and whoever set you up can send it to you.
2. In the Claude app, go to **Customize > Plugins > Personal plugins**, click **+**, and choose to upload a plugin file.
3. Pick the `.zip`.

It has to be the `.zip`. The uploader rejects a `.plugin` file with an unhelpful error, which is a known bug in the app, not a problem with the file.

One tradeoff: a hand-uploaded plugin doesn't update itself. When there's a new version you upload the new `.zip` the same way. Installing from the marketplace is better whenever your network allows it.

## Before you install, read what you're installing

Claude will warn you that plugins from marketplaces aren't controlled by Anthropic. That warning is correct and you should take it seriously, including with ours.

So here's the honest version.

**Who publishes this.** Neonframe, an AI consulting practice. neonframe.io. This repository is public so you can check that for yourself.

**What's in it.** Eight skills. A skill is a set of written instructions in a Markdown file, nothing more. No code runs, nothing is uploaded anywhere, and no copy of your information is kept inside the plugin.

**How to check.** Every skill is readable in this repository right now, before you install anything:

| Skill | What it does | Source |
|---|---|---|
| `write-as-me` | Anything going out in your name: emails, posts, notes, scripts. Reads your voice profile first. | [SKILL.md](plugins/neonframe-ai-brain/skills/write-as-me/SKILL.md) |
| `company-voice` | Anything speaking as the company: pitches, case studies, marketing. | [SKILL.md](plugins/neonframe-ai-brain/skills/company-voice/SKILL.md) |
| `company-context` | Business, client, competitor and market questions. | [SKILL.md](plugins/neonframe-ai-brain/skills/company-context/SKILL.md) |
| `company-safety` | Your guardrails. Applies on every task, whether or not you mention it. | [SKILL.md](plugins/neonframe-ai-brain/skills/company-safety/SKILL.md) |
| `update-my-brain` | Writes durable facts back into the brain when something changes. | [SKILL.md](plugins/neonframe-ai-brain/skills/update-my-brain/SKILL.md) |
| `offload-my-brain` | Turns a link, screenshot, article or rough note into a clean saved entry. | [SKILL.md](plugins/neonframe-ai-brain/skills/offload-my-brain/SKILL.md) |
| `morning-briefing` | One page each morning: email, calendar, tasks, what needs you. | [SKILL.md](plugins/neonframe-ai-brain/skills/morning-briefing/SKILL.md) |
| `humanizer` | Strips AI tells from anything you write, in English or Danish, and applies your spelling and register. | [SKILL.md](plugins/neonframe-ai-brain/skills/humanizer/SKILL.md) |

Reading the source before installing is worth doing here and worth doing everywhere. A skill can act with your access, so installing one is closer to handing over your login than to downloading an app.

## What they never do

- They hold no copy of your information. Everything is read from your folder at the moment it's needed, so editing a file updates every device at once with nothing to reinstall.
- They never send, post, schedule or purchase anything for you. They draft, then stop.
- They never read your `setup/` folder. That's one-time onboarding, not context, and you can delete it once you're set up.
- None of them crawls your storage or reads anything outside your AI Brain folder.

## How they find your brain

Every skill looks for one file: `AI-BRAIN-INDEX.md` in your AI Brain folder. That file names everything else, along with your locale and where the brain lives.

Two things follow. Keep the index at the top level of the folder and keep its name exactly as it is. And if you rename any other file in the brain, update the index to match, and everything keeps working.

## Updates

Run this when we tell you there's a new version:

```bash
/plugin update neonframe-ai-brain@neonframe-ai-brain
```

In the Claude app, the same thing lives under **Customize > Plugins**.

Updating never touches your AI Brain. The skills and your files are independent by design, which is why a plugin fix reaches you without anyone rebuilding your brain and overwriting what it has learned since.

## If something stops working

A skill that can't reach your brain will say which step failed, because each one has a different fix:

- **The index wasn't found in your file store.** Either the connector is disconnected, or `AI-BRAIN-INDEX.md` has been renamed or moved out of the top level of the folder.
- **The index was found, but a file it names is missing.** The fix is the `resolver` block inside the index, not the connector. Correct the filename there.
- **Your brain is older than the plugin expects.** Get in touch and we'll bring it up to date.

Anything else: support@neonframe.io.

## Reinstalling

If you change machine, reset your account, or delete your setup folder, come back to this page. The install steps above are all you need, and they don't depend on anything you may have deleted. The install instructions are also recorded in your own brain, in `AI-BRAIN-INDEX.md` and `CLAUDE.md`, both of which are permanent.

Built by Neonframe. [neonframe.io](https://neonframe.io)
