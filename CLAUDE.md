# RTW Campaign Editor (formerly RTW Faction Tool) - notes for Claude

The package is still `faction_tool`, backups `faction_tool_backups`, the log `faction_tool.log`
(kept for compatibility); the window, exe and README say RTW Campaign Editor.

Read this first. It is the project's memory between sessions (and between Claude
accounts - the user hands this file to a new one): who the user is, how to work
with him, what the tool does, what was learned the hard way, and where the work
stands. Keep it up to date at the end of every piece of work.

**Files here now (2026-09-28)**: scratchpad `VAN/` = the user's RTW Gold data (root .txt,
text/, world/, ui/, banners/; no models/sounds); `M2/` = his Medieval II data (root .txt, world/, text/ with
.strings.bin + text/english/*.txt UTF-8 - the game reads the english .txt; tool reads them fine); `EXE/` = M2EX.exe and medieval2.exe (strings only; never commit).

**The user's game files live in the PRIVATE repo `MasterOogwayHomebrew/tw-game-data`** (never
make it public, never copy its files into this public repo): `M2/data` (Medieval II + M2EX vanilla:
root files, text/, world/maps/base + campaign) and `RTW/data` (RTW Gold + REX vanilla: root .txt,
text/, world/ without battle/custom maps, ui/, banners/). In a new session: add_repo it, `git clone
--depth 1` into /home/user/tw-game-data, copy what a test writes to the scratchpad first. Push in
batches of ~150 MB (the proxy refuses huge packs). Add new uploads there too (HLR next).

**A new session starts with no game files**: the container is fresh. Ask the user
to upload what the task needs (his HLR `data` as 7z volumes, vanilla `data`, REX),
or work from the repo and the synthetic tests only. Earlier sessions kept the files
under the scratchpad as `VAN/` (vanilla data + REX overlay), `HLR/`, `GAME/` (a
game folder with a New-mod-folder mod `Nabataea`), `VANCOPY/` (a copy to apply
and restore on) - recreate that layout when he uploads again. GUI checks: start
`Xvfb :57 -screen 0 1280x1024x24 &` and run with `DISPLAY=:57` (xvfb-run -a hung
once); patch `messagebox.show*/askyesno` in the script or a dialog blocks it.

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

**Two games: Rome: Total War (+ REX) and Medieval II: Total War.** The user counts M2TW as
a supported game now, not an extra: every feature and every new rule is thought through for
both (M2 differences so far: `mods/<name>/data`, text in `data/text/english`, character lines
with the sex, `settlement castle`, religions, agent kinds from descr_character; see "Done in
0.2.0"). What is checked only on Rome must be said so; the M2 parts still need his unpacked
.txt files for a full test.

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
| `log.py` | `faction_tool.log` in `RTW-Campaign-Editor-files/` next to the exe (0.7.2; older loose files moved in once; from source: the repo root): loads, previews, writes, restores, status lines, every error box and Tk callback traceback; **Log** button. Ask the user for it with system.log.txt |
| `mapedit.py` | moving towns and ports: `place_problem`, `apply_places` |
| `diplomacy.py`, `gui_diplomacy.py` | core_attitudes / faction_relationships: `read`, `set_relations` (only lines naming the faction), Diplomacy tab, map Diplomacy colours; opts `relations` |
| `check.py` | Check mod: file/consistency report; deep = `rehearse` every faction in memory (VAN 4 min) |
| `regionedit.py` | new regions / region borders: `region_problems`, `apply_regions`, `free_colour`; Map Regions mode (paint, right-click pick, Its town/port); opts `regions` {painted, new} |
| `roster.py`, `gui_roster.py` | what a faction has: `roster()`, `give_unit`/`take_unit` (EDU ownership + EDB recruit factions + cards), `set_level` (level `requires factions`), `apply(plan, faction, {'unit:<t>'|'building:<c>:<l>': give})`; Roster tab (Edit), opts `roster`, App.roster_set in UNDO_KEYS |
| `settings.py` | faction_tool_settings.json next to the log (same folder): map_legend, mod_data (last mod), game, campaigns {data: campaign}; `newmod.list_mods(game)` / `game_of(data)` fill the Mod list |
| `gamefix.py` | set-up problems that stop a game from starting (M2EX vegetation_source text), fixed on Load with a yes |
| `theme.py` | Light / Dark: one 'clam' ttk style + tk widgets recoloured (a `<Map>` binding on every widget; palette colours map both ways, meaning colours kept); settings `theme`; tabs styled (TNotebook.Tab) |
| `packs.py` | unit packs: `collect` / `export_pack` / `read_pack` / `plan_names` / `import_pack` (EDU block + descr_model_battle / descr_mount / descr_engines / descr_animals blocks + every file they name + cards + export_units texts + recruit places); Unit editor Export pack... / Import pack... |
| `cli.py` | `list towns names example new scan newmod slim manifest restore` |

Tests: `python -m unittest discover -s tests` (a synthetic mini-mod; 20+ tests,
restore byte-identical). GUI checks: `xvfb-run -a python3.12 script.py` with
`PIL.ImageGrab` screenshots (python3.12 has tkinter + Pillow here).

## How we work on the code (the user's standing request - keep to it every time)

"A change pulls along everything connected to it; no code bolted on top that later breaks the old."
Checked against common advice on keeping old code safe while changing it (write tests that pin the
current behaviour first, small steps, version control as the safety net, docs as the shared map -
e.g. logiciel.io "Refactoring Legacy Code Without Breaking Everything", miquido.com legacy
refactoring guide) and against Total War tool practice (vanilla files protected from accidental
edits, formats must survive read/write cycles - tw-modding.com, FeralInteractive/romeremastered docs).

1. **Before changing**: grep every caller and every file the thing touches; change the one shared
   place (a function in moddata / buildings / textio...), never a special case beside it. If two
   places compute the same fact, merge them first.
2. **A bug from the game = a test first**: reproduce it on the user's real files (tw-game-data) or a
   synthetic mini-mod, see it fail, fix, see it pass; then the whole suite. The rule it taught goes
   into "Hard-won rules" below with the game's own error text.
3. **Both games**: think every change through for Rome (+REX) and Medieval II; say what was checked
   on which.
4. **Files stay byte-exact** except the lines we mean to change; every write has a backup and
   Restore gives the original back byte for byte (tests check it). Never overwrite silently.
5. **Small steps, each committed**; the suite green before a push; after a push to main check the
   Actions run (0.6.0 once broke CI: a test needed Pillow the CI job lacks) before telling the user.
6. **Check it in the window** (Xvfb + screenshot) and on real files before saying it works; say
   plainly what was not tested (in game = only the user can).
7. **Plain words in the UI**: a label says what will happen; set-up fixes and anything that touches
   files the user does not know are offered with a yes, never done silently.
8. **Keep this file current** at the end of every piece of work: what changed, what was learned,
   what is open.

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
- **Game loads text** from `data/text/english/` and then `data/text/` (REX log: "Loading string
  table: data/text/english/..."); a table in english hides the data/text copy. `ModData.text_dirs /
  text_files / text_file(name)` give the copy the game reads (english first); every text edit goes
  there. Medieval II keeps its tables only in text/english. English only, by the user's choice.
  RTW Gold + REX (the user's vanilla, 2026-09-28): data/text/english/*.txt are **UTF-8 without a
  BOM** (REX's, dated with the REX install; "¬" = C2 AC), data/text/*.txt UTF-16 - textio detects
  UTF-8 by decoding (`_utf8`). REX loads the english copy, so edits in data/text were never seen.
  (Until 0.5.x the tool wrote data/text only: RTW new-region labels were not seen -> fatal
  "Couldn't find region name 'Test1' in stringtable".)
- **Governor's building = settlement level - 1** (fatal "The core building level should be one
  less than the settlement level!"): the core chain's 1st level is a town's, 2nd a large town's...,
  a village has none (`buildings.core_settlement / core_level_for`); settlement_min is only where a
  level may be built. A new region bigger than a village gets its core level written.
- **M2 castles: core_castle_building level = settlement level** (fatal "The castle core building level
  should be EQUAL the settlement level!", the user's M2_New, 0.7.4 raised Ajaccio motte_and_bailey
  village -> town): `buildings.core_offset` 0 for a chain named *castle*, 1 for core_building.
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
- **The bottom bar (Preview / Apply ...) and the status line are packed side=bottom before the
  notebook**; the notebook / editors are packed `after=self.bottom_bar`. Packed after the tabs, the
  buttons were pushed off the window when a tab was taller (the user lost Apply while filming, 0.6).
- Every change the window keeps calls `remember()` first (snapshot of UNDO_KEYS);
  new kept state must be added to UNDO_KEYS. After a reload the map is read again
  (`_cmap_for = None`) - a stale map once refused to move a town back.
- After Apply the window reloads; in Edit it re-reads the faction (a stale town
  list once gave the user's towns away).
- Vanilla EDU gives ships by **culture** (`ownership roman, greek, ...`), so a
  faction's units = its name, its culture or `all` in ownership.
- **Buildings are one chain for everyone; name, text, picture and model depend on
  who builds it.** export_buildings.txt: `{<level>}` plain, `{<level>_<culture>}` and
  `{<level>_<faction>}` (vanilla: roman, greek, egyptian, eastern, barbarian + carthage,
  parthia; HLR adds celtic, germanic, imazighen and many factions: dacia "Shrine to
  Hebeleysis", gauls "Shrine to Taranis", armenia "Shrine to Vahagan"...), same for
  `_desc`, `_desc_short`; the most specific wins (the user's point: the Roman temple of
  war is Bellona's, the Greek one Ares'). Pictures per culture:
  `ui/<culture>/buildings/#<culture>_<level>[_constructed].tga` with fallbacks through
  descr_ui_buildings.txt (`lookup_variants`); models per culture (descr_cultures,
  descr_building_battle, descr_settlement_plan). Temples of different gods are
  different chains (temple_of_battle, temple_of_leadership...), given by faction lists.
  The clone copies the template's faction-suffixed names (checked on HLR: dacia ->
  15 names). `editors.level_names` lists them in the Building editor.
