# Backups and Restore

Every **Apply** first saves the files it changes in `faction_tool_backups` next to `data`, one folder per
write. **Tools -> Restore a backup...** puts them back **byte for byte** and removes what that write created.
The list shows each write by date, faction and number of files, newest first. Pick the one to go back to and
**Undo back to here** undoes it and every write after it in one go (newest first, as they must be); pick the
lowest line to get the files back as they were before the tool's first write.

- **Preview changes** shows every file and line before anything is written.
- **Undo** / **Redo** (Ctrl+Z, Ctrl+Y) step back through what you did in the window before Apply.
- **Check mod** reads every file the tool uses and reports what it cannot make sense of; the deep check
  rehearses an edit and a new faction for every faction in memory. Nothing is written.
- **Scan mod** lists everywhere a faction is named in the whole mod, and which files are the game's own,
  changed by the mod, REX's or the mod's.
- A [separate mod folder](First-steps#a-separate-mod-folder-recommended) keeps your base mod untouched.
