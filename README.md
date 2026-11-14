# credit

[한국어](README.ko.md)

A small terminal tool that runs `claude -p` on the monthly API credit (promotional credit) that comes with
Claude Max, Ultra and Team plans.

> Unofficial. Not made by or affiliated with Anthropic.

macOS and Windows. Needs Claude Code (`claude`) and Python 3 (standard library only; on Windows also the
`keyring` package, which `install.ps1` installs).

## Who can use the credit

According to the official docs
([API credits for subscribers](https://platform.claude.com/docs/en/about-claude/api-credits-for-subscribers)),
the credit covers API calls made with **your own API key**, including `claude -p` and the Agent SDK run that way.
Interactive Claude Code and the IDE extensions are **not** covered.

- **Who gets it** (as of Nov 2026): Claude **Max, Ultra or Team** plan (not Pro), from 7 days after subscribing.
- **How to get it** (once; then it arrives every month): on the claude.ai **website** (not the app), go to
  **Settings > Billing > API credits** and connect your Claude Console account. The Console calls it an
  "organization"; for one person it's just your account.

## Set up the Console first (important)

In that organization, turn **auto-reload off**. Then nothing is charged automatically, and when the credit runs
out, requests simply stop.
Check at <https://platform.claude.com/settings/billing>, then create an API key there.

## How it works

```
Claude Code chat in VS Code                    credit (terminal program)
───────────────────────────                    ─────────────────────────
"use credit to fix this bug"
   │  sees the credit rule in CLAUDE.md
   │  and hands the task over
   └──────── credit run "fix this bug" ─────▶  takes the API key from the keychain
                                                runs claude -p with that key
                                                (= paid from the credit)
                                                reads/edits files, runs commands
   ┌──────── reply + "this $X · month $Y" ◀──┘
   ▼
passes the reply on, briefly
```

1. **Install** adds a credit rule to `~/.claude/CLAUDE.md`: when you say "use credit", don't do the task here, hand it
   to `credit run` (only between its markers; the rest of the file is untouched).
2. **When you say "use credit"**, the chat's Claude doesn't do the work itself; it runs `credit run "the task"` in the
   background.
3. **`credit run`** runs `claude -p` with the API key from your keychain. Your login isn't passed on, so it's paid from
   the **credit**, not your plan's usage. The real work (reading and editing files, running commands) happens here.
4. **When it's done**, the reply and the cost go back to the chat's Claude, which passes them on briefly. The chat only
   receives the result, so it uses very little of your plan.
5. **Each project folder** keeps one conversation that continues, so it remembers earlier work. Say "new conversation"
   to start over.
6. **When the credit is used up**, the API stops and `credit` says so plainly. The chat's Claude then asks whether to do
   the task itself.

## Install

```sh
git clone https://github.com/travelwithme232/claude-credit.git
cd claude-credit
./install.sh                                              # macOS
powershell -ExecutionPolicy Bypass -File install.ps1      # Windows
```

Or double-click **install.command** (macOS) or **install.bat** (Windows). A downloaded zip loses the execute
permission and is quarantined, so the first time **right-click > Open** (macOS; on Windows choose "More info >
Run anyway" if SmartScreen asks).

Copies `credit` to `~/.local/bin/` (Windows: `credit.py` + `credit.cmd`, asking before overwriting) and turns on
the VS Code integration: a marked block (`<!-- credit:start -->` … `<!-- credit:end -->`) in `~/.claude/CLAUDE.md`
and `~/.claude/commands/credit-result.md`. Saying "use credit" in Claude Code then hands the task to
`credit run` in the background. Nothing else in CLAUDE.md is touched.

## Use

In Claude Code, just say **"use credit"**, e.g. "use credit to fix this bug". The task runs on the credit in the
background, and you get the reply and the cost when it's done.

Settings:

```
credit                         status: spent this month, settings, key
credit help                    what credit is, setup, commands, costs
credit key                     confirm auto-reload is off, then enter the API key (hidden)
credit set cap|model VALUE     optional, the defaults work fine:
                                 cap = most one message may spend (default $10; it stops past that)
                                 model = auto (the conversation's last model, opus at first) | opus | sonnet | fable
credit uninstall               remove everything credit added (asks first)
```

- **Nothing to enter**: with auto-reload off, the API itself stops when the credit is used up or expires.
  credit then shows a plain "the credit is used up" message instead of the API error, and Claude Code asks
  whether to do the task itself. A task that is running at that moment can stop halfway.
- Each project folder keeps one conversation that continues. To start over, say "use credit, new conversation".
  A long conversation costs more per message, so start a new one when a job is done. Default model `auto` = the conversation's last model, else opus.

Files: `~/.claude/credit/config.json` (settings), `spend.json` (cost per message). The key lives only in the
macOS keychain / Windows Credential Manager (item `claude-credit`).

## Cost notes

- A long conversation re-sends its history, so one message can cost a few dollars.
- The prompt cache lasts about 5 minutes: continuing within 5 minutes is much cheaper.
- Models differ a lot in price; sonnet costs less than opus.

Prices per 1M tokens (Nov 2026; they may change — see the
[pricing page](https://platform.claude.com/docs/en/about-claude/pricing)):

| Model | Input | Output | Cache read |
|---|---|---|---|
| Fable 5.1 | $10 | $50 | $0.25 |
| Opus 5.5 | $4 | $20 | $0.20 |
| Sonnet 5.5 | $2 | $10 | $0.10 |

Fable costs 2.5x Opus; opus is the usual pick (`credit` warns when the default model is fable).
Example: continuing a long conversation (~250K tokens) for the first time, or after more than 5 minutes, costs
about $3 just to read it on Fable and about $1.3 on Opus; within 5 minutes, a few cents.

`claude` runs in a clean environment holding only `ANTHROPIC_API_KEY` plus basics (HOME, PATH, …): if VS Code's
environment leaked in, it would run on your subscription instead. `--bare` is not used.

## Uninstall

```sh
credit uninstall
```

After asking, it removes only the credit block from `~/.claude/CLAUDE.md` (the rest stays), `credit-result.md`,
`~/.claude/credit/`, the API key, and the `credit` program itself, then lists what it removed.

## License

MIT