- **Editor lines never go beyond what the mod already does** (the user's rule): a key may
  be added to a place only while that place has fewer lines of it than the most any
  unit / level of the mod has (`editors.line_limits`, `room_for`; vanilla: 2 officers,
  1 upgrade per level; HLR: 5 officers, 702 recruit lines in one capability). "If more
  is needed we'll do it then."
- **Keep what is tied together in step** (the user's standing request: "a change pulls along
  everything connected to it; no code bolted on top that does not know the old"). A unit is the
  faction's only when EDU ownership + an EDB recruit line (in a level it may build) + its cards
  agree (`roster.py`). Renames follow (`editors.rename_unit / rename_dictionary / rename_chain`:
  recruit lines, every campaign's descr_strat units / town buildings, descr_mercenaries,
  descr_rebel_factions, building_present requirements). Pending Roster picks change what the
  garrison and building pickers offer (`App._roster_units`, `BuildingsEditor.roster`).
- EDB parsing: `editors.chain_tree` (levels with head/open/close, capability, upgrades; braces
  closed on one line do not count). `factions {` must not match `building_factions {` (HLR uses it).
- Editor lines: adds are placed by `line_place` (capability / upgrades block made when missing),
  keyed by the block's first line (a rename keeps it); removal never of `required_keys` (keys every
  unit / level has) or structure lines; `check_text` refuses unknown units / chains / levels.

## Status (2026-09-29: v0.7.5 released (M2 castle core level crash; README report box); v0.7.4 released (Art map <= 40 % of the tab's height - it squeezed the picture list); v0.7.3 (Save logs zip -> RTW-Campaign-Editor-files/logs); v0.7.2 (log + settings in RTW-Campaign-Editor-files); v0.7.1 (the bottom buttons fix); v0.7.0 released - the first release since v0.1.2; github.com/MasterOogwayHomebrew/RTW-faction-tool/releases)

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

## Done in 0.4.0 (not yet tested in game)

Map legend (MapView._draw_legend on its own canvas, draws with the map's helpers;
shown/hidden kept in faction_tool_settings.json via settings.py); Art tab
(gui_art.ArtEditor; factionart.py: faction_pictures, replace_picture in the size and
depth of the picture replaced or the template's copy, select_background = per-pixel
middle value of the campaign's map_*.tga (>= 3 of one size), draw_select_map: regions
mask scaled NEAREST + blur 1, colour * (lum/mean)^0.5 - vanilla tints are hand-picked,
default_map_colour = primary's hue, s 0.35-0.6, v 0.82; opts art {rel: src},
select_map {colour, off}; drawn for new factions and edits that take/give towns);
clone._token_hit also matches _<faction>_ inside names; editors.copy_unit /
copy_building + copy_text_entries; RecordEditor "Copy as new...".

## Learned in the 0.4.1 run-through (keep)

- rebel_faction_descr.txt keys are rebel types ({Belgae} Belgae Rebels) and may share
  a faction's name: edit._texts never touches that file and writes the display name
  only when it changed.
- HLR keeps map_heights/map_ground_types/map_features... in its campaign folder and
  has no map_<faction>.tga select maps: select_background takes only real factions'.
- Never call f.texts() inside a loop over a big file (HLR tables): use entry_end_in /
  f.text(i). Deep Check on HLR now ~2 min, vanilla 26 s.
- Taking or giving towns redraws the other factions' select maps (colour_on_map from
  their own map, inside their old land).
