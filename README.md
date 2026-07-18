# context-bar-statusline

A Claude Code status line that shows context-window usage as a bar, on a **non-linear scale**
that visually exaggerates real usage early — at 30% real usage the bar is already yellow and
~58% full (`displayed = 100 * (real/100)^0.42`). The goal: notice context bloat before it
becomes a problem, not after.

```
Claude ctx [██████████████░░░░░░░░░░] 42% (84k/200k)
```

Bar color: green (<30% real), yellow (30–60%), orange (60–85%), red (>85%).

## Install

```
/plugin marketplace add <your-org>/context-bar-statusline
/plugin install context-bar-statusline@context-bar-statusline-marketplace
/install-statusline
```

The last command writes a `statusLine` entry into your `~/.claude/settings.json` pointing at
the script bundled with this plugin. It backs up your existing `settings.json` first and will
never silently overwrite a status line you've already configured — it asks first.

Restart your Claude Code session (or run `/statusline`) afterwards to see it.

## Uninstall

```
/uninstall-statusline
```

removes the `statusLine` entry this plugin added (only if it's still pointing at this plugin's
script), then:

```
/plugin uninstall context-bar-statusline
```

## Why a slash command instead of an automatic hook?

Claude Code plugins can't declare a `statusLine` directly in their manifest — only a
`SessionStart`/other hook could write to `~/.claude/settings.json` automatically. This plugin
deliberately does **not** do that: silently rewriting a shared config file on every session
start is too invasive for something as personal as a status line. `/install-statusline` makes
the change explicit, visible, and reversible — you run it once, see exactly what it changes,
and can undo it just as explicitly.

## Requirements

- `jq` must be on `PATH` (the status line script pipes Claude Code's stdin JSON through it).

## License

MIT
