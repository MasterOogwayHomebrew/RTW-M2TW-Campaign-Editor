# Backups and Restore

Every **Apply** first saves the files it changes in `faction_tool_backups` next to `data`, one folder per
write. **Tools -> Restore a backup...** puts them back **byte for byte** and removes what that write created.
Restore the **newest** one first.

- **Preview changes** shows every file and line before anything is written.
- **Undo** / **Redo** (Ctrl+Z, Ctrl+Y) step back through what you did in the window before Apply.
- **Check mod** reads every file the tool uses and reports what it cannot make sense of; the deep check
  rehearses an edit and a new faction for every faction in memory. Nothing is written.
- **Scan mod** lists everywhere a faction is named in the whole mod, and which files are the game's own,
  changed by the mod, REX's or the mod's.
- A [separate mod folder](First-steps#a-separate-mod-folder-recommended) keeps your base mod untouched.