- Restore of every kind of run checked byte-identical (diff -r against the original).
- Things tied to regions (keep them in step when regions change): map_regions.tga,
  descr_regions (+ religions in M2), the name lookup, region labels, map.rwm deleted,
  settlement blocks, descr_mercenaries pools (new region joins its donor's pool),
  campaign-select maps (factionart.future(plan) = the map as the plan leaves it;
  region_factions -> redraw_others(force)). Not tied: radar_map (terrain only).

## Done in 0.7.0 (2026-09-28; the user: "start the patch and release, test it yourself")

- **Unit packs** (packs.py, Unit editor buttons): tested on the user's RTW files (roman hastati +
  barb peasant briton into a copy: renamed "... 2", model shared when identical, 9 recruit lines,
  Restore byte-identical) and in the window (export, import dialog, write, the unit in the list);
  synthetic test with model / mount / .tga.dds texture / clash rename. Models / textures are only
  in the pack when the source mod has them (vanilla keeps them in the game's data - said in the
  export message). Faction and building packs: still to do.
- **M2 campaign-select map** refit (`factionart._fit_lit`: each vanilla faction's lit pixels against
  its start regions, IoU, scale per axis; frame now (sx, sy, dx, dy), settings `select_frames2`;
  M2 vanilla ~ (1.386, 1.40-1.41, -27/-28, 4-5)); solid fill + border lines kept + dark outline.
  The user saw the old one shifted right in the game.
