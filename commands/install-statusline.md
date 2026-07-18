---
description: Enable the context-bar status line in your Claude Code settings
---

Enable the context-bar status line for this user.

Steps to follow, in order:

1. Find the absolute path of this plugin's bundled script. It lives at
   `scripts/context-bar-statusline.sh` inside the plugin's install directory.
   Locate it by running:
   ```
   find ~/.claude/plugins/cache -path "*context-bar-statusline/scripts/context-bar-statusline.sh" 2>/dev/null
   ```
   If that finds nothing, also try:
   ```
   find ~/.claude/plugins -path "*context-bar-statusline/scripts/context-bar-statusline.sh" 2>/dev/null
   ```
   Take the first match. If there are several (multiple installed versions), take the most
   recently modified one. If nothing is found at all, stop and tell the user the plugin
   script could not be located, and to verify the plugin is installed correctly.

2. Make sure the script is executable: `chmod +x <path-found-in-step-1>`.

3. Read `~/.claude/settings.json` (create it with `{}` if it does not exist yet).

4. If it already has a `statusLine` key:
   - If it already points at this same script path, tell the user it's already installed and stop.
   - Otherwise, **do not overwrite it**. Show the user their existing `statusLine` config and ask
     whether they want to replace it with the context-bar status line, or keep their current one.
     Only proceed to step 5 if they explicitly confirm replacement.

5. Back up the current file to `~/.claude/settings.json.bak` (only if it doesn't already exist,
   to avoid clobbering an earlier backup), then merge in:
   ```json
   "statusLine": {
     "type": "command",
     "command": "<absolute-path-found-in-step-1>",
     "padding": 1
   }
   ```
   preserving every other existing key in the file untouched.

6. Confirm to the user what was changed, where the backup lives, and that they need to start a
   new Claude Code session (or run `/statusline`) to see the new status line.
