---
description: Remove the context-bar status line from your Claude Code settings
---

Disable the context-bar status line for this user.

Steps to follow, in order:

1. Read `~/.claude/settings.json`. If it doesn't exist or has no `statusLine` key, tell the user
   there is nothing to remove and stop.

2. Check whether the `statusLine.command` value contains `context-bar-statusline.sh`.
   - If it does NOT, tell the user their current status line was not installed by this plugin,
     show them the current config, and ask before touching anything.
   - If it does, back up the file to `~/.claude/settings.json.bak` (only if that backup doesn't
     already exist) and remove the `statusLine` key entirely, preserving every other key.

3. Confirm to the user what was changed and that a new Claude Code session is needed for the
   change to take effect.