- 18, 20, 21, 22 done (see below). Art picture Replace tested in the window: a 200x200 PNG became
  the 44x63 32-bit captain card and shows after Apply.
- README: Ko-fi button (ko-fi.com/img/githubbutton_sm.svg) + text; .github/FUNDING.yml `ko_fi: pfadfinder`.

## Asked by people (2026-09-28): does cloning update battle_models.modeldb? - NOT YET (M2)

Clone copies the template's `texture <faction>, ...` (+ model_flexi) lines in descr_model_battle.txt
(clone.texture_lines) - that is what Rome reads, and what M2EX reads with `model_battle_source text`
(the user's M2EX default). Vanilla M2 / M2EX with `modeldb` read data/unit_models/battle_models.modeldb
(a Boost text archive: counts and length-prefixed strings; per model a list of faction textures with
a count) - the clone does not touch it, so there the new faction's units would lack their texture
entries. To do: read/write modeldb (keep counts in step, byte-exact otherwise), copy the template's
faction texture entries for the new faction; the same for unit packs (M2 models live there). Need
the user's battle_models.modeldb (data/unit_models) to build and test on.

People also asked "I am guessing there is a scale function as well??" - unclear which scale: most
likely a model's `scale` line (descr_model_battle / modeldb, e.g. M2 `scale 1.12`, RTW `scale 1.0`,
optional, size of the soldiers). Now: no editor for it; a unit pack carries the model block with its
scale; the clone shares the template's models (scale unchanged). Idea: the Unit editor shows the
unit's model block(s) (soldier / officer / mount models) with scale and textures, editable, written
to descr_model_battle and (M2) modeldb. Asked the user which scale they mean.

**"Scale" = rescale the whole campaign map** (Melchon on Discord, 2026-09-28): "a map of 400x200 made
800x400 keeping the aspect, and everything scaled with it: towns, starting armies, trade goods, navies".
Not built. Plan (integer factor k first): map_regions.tga NEAREST x k but only ONE black town pixel and
ONE white port pixel per region (the rest of the kxk block = region colour; the port stays on a coastal
land tile), the 2x+1 maps (map_ground_types, map_heights (bilinear), map_climates, map_roughness,
map_fog...) resampled to 2(kW)+1, **map_features rivers kept 1 px wide and connected** (thin after
scaling), map_trade_routes, radar_map1/2 (2 px per tile), map_FE; every descr_strat x, y (characters,
resources, fortresses / watchtowers, `landmark`s) x k onto a tile the rules allow (land_problem /
sea for fleets); descr_sm_landmarks? descr_disasters? map.rwm deleted; check the engine's size limits
(RTW vanilla vs REX; M2 / M2EX) before offering it. Answered him that it is not there yet.

**Code signing** (the user, 2026-09-28: browsers / SmartScreen warn about the exe): needs a certificate
the user must get (identity checked): free for open source via **SignPath Foundation** (signpath.org, apply
with the repo; signs in GitHub Actions), or Azure Trusted Signing (~10 USD/month, identity validation),
or a paid OV certificate (SmartScreen still warns until reputation grows; EV removes it at once, costly).
Meanwhile: submit each release exe to Microsoft (microsoft.com/wdsi/filesubmission) as a false positive.
Once he has one, add the signing step to release.yml / build.yml. License: MIT already (LICENSE, README).

