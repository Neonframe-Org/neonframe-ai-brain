# Changelog: neonframe-ai-brain

The client-facing plugin. Nine skills that read a person's voice, company context and guardrails from their own AI Brain folder.

**This file is canonical.** It replaced the copy that lived at `Skill Templates/neonframe-ai-brain-plugin/CHANGELOG.md` in the Neonframe Consulting shared drive on 2026-07-26. That copy is now a pointer to this one. Two changelogs drifting apart is the exact failure the v4 architecture was built to remove, so do not restore it.

`PLUGIN-VERSIONS.md` in the shared drive stays, and stays useful: it is the one-line-per-version operator view a weekly sweep reads. It records what each version contains and whether an update is required. This file carries the detail. Update both in the same change.

## How to release

1. Edit the skill source under `plugins/neonframe-ai-brain/`.
2. Bump `version` in **both** `plugins/neonframe-ai-brain/.claude-plugin/plugin.json` and the plugin entry in `.claude-plugin/marketplace.json`. They must match.
3. Add an entry below.
4. Push to `main`.
5. Add the one-line summary to `PLUGIN-VERSIONS.md` in the shared drive.
6. Update `WHAT-THE-SKILLS-DO.md` in `ai-brain-package-v4/AI Brain/setup/` if the skill set or its behaviour changed. That file is the client's readable summary inside their own brain, and this repository is the other half of the same promise.

**The version string is the cache key.** A change pushed without a version bump reaches nobody: installed copies are pinned to the version string, and only a change to it triggers an update. Forgetting step 2 is the one mistake that fails silently.

Treat the manual update command as the supported path:

```bash
/plugin update neonframe-ai-brain@neonframe-ai-brain
```

Auto-update is not relied on here. There is a known issue where it does not refresh `installed_plugins.json`, so a client can appear updated and not be. Verify current behaviour before changing this guidance.

Clients on an older version keep working. Skills resolve the brain at runtime, so nothing breaks when the brain is newer than the plugin. Never rebuild a client's brain to deliver a plugin update: the brain has learned things since handover and a rebuild would overwrite them.

## Versioning

- **Patch** for wording, a clarified instruction, a fixed typo in a skill.
- **Minor** for a new skill, or new behaviour in an existing one.
- **Major** for a change that requires something new in the brain, for example a new resolver key. A major release means older brains genuinely cannot serve it, so it needs a rebuild plan before it ships.

## 1.0.2, 2026-07-28

Fixes from an independent QA pass on the whole v4 delivery system. Everything here is wording inside skills; no resolver key changed, so no brain needs rebuilding.

**Fixes**

- `morning-briefing` named a `briefings/` folder that appears in no resolver `folders` map, the same hardcoding defect four other skills had fixed in 1.0.1. It also told the model to keep a running action list in the knowledge folder, which contradicts both the conventions file and `CLAUDE.md`: live state is not brain. It now keeps the list in the connected task tool, or in the chat, and asks once where a saved copy should go.
- Both humanizers now name four distinct failure cases, matching `morning-briefing` and the promise both READMEs make: index not found, index found with no resolver block, named voice-profile file missing, and brain older than the plugin. `humanizer-danish` was still on two, so a Danish client on a v3 brain was told to check their connector when the real fix was a rebuild.
- The client README now documents the offline `.zip`, the blocked-network route, and the fact that the uploader takes `.zip` and rejects `.plugin`. The file was sitting in `dist/` with nothing explaining it. The two Claude Code slash commands are no longer in shell code fences; they are typed in Claude Code, and a shell fence invited pasting them into a terminal.

**A correction to how 1.0.1 was released**

Commit `7ec3bef` edited `humanizer/SKILL.md` and rebuilt the offline zip about five hours after 1.0.1 was tagged, without bumping the version. That breaks this file's own rule, and the justification recorded in the commit ("never delivered to a client yet") is a claim nobody can verify after the fact. Anyone who installed inside that window holds a 1.0.1 whose content differs from the 1.0.1 published now. The third humanizer failure branch from that commit is folded into this release and the version is bumped properly. If you are on 1.0.1, update.

## 1.0.1, 2026-07-26

Distribution moved to this public marketplace repository. Two fixes from a hardcoding audit of all nine skills.

**Distribution**

