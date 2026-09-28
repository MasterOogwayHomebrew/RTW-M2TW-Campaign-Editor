# RTW Campaign Editor (formerly RTW Faction Tool) - notes for Claude

The package is still `faction_tool`, backups `faction_tool_backups`, the log `faction_tool.log`
(kept for compatibility); the window, exe and README say RTW Campaign Editor.

Read this first. It is the project's memory between sessions: who the user is,
how to work with him, what the tool does, what was learned the hard way, and
where the work stands.

## The user and how to work with him

- Adam (GitHub `MasterOogwayHomebrew`). Writes in Russian: **answer in Russian**,
  briefly and directly, and verify before claiming. Repo texts (code, comments,
  README, commits) stay **in English**.
- He mods **Rome: Total War Gold (Steam)** with **REX** (unofficial 64-bit engine,
  github.com/Pannoniae/rex; README says REX lifts the faction/region limits).
  Main mod: **Barbarian Empires REX Ultimate Edition** in the folder `HLR`
  (`C:\Steam\steamapps\common\Rome Total War Gold\HLR\data`), started by
  `HLR\Start_mod.bat`: `cd ..\.` / `start REX.exe -nm -show_err -mod:HLR -multirun`.
- He tests in the game and sends `system.log.txt` (zip from REX) and screenshots.
  Old HLR errors that are not ours: 31x `settlement_construction.cpp(1410)`,
  `Combat_V_Illyria/Hibernians`, missing julii/huns/sarmatians/burgundii textures.
- **Files from his PC**: only what he uploads. The chat takes files up to
  **30 MB**: he packs with 7-Zip, "Split to volumes" `30M` (`x.7z.001`, `.002`...).
  Join with `cat x.7z.0* > x.7z`. py7zr hangs on some archives: use `7z x`
  (`apt-get install p7zip-full`). The 7z start header gives the total size, so a
  missing volume can be spotted: bytes 12..32 = NextHeaderOffset, NextHeaderSize.
- Uploaded files live only in the session container. **Never commit game files**
  (the repo is public); keep only derived notes and manifests in `docs/reference`.
- Push: work on the session branch, then fast-forward `main` (he approved pushing
  main). CI builds the Windows exe on every push to main; give him the Actions run
  link (artifact at the bottom). Unsigned exe: browser/SmartScreen warn - "Keep" /
  "More info -> Run anyway".

## What the tool is

Python 3, standard library + **Pillow** (pictures; in the exe build). tkinter
window + command line. Adds a faction to an RTW mod by cloning a template, or
**edits an existing one**, previews every change, writes with a backup
(`<mod>/faction_tool_backups/<stamp>_<name>/manifest.json`) that Restore undoes
byte-exactly.

| Module | Job |
|---|---|
| `textio.py` | byte-exact text round trip (latin-1 descr files, UTF-16LE+BOM `data/text`); `save()` writes a temp file and replaces (never writes through a hard link) |
| `tga.py` | TGA reader, bottom-up rows = descr_strat tile (x, y) |
| `moddata.py` | finding files (campaign folder, fallback `world/maps/base`), factions, cultures, name pools, regions, city tiles, `free_tile` / `_standable` / `tile_problem` / `is_sea`, `campaign_text_files` |
| `strat.py` | descr_strat: faction blocks, settlements, character chunks (`character, sub_faction X, ...`) |
| `clone.py` | all non-strat edits of a new faction; `text_strings` (whole multi-line entries), `campaign_description`, `FE_NAMES`, `unit_cards`, art copy, `lookup_keys` |
| `start.py` | the new faction's block in descr_strat: towns, one army per town, leader/heir placement, balanced army, garrisons/buildings by hand |
| `build.py` | runs a new-faction build + `validate()` |
| `edit.py` | `read_faction` / `edit`: names, texts, colours, AI, denari, playable, take/give towns, capital, leader/heir, moves, garrisons, buildings |
| `units.py`, `buildings.py` | EDU and EDB parsing, card/building pictures (culture fallbacks via `descr_ui_buildings.txt`) |
| `newmod.py` | a separate mod folder `<game>/<name>` (text copied, the rest hard-linked, `Start_<name>.bat`), `slim` |
| `scan.py` | Scan mod (mentions of a faction in the whole mod), ignore list, game manifest |
| `mapdata.py`, `gui_map.py` | Map tab: background drawn from map_ground_types (the user prefers it to the painted radar map), political layer, cities, ports, characters, drag |
| `gui.py`, `gui_garrison.py`, `gui_buildings.py` | the window: tabs Faction / Units & armies / Buildings / Map, New/Edit mode |
| `log.py` | `faction_tool.log` next to the exe: loads, previews, writes, restores, status lines, every error box and Tk callback traceback; **Log** button. Ask the user for it with system.log.txt |
| `mapedit.py` | moving towns and ports: `place_problem`, `apply_places` |
| `diplomacy.py`, `gui_diplomacy.py` | core_attitudes / faction_relationships: `read`, `set_relations` (only lines naming the faction), Diplomacy tab, map Diplomacy colours; opts `relations` |
| `check.py` | Check mod: file/consistency report; deep = `rehearse` every faction in memory (VAN 4 min) |
| `regionedit.py` | new regions / region borders: `region_problems`, `apply_regions`, `free_colour`; Map Regions mode (paint, right-click pick, Its town/port); opts `regions` {painted, new} |
| `cli.py` | `list towns names example new scan newmod slim manifest restore` |