## TOP PRIORITY (the user, 2026-09-28, very keen): EXPORT / IMPORT packs

"The most important thing: EXPORT of a faction's units etc., so whole packs can go (between mods)."
A pack = one .zip (manifest.json + the files at their data-relative paths + the text pieces), made
from one mod and put into another with Preview + backup like every other change.
- Unit pack: the EDU block; its cards (ui/units, ui/unit_info per faction); export_units.txt
  entries (name, descr, descr_short); descr_model_battle entry + the models (.cas / .ms3d) and
  textures it names (incl. per-faction texture lines); mounts / animals / engines it names
  (descr_mount, descr_animal, descr_engines); EDB recruit lines (as "where it may be recruited",
  re-placed on import); sounds (voice type is a name - check it exists); M2: descr_model_battle
  is .modeldb-like and battle models need the mod's own paths.
- Faction pack: descr_sm_factions entry, names (descr_names + names.txt), all texts, its units
  (as above), building names/pictures per faction, art (faction_pictures), banners, strat model,
  traits/ancillaries triggers naming it, descr_strat block optional.
- Building pack: the chain (or a level) + texts + pictures + models per culture.
- Import: rename on clashes (editors.rename_* already drag names along), check culture / ownership /
  voice / mount exist in the target, report what is missing, never overwrite silently.
- Same game only (RTW<->RTW incl. HLR/REX, M2<->M2); say so.
The M2 GUI Toolkit has unit transfer - the model for the user's expectations.

## The user's 0.5.0 test (M2, vanilla, france) - fix all in one big patch, not one by one

The user tests first and collects; do these together when he says so.

