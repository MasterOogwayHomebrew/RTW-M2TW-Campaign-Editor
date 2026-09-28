# RTW Campaign Editor (formerly RTW Faction Tool) - notes for Claude

The package is still `faction_tool`, backups `faction_tool_backups`, the log `faction_tool.log`
(kept for compatibility); the window, exe and README say RTW Campaign Editor.

Read this first. It is the project's memory between sessions (and between Claude
accounts - the user hands this file to a new one): who the user is, how to work
with him, what the tool does, what was learned the hard way, and where the work
stands. Keep it up to date at the end of every piece of work.

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
| `log.py` | `faction_tool.log` next to the exe: loads, previews, writes, restores, status lines, every error box and Tk callback traceback; **Log** button. Ask the user for it with system.log.txt |
| `mapedit.py` | moving towns and ports: `place_problem`, `apply_places` |
| `diplomacy.py`, `gui_diplomacy.py` | core_attitudes / faction_relationships: `read`, `set_relations` (only lines naming the faction), Diplomacy tab, map Diplomacy colours; opts `relations` |
| `check.py` | Check mod: file/consistency report; deep = `rehearse` every faction in memory (VAN 4 min) |
| `regionedit.py` | new regions / region borders: `region_problems`, `apply_regions`, `free_colour`; Map Regions mode (paint, right-click pick, Its town/port); opts `regions` {painted, new} |
| `roster.py`, `gui_roster.py` | what a faction has: `roster()`, `give_unit`/`take_unit` (EDU ownership + EDB recruit factions + cards), `set_level` (level `requires factions`), `apply(plan, faction, {'unit:<t>'|'building:<c>:<l>': give})`; Roster tab (Edit), opts `roster`, App.roster_set in UNDO_KEYS |
| `settings.py` | faction_tool_settings.json next to the log: map_legend, mod_data (last mod), game, campaigns {data: campaign}; `newmod.list_mods(game)` / `game_of(data)` fill the Mod list |
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

## Status (2026-09-28: v0.5.0 in the works; v0.1.0 released: github.com/MasterOogwayHomebrew/RTW-faction-tool/releases/tag/v0.1.0)

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

## Collected for the next patch (the user asked to gather, not change yet)

- Unit texture recolour (the user wants it, and the Discord REX people asked for model work): give a unit to
  another faction without Blender - descr_model_battle `texture <faction>, <path>` lines per faction; copy
  the template faction's texture, shift its faction-colour pixels (hue range picked on a preview) to the new
  faction's colours, write it next to it (same size/format; RTW textures are often .tga.dds - check on his
  files), add the `texture` line (+ BI/REX variants). Later: a model viewer (.cas).
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