Tests: `python -m unittest discover -s tests` (a synthetic mini-mod; 20+ tests,
restore byte-identical). GUI checks: `xvfb-run -a python3.12 script.py` with
`PIL.ImageGrab` screenshots (python3.12 has tkinter + Pillow here).

## Hard-won rules (do not break)

- **Names** written to descr_strat must exist in the name pool (descr_names +
  names string table) - else crash in `CHARACTER_DB::create/name_set`.
- **One army per settlement** at the start; a second one is refused ("already
  garrisoned") and sticks on the tile. Leader holds the capital, heir the second
  town or a free tile next to it.
- **Tiles** a land character (army or agent alike - the user checked in the game)
  may start on: land that is not sea, mountains, high mountains or dense forest
  (map_ground_types tile centre, 2x+1 resolution) and has no river/ford/cliff
  (`map_features` non-black) - `moddata.land_problem`. Hills, woodland, swamp and
  steep tiles are fine (the old slope <= 25 rule refused HLR 150,246, a hills tile the
  game accepts); REX's "invalid tile" crashes were a ford (406,42) and mountains (404,42).
  A bad drop/placement goes to the nearest good tile (MapView.nearest).
- **Settlements** move as whole `settlement { }` blocks; two blocks for a region
  is fatal. The capital is the faction's **first** settlement block.
- **Text tables**: a value runs until the next `{KEY}` or `¬` line - long texts
  span lines. Copy/replace whole entries, insert copies after the template's
  whole entry, keep the key's case. `*_regions_and_settlement_names.txt` are
  region labels - leave alone. Per-campaign tables `<campaign>_expanded_bi.txt`
  win over `expanded_bi.txt`; read/edit only the chosen campaign's.
- **Campaign-screen text**: `{<CAMPAIGN>_<FACTION>_TITLE/_DESCR}` in
  `campaign_descriptions.txt`, but some vanilla factions use front-end names:
  gauls->GAUL, romans_julii->JULII, romans_brutii->BRUTII, romans_scipii->SCIPII,
  britons->BRITANNIA, germans->GERMANIA. Always write the new faction's own keys;
  vanilla also lists keys in `lookup_campaign_descriptions.txt`.
- **Unit cards**: `ui/units/<f>/#<dictionary>.tga`, `ui/unit_info/<f>/<dictionary>_info.tga`;
  a folder left from an earlier attempt must be filled file by file.
- **Game loads text** from `data/text/english/` and then `data/text/`; the tool
  edits `data/text/*.txt` only (English only, by the user's choice).
- **REX** takes one `-mod:` folder, falls back to the game's `data`; no mod chain.
  REX looks for the sound pack **by the mod's name** (`<mod>/data/sounds/<mod>.idx`),
  so a new mod folder also gets `HLR.idx/.dat` under its own name.
- **Map files**: `map_regions.tga` black = city, white = port; `radar_map1.tga`
  (HLR: 1440x881) is the in-game minimap, 2 px per tile, top-down.
- `descr_sm_factions.json` (REX) may lack a faction - fine. Logos: sprite names in
  `ui/strat3.sd.xml` / `shared2.sd.xml` (`FACTION_LOGO_<F>`) - future banner work.
- The balanced army pool takes only land generals' units (not admirals' ships).
- New characters go **before** the faction's `character_record` / `relative`
  lines; a `character` after them crashes on load (`WORLD::finalise_faction_groupings`).
- `_chars_at`: every character edit.py adds (captains, arriving characters, new
  armies) goes before the family tree; `characters_after_tree` refuses to write otherwise.
- EDU `category non_combatant` (townsfolk) is never offered as a unit.
- A region descr_strat leaves out (vanilla: Galatia/Ancyra, Dalmatia, Arabia,
  Atropatene, Boihaemum, Pripet, Locus_Gepidae) is a rebel **village** in the
  game (no buildings). Taking it writes `village_block` into the new owner's block.
- **Moving towns/ports** (`mapedit.py`): repaint map_regions.tga (old pixel ->
  region colour, new -> black/white), delete `map.rwm` (game rebuilds it),
  characters on a moved town move with it, fleets within 2 tiles of a moved port
  sail to the sea next to the new one (`port_fleets`, `sea_spot`). Ports stand on a coastal land tile of
  their region (all 75 vanilla / 315 HLR ports). Plan has `binary()`/`delete()`.
- **A region** = map_regions colour area + town pixel (+ port), 8 lines in
  descr_regions (name, settlement, creator, rebels, r g b, resources, triumph,
  farming), region + settlement names appended to the campaign's
  descr_regions_and_settlement_name_lookup.txt, `{Name}` labels in
  `<campaign>_regions_and_settlement_names.txt`, optional settlement block; delete map.rwm.
  Not yet tested in game.
- The settlement `level` in descr_strat does not follow the buildings: the tool
  raises it to the core_building level's settlement_min (`buildings.sized`),
  population to POP_MIN; opts `sizes` {region: {level, population}} by hand.
- Every change the window keeps calls `remember()` first (snapshot of UNDO_KEYS);
  new kept state must be added to UNDO_KEYS. After a reload the map is read again
  (`_cmap_for = None`) - a stale map once refused to move a town back.
- After Apply the window reloads; in Edit it re-reads the faction (a stale town
  list once gave the user's towns away).
- Vanilla EDU gives ships by **culture** (`ownership roman, greek, ...`), so a
  faction's units = its name, its culture or `all` in ownership.

## Status (2026-09-28: v0.1.0 released: github.com/MasterOogwayHomebrew/RTW-faction-tool/releases/tag/v0.1.0)

Done and tested in game: new faction by template; separate mod folder; scan +
ignore list; garrisons and buildings by hand with pictures; tabs; Edit mode
(texts, colours, AI, denari, playable, take/give towns, capital, leader/heir);
Map M1 (view, political, click towns) and M2 (characters, drag own in Edit).
Moving towns/ports tested in game (roads and sea routes follow). New regions tested in game (HLR).
Version lives in gui.VERSION and CHANGELOG.md. A release = bump both, push main, then run the
`release.yml` workflow (workflow_dispatch, input version) - e.g. the GitHub MCP actions_run_trigger;
GitHub makes the tag, the exe and the release. Tags cannot be pushed from the session (403). Settlement level/
population, Check mod and Diplomacy tab built, not yet tested in game.
M3 (new armies/agents/fleets placed on the map) built and unit-tested, waiting for the user's in-game test.
Manifests in `docs/reference/`: vanilla game (without `bi`) and REX's own files
(`rex_manifest.json.gz`; 50 of them replace vanilla files).

**Warn the user once more if it comes up**: factions the user made before the
multi-line text fix (Saba, Galatia, Byzantium in HLR) may have cut the
template's building descriptions; Restore and recreate them.

## Done in 0.2.0 (the big patch; not yet tested in game)

Resources on the map (`resources.py`: read/apply, types from descr_sm_resources,
region tags = descr_regions line 6; one per tile, towns allowed - HLR keeps 749
slaves on town tiles; sea refused); tiles as above with the reason shown and the
nearest good tile; locked-character hint; buildings follow the settlement level
both ways (`level_picked`, `BuildingsEditor.set_level/core_for`); Map/Diplomacy
redrawn after reload; Save logs (zip) (`log.pack`: <game>/system.log.txt, newest
<game>/reports/*.txt without the nick); field list as a table under a split
(`FieldTable`), double click centres the map; agent signs per kind.
Medieval II: `strat.character_line` writes the file's dialect (M2: `Name, kind,
male|female[, leader|heir], age N, x X, y Y`; princess/witch female) - the likely
cause of the user's crash (captains were written in Rome's form); agent kinds from
descr_character.txt (`ModData.agent_kinds`, `start.KINDS` takes any agent type);
religions (`regions()[r]['religions']`, `regionedit.set_religions`, 9th line for new
regions from the donor; Religions... dialog). `newmod.GAME_EXES` knows M2EX/medieval2.
M2 facts from the user's files (maps only so far): `settlement castle` blocks with
core_castle_building; faction blocks have ai_label, denari_kings_purse; resources
section like Rome's; text in data/text/english. Still to check with his unpacked
.txt: descr_sm_factions format, names, EDU, a new faction by template, newmod
(mods live in <game>/mods/<name>, started by a .cfg).

Still open: the user wants nicer icons later (resources, agents); the M2 crash
must be re-tested with 0.2.0.

## Done in 0.3.0 (not yet tested in game)

Princess/witch names from 'women' (`strat.first_names`, FEMALE_KINDS); lowering the
level or core building pulls other buildings down (`BuildingsEditor.fit_down`,
`App._level_to`); Layers menu in MapView (v_pol, v_borders, ... ; Edit regions saves
and restores Political/Borders; political() takes borders and painted); work bar at
the top (`v_work`: new / edit / units / buildings; `App.editor()`, `work_changed`);
Unit/Building editors (`editors.py` data: unit_blocks, building_blocks, fields,
set_value, apply_fields, picture targets/needs, tga_bytes = uncompressed 32-bit
bottom-up TGA; `gui_editors.RecordEditor`); Plan.apply records new binary files as
'created' (Restore deletes them); template fills denari and colours in New mode.

## Collected for the next patch (the user asked to gather, not change yet)

- Map legend: a panel on the right side of the Map tab saying what every sign means
  (towns, ports, armies, fleets, each agent kind, resources by type, new towns/ports,
  colours); it can be hidden/shown, and that choice is remembered between starts
  (a small settings file next to the log / in %APPDATA%).
- Unit/building editors next steps: 3D models (descr_model_battle, .cas/.ms3d),
  textures, strat model, icons; new unit / new building (copy one, rename, all files);
  unit transfer between mods (the M2 GUI Toolkit has it); a real form per field type.
- The user's long-term idea: once the product is mature, show it to the Total War
  publishers.
- Faction art import (like units/buildings): load through the tool every picture that
  makes a faction and have it put in the right place, with the requirements shown up
  front (size, format - 32-bit TGA etc.). RTW: descr_sm_factions `symbol` (strat CAS
  model), `loading_logo` (loading_screen/symbols/symbol128_<f>.tga), `logo_index` /
  `small_logo_index` (sprites in ui/*.sd.xml - REX sprite packer), descr_banners
  standard/ally textures (models/textures/standard_<f>.tga), menu/symbols/FE_buttons_24
  and _48 (symbol24/48_<f>[_roll|_select|_grey].tga: vanilla 30x30 and 59x59, 32 bpp,
  uncompressed), ui/faction_icons, FE_flags. Take the requirements from the template's
  own files (same size and depth), convert PNG/JPG with Pillow, warn on a wrong size.
  Medieval II: check its own list on his unpacked files.

## Next

1. User's in-game test: existing armies/fleets/agents in the list (units, remove),
   garrison shown as it stands, empty-town warning; and M3 again after the crash fix (fleets: HLR marks every
   ship a mercenary; vanilla gives ships by culture).
2. Use the vanilla + REX manifests in Scan (game file / REX file / changed / mod
   file) and newmod. **Later** the user sends a game manifest with `bi` (his
   `bi` now has REX's overlay; subtract `rex_manifest`); no hurry.
3. Mod finder: remember the game folder and last mod (`%APPDATA%`), list mods.
4. Own unit/building roster per faction (ownership / EDB factions lists).
5. Run Check mod (deep) on other mods the user sends (only .txt + world/maps).
6. Later: appearance (banners, logos via REX sprite packer,
   recolour), unit/building editors, model viewer, map/region editor.
