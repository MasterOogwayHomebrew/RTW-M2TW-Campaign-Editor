# First steps

1. **Close the game.**
2. **Browse...** and pick the mod's `data` folder, for example
   `...\Rome Total War Gold\HLR\data`, or the game's own `data`. Next time the tool opens the last mod by
   itself; **Mod** at the top lists every mod of the game folder.
3. Pick the **campaign** (usually `imperial_campaign`).
4. Choose the work at the top: **Maps** (its **Terrain** tab paints the ground, rivers and climates, its
   **Coast & heights** tab the coast and the heights), **Factions** (its tabs **Edit faction** and **New faction**), **Units**, **Buildings** or **Characters**.

Every change waits until you press **Preview changes** (shows every file and line) and **Apply changes**
(writes it, with a backup). **Undo** / **Redo** step back through what you did in the window.

**No scrollbars**: every list, table, page and read-only text scrolls by the mouse wheel, by **dragging** it with the left button (it follows the mouse, up / down and left / right) and by the **middle button**: press the wheel and move the mouse - the further from where you pressed, the faster it scrolls, both ways (held: it stops when you let go; a click: it goes on until the next click or Esc). A text you can type in keeps the left drag for selecting words. The map is as before (the right button moves it).

## Medieval II

Medieval II keeps most data in `packs`. Load the game folder (or a Kingdoms campaign's folder, such as `mods/british_isles`) and the tool offers to
unpack it with the game's own unpacker (the campaign's own `unpack_britannia.bat` and the like for a campaign; it copies the two DLLs the unpacker needs, `msvcp71.dll` and `msvcr71.dll`, next to it). Set-up
problems that stop the game from starting (M2EX's `vegetation_source text` without the raw vegetation maps)
are found on Load and fixed with a yes.

## A separate mod folder (recommended)

**New mod folder...** after loading the mod you build on makes a copy of it next to it (for example
`HLR_Saba`) with its own start file. Your base mod is never touched. On the **plain game** it makes a **thin** mod
instead: nothing is copied (made at once, no disk space) - the mod holds only what you change and the game reads every
other file from its own `data`; the editor puts a game file into it the first time you change it (the whole map folder,
all but `map.rwm`, the first time you change the map - the game then builds its map again there). Before the first
write into the game's own data or a mod it did not make, the editor asks once: *Make my own mod folder* or *Write
here*.

- **Rome / REX:** `<game>\<name>\`, started by `Start_<name>.bat` (`-mod:<name>`).
- **Medieval II:** `<game>\mods\<name>\` with `<name>.cfg`, started by `Start_<name>.bat` (under M2EX: `M2EX.exe --features.mod=mods/<name>`).

**Start the game** (the green button at the bottom right, beside Tools) says what it starts - *Start Rome - CE_Test*,
or in amber *Start Rome - no mod* when the game's own data is loaded - and starts the game with the mod that is
loaded: its own start script, else the line the engine's own start scripts use (`REX.exe -mod:<name>`, `-bi` /
`-alx` for the expansions, `M2EX.exe --features.mod=mods/<name>`). Apply your changes first - the game reads the
files on disk; the button names any change not written yet. Before it starts the game it checks: a start script
that starts an exe the game folder lacks is refused in plain words, a Medieval II `.cfg` that does not name the
mod's folder is asked about, and a 32-bit game exe that can use only 2 GB of memory is noted in the status line.

A mod built on another mod (HLR) holds all of it - the game reads one mod folder, never a chain. Every file is
copied, so the new mod stands on its own - to share, to zip, to change in any program. For a mod
you keep to yourself, tick **Hard links instead of copies**: text files are still copied, everything else becomes
a **hard link** (the same file on disk under a second name) - no extra disk space, Explorer still shows full
sizes, and deleting the new mod folder never touches the game. Do not overwrite a linked texture in place from
an image editor.
