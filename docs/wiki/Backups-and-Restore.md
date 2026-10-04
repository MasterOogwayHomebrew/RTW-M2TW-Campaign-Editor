# Backups and Restore

Every **Apply** first saves the files it changes in `CampaignEditor_backups` next to `data` (older versions' backups are listed too), one folder per
write. **Tools -> Restore a backup...** puts them back **byte for byte** and removes what that write created.
The list shows each write by date, faction and number of files, newest first. Pick the one to go back to and
**Undo back to here** undoes it and every write after it in one go (newest first, as they must be); pick the
lowest line to get the files back as they were before the tool's first write.

- **Preview changes** shows every file and line before anything is written.
- **Undo** / **Redo** (Ctrl+Z, Ctrl+Y) step back through what you did in the window before Apply.
- **Check mod files** reads every file the tool uses and reports what it cannot make sense of; the deep check
  rehearses an edit and a new faction for every faction in memory. Nothing is written.
- **Check mod files** with a faction picked also lists everywhere that faction is named in the whole mod, and which files are the game's own,
  changed by the mod, REX's or the mod's.
- A [separate mod folder](First-steps#a-separate-mod-folder-recommended) keeps your base mod untouched.
- **A file Windows will not write** (held by the game or another program, read-only, no rights in the folder,
  the disk full, a path over 260 characters): Apply says which file and what to do, and puts back what it had
  written already - the mod is never left half changed. Restore that meets such a file stops, keeps the backup
  whole, and simply runs again once the file is free.
- **Backups of a newer version** stay listed after going back to an older one; a backup it cannot read is refused
  in plain words, nothing changed - restore it with the version that made it.

## Check and install a pack

Many mods come as "copy the data folder over the game". **Tools -> Check and install a pack...** opens such a
pack (a `.zip` or its folder) and lists every file of its `data` folder against the loaded mod before anything is
written: **new**, **the same** as the mod's, or **replaces** the mod's - and what a replacement would lose:

- a file of **REX's own** (REX's version would be gone);
- a **picture of another size** than the one it replaces - for a page of interface icons, the icons that would
  fall outside it;
- a **text file**: how many lines differ. One that differs in a few lines goes in as **only its changes** - the
  pack's changed and added lines are taken, lines it would drop (REX's, the mod's own) stay. One that differs in
  most lines is another mod's whole file and is kept back.

Lines that lose something are red and set to keep the mod's file; double click a line (or pick lines and use the
buttons) to choose **put in**, **only its changes** or **keep this mod's**. **Preview**, then **Install** writes
it with a backup - **Restore** takes the whole install back. Files outside `data` (readmes) are only listed.

