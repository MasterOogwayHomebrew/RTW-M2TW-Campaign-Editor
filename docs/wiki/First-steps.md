# First steps

1. **Close the game.**
2. **Browse...** and pick the mod's `data` folder, for example
   `...\Rome Total War Gold\HLR\data`, or the game's own `data`. Next time the tool opens the last mod by
   itself; **Mod** at the top lists every mod of the game folder.
3. Pick the **campaign** (usually `imperial_campaign`).
4. Choose the work at the top: **Map editor** (its **Terrain** tab paints the ground, rivers, climates and
   heights), **New faction**, **Edit faction**, **Unit editor**, **Building editor** or **Character editor**.

Every change waits until you press **Preview changes** (shows every file and line) and **Apply changes**
(writes it, with a backup). **Undo** / **Redo** step back through what you did in the window.

## Medieval II

Medieval II keeps most data in `packs`. Load the game folder and the tool offers to unpack it with the game's
own unpacker (it copies the two DLLs the unpacker needs, `msvcp71.dll` and `msvcr71.dll`, next to it). Set-up
problems that stop the game from starting (M2EX's `vegetation_source text` without the raw vegetation maps)
are found on Load and fixed with a yes.

## A separate mod folder (recommended)

**New mod folder...** after loading the mod you build on makes a copy of it next to it (for example
`HLR_Saba`) with its own start file. Your base mod is never touched.

- **Rome / REX:** `<game>\<name>\`, started by `Start_<name>.bat` (`-mod:<name>`).
- **Medieval II:** `<game>\mods\<name>\` with `<name>.cfg`, started by `Start_<name>.bat` (under M2EX: `M2EX.exe --features.mod=mods/<name>`).

Text files are copied; everything else is a **hard link**: the same file on disk under a second name. Explorer
shows tens of thousands of files at full size, but they take no extra disk space, and deleting the new mod
folder never touches the game. Do not overwrite a linked texture in place from an image editor (or tick
**Copy every file**).