1. **Units & armies, roster "Show"**: mercenaries only mix in (checkbox `v_merc` in
   `gui_garrison.py` adds them to the rest). Wanted: a simple filter - all / own units only /
   mercenaries only (+ general's units), next to the category box.
2. **Unit editor / Building editor lists** (`gui_editors.RecordEditor` left list): sort / filter
   by faction (owner), by type (category, class; building chain type), mercenaries apart
   (and agents - the character list too). Now it is one flat list in file order.
3. **Art tab: lots of empty space** (right of the map preview, right of the 2-column picture
   list). Use the width: bigger map preview, pictures in as many columns as fit (reflow on
   resize), or a details pane.
4. **Art tab, M2 campaign-select map is off**: the lit land is shifted/scaled (France lit over
   Italy-Alps side, north-west part missing). M2 map_<f>.tga is 384x275 with a wide decorated
   frame (RTW 384x237); `select_mask` stretches map_regions over the whole picture. Find the map
   area inside the frame (fit the template's own lit land against its regions, or detect the
   frame), then draw only there. Also the M2 select maps look different (parchment, borders
   drawn) - check the look against his original map_france.tga.
5. **Art tab labels**: many pictures are just "picture" (`factionart.label_of`). Name them all
   with where/what: menu/battlefield_pics -> "battle-select picture", fe_faction_units ->
   "units picture on the faction screen", fe_symbols_80 -> "symbol on the faction screen",
   ui/faction_symbols -> "faction symbol (in-game panels)", campaign vc_<f>.tga -> "victory
   conditions map", and a line on where the game shows it, like the named ones have.

6. **Tabs barely visible** (the ttk Notebook tab row Faction / Units & armies / ... under the work
   bar): make them stand out (style: bigger font, padding, selected tab coloured like the work bar).
7. **M2: faction texts empty** (Name full/short, Adjective, Tooltip, Description on the Faction
   tab for france). `ModData.text_files` reads only `data/text/*.txt`; M2 keeps text in
   `data/text/*.strings.bin` (binary, UTF-16) and the .txt only when unpacked (and maybe
   `text/english`?). Ask the user what lies in his M2 `data/text`. Plan: read .strings.bin
   (header, count, then key/value UTF-16 with lengths), write the .txt and delete / rewrite the
   .strings.bin (the game rebuilds the bin from the .txt when the bin is missing - check). M2 keys:
   expanded.txt {FRANCE}, campaign_descriptions `{IMPERIAL_CAMPAIGN_FRANCE_...}` - check on his files.
   Everything text-related (names pool strings, units, buildings) needs the same.
8. **"Real" map, strictly by tiles for editing** (the user confirmed it is wanted: tile grid when
   zoomed in, every tile its own square, what is edited = exactly one tile). **"Real" map** (the user asks if the map can be drawn strictly by tiles): it already is (1 square
   = 1 tile, colour by map_ground_types). Offer: relief shading from map_heights, rivers from
   map_features, climate tint (map_climates), a closer-to-the-game look; ask what he misses.
9. **New region dialog, "Resources" field** confuses: it is descr_regions line 6 = region tags /
   hidden resources (EDB `hidden_resource` / `resource` requirements, HLR local units; M2: america,
   crusade, jihad, *_chapter_house...), NOT the map resources (descr_strat `resource` lines, drawn on
   the map). Rename to "Region tags (hidden resources)", explain, list only the tags used in
   descr_regions / EDB, not the map resource types.
10. **New town and port not shown after the New region dialog** outside Regions mode: pending new
    towns/ports and painted tiles (`MapView._painted`, `region_points`) are drawn only while
    `region_mode`. Draw them (and the new region's land) on the normal map too until Apply.

11. **Map colours** (political layer): denser - not bright, but clearly visible.
12. **Apply per session?** The user asked whether he has to Apply per window. In Edit faction one
    Apply writes every tab at once (he applied twice because the first warned "no army"). But the
    pending changes belong to one faction and one editor: switching faction / Unit editor loses
    them. Idea: keep a session list of changes across factions and editors, one Apply.
13. **M2 crash at start - FOUND (not ours)**: M2EX's data/descr_caps_ex.txt has
    `vegetation_source  text` (M2EX strings: text = parse descr_vegetation.txt at runtime, needs
    export/new_vegetation/raw_distribution_maps; binary = vegetation.db, "default for mods"). Fix for
    the user: `vegetation_source  binary`. Check mod could warn about it (text source + no raw maps).
    Old notes: (M2EX, vanilla data edited in place, 2026-09-28): system.log ends 8 s
    after start at "Loading vegetation from text: descr_vegetation.txt ... raw_distribution_maps/
    area_a could not be found ... Failed to load text vegetation database" -> close_game; no
    campaign loaded, nothing about our files. The tool never touches vegetation. Asked the user
    whether M2 starts after Restore at all (unpacked data may make the game read the text
    vegetation - then descr_vegetation.txt must go). Pending his answer.

14. **New mod folder: "a heap of files"** - the user did not know what a hard link is and was
    surprised by 29666 files in RTW_New/data. Say it in the dialog and the done message in plain
    words: the files show full size in Explorer but take no disk space (35 MB really copied);
    deleting the mod folder never touches the game; only an editor that overwrites a linked file in
    place changes the original (the tool itself never does). Mod on the plain game made fine (full
    link copy, loads: 21 factions, 2 campaigns).

15. **Dark theme** for the window (the user asked): a Light / Dark switch kept in settings.py;
    ttk style + tk widgets (Listbox, Text, Canvas backgrounds), map legend, pictures' frames.

16. **Mods folder**: M2 mods live in <game>/mods/<name> (+ a .cfg to start); `newmod.create_mod`
    still makes <game>/<name> for M2 too - make it mods/<name> with a .cfg (M2EX: check how it
    starts a mod, the user's M2EX.exe is in scratchpad EXE/). Rome/REX: mods sit in the game root
    (HLR, RTW_New) and start with -mod:<name>; keep that.

17. **M2 first start: unpack + two DLLs by the tool** (the user: "people don't want to dig in
    files they don't know"): when a vanilla M2 is loaded and nothing is unpacked (no data/*.txt,
    only packs/), offer (with a yes) to run the unpacker and move the two DLL files the unpack
    needs. **Ask the user which two DLLs and from where to where** (not known yet). Every such
    set-up fix goes through `gamefix.py` (problems / fix_plan; asked on Load, a no remembered in
    settings `fixes_declined`; backup + Restore).

20. **A new region given to a faction is not in its town list until Apply** (the user: then two Applies,
    two backups needed; wanted: seen at once, live). The New region dialog's owner should add the new
    town to the faction's chosen towns (Faction tab list, Units & armies, Buildings, Map) as pending,
    so garrison / buildings / capital can be set before one Apply; the plan writes the region and the
    settlement together. Not started - the user said "not yet".

21. **New region dialog: "Built by" and "Rebels there" prefilled from the donor region** - the region the
    new one's land is painted out of (the one under its town, or most of its tiles): its descr_regions
    creator (line 3) and rebels (line 4), like tags / farming / religions already come from the donor.
    Still changeable. Not started - "remember for now".

22. **Religions of a new region (M2)**: the Religions... dialog for a new region opens with all 0 (in all 0%),
    though the write already copies the donor's line (log: "Test1: religions { ... islam 99 ... heretic 1 }").
    Prefill the dialog with the donor's religions, and never let a region be written without a line summing
    to 100 (skipped dialog, zeros, a donor without religions -> the donor's, else the campaign's most common)
    - a missing / broken religions line may crash M2. Not started - for the big patch.

19. **Map "strictly by tiles" = the picture itself, not the grid** (the user, with a screenshot): each tile
    one colour (the ground type at its middle, what the tool checks), relief and rivers worked out per
    tile too, then blown up NEAREST (`CampaignMap.background(tiles=True)`; checked: 0 tiles with two
    colours on M2). Default now; the detailed 2x+1 picture is the other choice in Layers (settings
    `map_look.ground` = "tiles" | "detailed"; 0.6.0's "tiles" flag is no longer read). Done.

18. **"Preview map changes / Apply map changes"** puzzled the user: it is New faction mode with no
    template/name yet (`App.map_only`), where only map edits can be written. Make it plain: normal
    "Preview / Apply changes" with a hint "no faction chosen - only the map's changes are written",
    and greyed out while nothing waits (user's note, not asked to fix yet).

**Done in 0.6.0 (2026-09-28, the user said "do it")**: 1 (garrison "own units / mercenaries / own +
mercenaries"; FieldTable Show by kind + sort by heading, rows keep their index as iid), 2
(`editors.block_facets` / `chain_group`; RecordEditor Show + Sort), 3 + 5 (`gui_art`: map up to 2x, cards
reflow; `factionart.PICTURE_KINDS`, `where_shown`), 6 + 15 (theme.py), 8 (`CampaignMap.background(tiles,
relief, rivers)`, grid at z >= 10; settings `map_look`), 9 (Region tags (hidden resources), `App._region_tag_names`
= descr_regions line 6 + EDB resource/hidden_resource), 10 (`new_land` + region_points outside Regions mode), 11
(political alpha 205), 12 (pending_parts / _write: editors first, then the faction; RecordEditor.rebind keeps
changes while its file's md5 is unchanged; Edit faction switch asks apply/drop/stay; `_baseline` =
`_faction_state()`), 14 (dialog + done message), 16 (`newmod.mod_target`, `is_medieval2`, `_m2_start`: .cfg
`[features] mod = mods/<name>` + bat `start "" <exe> @mods\<name>\<name>.cfg`; M2EX.exe strings confirm .cfg
and mods/<folder>, the @cfg start is the standard M2 one - to be checked by the user). 17 done after: `gamefix.unpack_needed / unpack`
(msvcp71.dll + msvcr71.dll - medieval2.exe imports both, so they sit in the game folder - copied next to
tools/unpacker/unpacker.exe, then `cmd /c unpack_all.bat` with newlines on stdin for its pause; offered
from App.load when ModData fails on a folder with packs/; the real unpack_all.bat not seen yet). Not tested in game yet.

Fixed already (on the session branch, 2026-09-28): 13 (gamefix.py: on Load the tool offers to set
`vegetation_source binary` itself, with the user's yes; tested in the window on his M2 files),
M2 faction-screen texts ({F_STRENGTH}, {F_WEAKNESS}, {F_UNIT} -> edit.EXTRA_TEXTS, Faction tab rows
shown only when the faction has them; M2 has no {F_DESCR} tooltip and no short name), 4 (M2 select map: `factionart.select_frame`
fits where the map lies - scale 1.314, dx -16, dy 12 on vanilla M2; same shape as the map = the
Rome stretch; kept in settings `select_frames`), 7 (text/english), the RTW new-region crash
(labels) and the core-building crash (see the rules above).

## Collected for the next patch (the user asked to gather, not change yet)

- Unit texture recolour (the user wants it, and the Discord REX people asked for model work): give a unit to
  another faction without Blender - descr_model_battle `texture <faction>, <path>` lines per faction; copy
  the template faction's texture, shift its faction-colour pixels (hue range picked on a preview) to the new
  faction's colours, write it next to it (same size/format; RTW textures are often .tga.dds - check on his
  files), add the `texture` line (+ BI/REX variants). Later: a model viewer (.cas).
- **RTW strat-map flags** (the user sent data/banners, 2026-09-28): banners/symbols1..8.tga.dds =
  DXT 128x128 RGBA atlases, each 2x2 symbols of 64x64 (32 slots, 28 used in his vanilla: laurel,
  dagger, lambda, ankh, crown ... elephant; the last 4 slots of symbols7/8 hold duplicates / empty);
  strat_flag.CAS + strat_flag.tga.dds (the flag cloth), navy_banner.CAS + navy_julii.tga.dds.
  Guess to check: a faction's slot follows its order in descr_sm_factions (4 per atlas) - a new
  faction needs its symbol drawn into the next free slot (REX: more factions -> more atlases?).
  Faction art should list "strat-map flag symbol (slot N of symbolsK)" with a Replace that writes
  the 64x64 quadrant back as DXT (Pillow reads DDS; writing DXT needs an encoder - check).
  Also descr_sm_factions `symbol models_strat/symbol_<f>.CAS` (3D strat symbol) and descr_model_strat
  per-faction `texture <faction>, data/models_strat/textures/navy_<f>.tga` (fleets).
- Unit/building editors next steps: 3D models (descr_model_battle, .cas/.ms3d),
  textures, strat model, icons; unit transfer between mods (the M2 GUI Toolkit has it); a real form per field type.
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
  The user: a full faction has MANY pictures - from buttons to the campaign-select
  map that lights up the faction's lands (vanilla campaign folder map_<f>.tga,
  384x237 24-bit; also leader_pic_<f>.tga, description_<f>.txt there). The clone
  already copies every picture named after the template (clone.art_files: ui, menu,
  loading_screen, campaign folder). Plan: a "Faction art" panel listing EVERY file
  of the faction (same search), with thumbnail, size/format needed and Replace...;
  and map_<f>.tga made by the tool from its start regions (the template's map as the
  background, the faction's land tinted in its colour, map_regions scaled to it).

## Done in 0.5.0 (not yet tested in game)

Mod remembered + Mod list (settings.py, newmod.list_mods / game_of); Roster tab (roster.py,
gui_roster.py); editors: Add line... / x remove / Tied to it / renames drag along / checks;
Scan tells files apart by manifests (scan.Origins: this PC's <game>/rtw_manifest.json.gz, else the
bundled RTW Gold or M2 manifest, + REX; md5 only when the size matches, cached); the manifests go
into the exe (build.yml / release.yml `--add-data "docs/reference/*.json.gz;reference"`,
scan.reference_dir). faction_tool_settings.json is no longer tracked (.gitignore).

Found, not fixed yet: a mod made by New mod folder on the **plain game** is slimmed (only changed
files), and the tool cannot load its campaign (descr_regions etc. are in the game's data):
ModData would need the game's data as a fallback, with edits of fallback files written into the
mod folder. Mods built on HLR are full copies and are fine.

## Next big step: a culture of its own (the user asked; not started)

Buildings, settlements and many sounds follow the **culture**, so a faction that should
look its own needs its own culture. HLR added four (celtic, germanic, imazighen, nomadic)
over vanilla's seven (REX lifts the limit); `celtic` appears in these HLR files - the
list of what a new culture touches (clone one like a faction):
descr_cultures.txt (settlement models per level, fort, portrait_mapping,
rebel_standard_index), ui/<culture>/ (buildings pictures, cities cards, ...),
descr_settlement_plan, descr_building_battle, descr_ui_buildings (lookup_variants),
descr_sm_factions (`culture`), export_descr_unit (ownership by culture),
export_descr_buildings (factions lists naming cultures), export_descr_character_traits,
export_descr_ancillaries, descr_banners, descr_offmap_models, descr_strat /
descr_mercenaries mentions, the sound files (descr_sounds_music, _units_confirm,
_units_ambient, _units_anims, export_descr_sounds_soldier_voice, _stratmap_voice,
_units_voice, _units_battle_events, _prebattle) and the `_<culture>` building names in
text/export_buildings.txt. Check first on his files whether REX or the exe caps the
number of cultures, and how portrait_mapping / rebel_standard_index work.

## Next

1. User's in-game test: existing armies/fleets/agents in the list (units, remove),
   garrison shown as it stands, empty-town warning; and M3 again after the crash fix (fleets: HLR marks every
   ship a mercenary; vanilla gives ships by culture).
2. Use the vanilla + REX manifests in Scan (game file / REX file / changed / mod
   file) and newmod. **Later** the user sends a game manifest with `bi` (his
   `bi` now has REX's overlay; subtract `rex_manifest`); no hurry.
3. (done in 0.5.0: mod finder, roster) - the user tests Roster and Add line in the game.
4. Slimmed plain-game mods: load them with the game's data as a fallback (see 0.5.0 notes).
5. Run Check mod (deep) on other mods the user sends (only .txt + world/maps).
6. Later: appearance (banners, logos via REX sprite packer,
   recolour), unit/building editors, model viewer, map/region editor.