- Clients now install by adding this marketplace and installing the plugin, in the Claude app UI or with two commands in Claude Code. The single `.plugin` file is retired as a delivery route; see the note below.
- Every skill is readable in this repository before installing, which is a better trust surface than the install preview alone. The client-facing `README.md` says so and links each skill.

**Fixes**

- Four skills referenced `clients/`, `projects/` and `templates/` as bare folder names instead of reading `folders.clients`, `folders.projects` and `folders.templates` from the resolver block. The resolver ships a `folders` map precisely so a skill never assumes a folder name. `company-safety`, `company-voice`, `company-context` and `update-my-brain` now read the map.
- Both humanizers merged "no index found in the file store" and "index found but the named file is missing" into a single message. Those have different fixes: one is the connector or a renamed index, the other is a wrong filename in the resolver block. Both now say which happened, and both still run the filter and deliver rather than blocking on a failed lookup, which is the right behaviour for a humanizer.

Audit result otherwise clean: no product name, personal name, client name, path or brain filename is hardcoded in any of the nine skills. `AI-BRAIN-INDEX.md` remains the single string they know.

**On retiring the `.plugin` file** (partly superseded, see below)

The single file existed because it was the only way into the Claude desktop app. It no longer is: the app takes a marketplace repository directly, under Customize > Plugins > Add marketplace. Keeping both routes would mean two artifacts built from one source, one of which silently never updates, and two populations of client on two support paths. That is the divergence v4 was built to remove. The file is gone from the brain template rather than kept as a fallback, and a client on a network that blocks GitHub gets it handed to them directly instead of everyone carrying it.

Superseded on 2026-07-27, before 1.0.1 reached anyone. Enough clients sit behind corporate networks that block GitHub that handing the file over mid-session was not workable, so an offline copy ships in the brain template after all, at `setup/offline-plugin/`. Two changes keep the divergence risk the paragraph above is worried about: it is a `.zip` built from this repository by `scripts/build-offline-zip.sh` rather than a separately maintained artifact, and the gate checks its checksum against the master on every build. The marketplace stays the primary route and the `.zip` is labelled a backup wherever it appears.

## 1.0.0, 2026-07-25

First release. Replaces the seven per-client skills that `create-client-ai-brain-v3` generated and zipped individually for every client.

**Nine skills**

| Skill | Does |
|---|---|
| `write-as-me` | Writes in the person's own voice, from their voice profile |
| `company-voice` | Writes as the company, for anything external |
| `company-context` | Answers business, client, competitor and market questions |
| `company-safety` | Applies the guardrails on every task |
| `update-my-brain` | Captures corrections, preferences, decisions and facts as they happen |
| `offload-my-brain` | Takes a brain dump and files it into the right places |
| `morning-briefing` | Builds the daily briefing from the connected tools |
| `humanizer` | Strips AI tells from English, per locale: us, uk, au |
| `humanizer-danish` | The same for Danish |

**Architecture**

- Skills carry no client detail at all. Each resolves the brain by searching the connected file store for one fixed filename, `AI-BRAIN-INDEX.md`, then reads the `resolver` block in its frontmatter for the person, their company, the file store, the language, the locales and every brain filename.
- That index filename is the single string all nine skills know. It is never prefixed and never renamed, and a skill that cannot find it says so and stops rather than guessing.
- Where two indexes come back, the highest `brain_version` wins.
- Nothing under `setup/` is ever read. It is onboarding, not context, and the client may delete it.
- Both humanizers ship to every client. Which apply is declared per client in `humanizer_locales`, so a Danish client running `[dk, uk]` gets both, each governing the language it covers. V3's one-humanizer-per-client rule was a consequence of per-client packaging and is retired.

**Included fix: knowledge home read and write parity**

V4.0 of the template shipped with knowledge reads and writes pointing at different places. `offload-my-brain` wrote to the stack's knowledge tool, while `company-context` searched only the brain's `knowledge/` folder and `update-my-brain` wrote only there. A client on Notion ended up with knowledge in two homes and retrieval blind to half of it.

All three now consult `knowledge_home` in the resolver block, for reads as much as for writes. Writes go to `primary`. Reads check `primary` and then `fallback`, always both, because anyone who changed tools mid engagement has older entries in the other home and silently missing them costs more than one extra search.
