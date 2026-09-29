# RTW & M2TW Campaign Editor (formerly RTW Campaign Editor, RTW Faction Tool) - notes for Claude

The package is still `faction_tool`, backups `faction_tool_backups`, the log `faction_tool.log`
(kept for compatibility); the window, exe and README say RTW & M2TW Campaign Editor (0.9.2; exe
`RTW-M2TW-Campaign-Editor.exe`, folder `RTW-M2TW-Campaign-Editor-files` - the old folder is renamed on start).

Read this first. It is the project's memory between sessions (and between Claude
accounts - the user hands this file to a new one): who the user is, how to work
with him, what the tool does, what was learned the hard way, and where the work
stands. Keep it up to date at the end of every piece of work.

**Files in a session**: a fresh container has none. The user's vanilla files are in the private repos
`RTW-game-data` / `M2TW-game-data` (below); `EXE/` (M2EX.exe, medieval2.exe - strings only, never commit) was only in the
2026-09-28 session's scratchpad. The user's M2 upload has **no `ui/` folder** (portrait pools, custom_portraits
untested on M2) - ask for `ui/<culture>/portraits` + `ui/custom_portraits` when M2 pictures matter.

**The user's game files live in TWO PRIVATE repos, one per game** (split 2026-09-29 at the user's wish; never make
them public, never copy their files into this public repo; the old `tw-game-data` was renamed to RTW-game-data):
- **`MasterOogwayHomebrew/RTW-game-data`** - Rome: `RTW/data` (RTW Gold + REX vanilla: root .txt, text/, world/
  without battle/custom maps, ui/, banners/, models/textures, loading_screen), `RTW/bi/data` (BI root .txt + text/),
  `REX/` (REX's descr_ex / descr_caps_ex, documentation/ = dump_docudemon), `HLR/data` (text/, enhanced_tweaks/,
  imperial_campaign without map.rwm).
- **`MasterOogwayHomebrew/M2TW-game-data`** - Medieval II: `data/` (M2TW + M2EX vanilla: root files, text/,
  world/maps/base + campaign, ui/ parts, loading_screen/, models/, unit_models/ with battle_models.modeldb and
  _units (3336 .mesh / .texture), editor/, tools/).
In a new session: add_repo both, `git clone --depth 1` into /home/user/rtw-game-data and /home/user/m2tw-game-data,
copy what a test writes to the scratchpad first. Push in batches of ~250 MB raw (the proxy refuses huge packs).
Older notes below say "tw-game-data M2/data" = M2TW-game-data data/, "tw-game-data RTW|REX|HLR" = RTW-game-data.
Add new uploads to the repo of their game.

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
  briefly and directly, and verify before claiming. Call Medieval II **M2TW** in full, not "M2"
  (the user, 2026-09-29) - in answers, repo names, commits and new notes. Repo texts (code, comments,
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
| `log.py` | `faction_tool.log` in `RTW-M2TW-Campaign-Editor-files/logs/` next to the exe with the Save-logs zips (the user asked, 2026-09-29; `log.home()` = the tool's folder with the settings, `logs_dir()`, an older log moved in once; from source: <repo>/logs, gitignored): loads, previews, writes, restores, status lines, every error box and Tk callback traceback; **Log** button. Ask the user for it with system.log.txt |
| `mapedit.py` | moving towns and ports: `place_problem`, `apply_places` |
| `diplomacy.py`, `gui_diplomacy.py` | core_attitudes / faction_relationships: `read`, `set_relations` (only lines naming the faction), Diplomacy tab, map Diplomacy colours; opts `relations` |
| `check.py` | Check mod: file/consistency report; deep = `rehearse` every faction in memory (VAN 4 min) |
| `regionedit.py` | new regions / region borders: `region_problems`, `apply_regions`, `free_colour`; Map Regions mode (paint, right-click pick, Its town/port); opts `regions` {painted, new} |
| `roster.py`, `gui_roster.py` | what a faction has: `roster()`, `give_unit`/`take_unit` (EDU ownership + EDB recruit factions + cards), `set_level` (level `requires factions`), `apply(plan, faction, {'unit:<t>'|'building:<c>:<l>': give})`; Roster tab (Edit), opts `roster`, App.roster_set in UNDO_KEYS |
| `settings.py` | faction_tool_settings.json next to the log (same folder): map_legend, mod_data (last mod), game, campaigns {data: campaign}; `newmod.list_mods(game)` / `game_of(data)` fill the Mod list |
| `gamefix.py` | set-up problems that stop a game from starting (M2EX vegetation_source text), fixed on Load with a yes |
| `theme.py` | Light / Dark: one 'clam' ttk style + tk widgets recoloured (a `<Map>` binding on every widget; palette colours map both ways, meaning colours kept); settings `theme`; tabs styled (TNotebook.Tab) |
| `packs.py` | unit packs: `collect` / `export_pack` / `read_pack` / `plan_names` / `import_pack` (EDU block + descr_model_battle / descr_mount / descr_engines / descr_animals blocks + every file they name + cards + export_units texts + recruit places); Unit editor Export pack... / Import pack... |
| `family.py`, `gui_family.py` | people and the family tree: `read(f, faction)` (Person: key `map:<name>#n` / `record:<name>#n`, traits, ancillaries, sex, age; tree [[father, wife, [kids]]]), `apply(plan, f, faction, opts family)` (people changes, new records in the file's own form, remove records, tree -> `relative` lines after the records, unchanged lines kept byte-exact), `tree_problems`, `rename_in_tree` (also used by edit._people), `trait_list` / `ancillary_list`; Family tab (Edit), App.family_set in UNDO_KEYS |
| `portraits.py` | the portrait library: `cultures`, `library(mod, culture)` (groups, young/old/dead, cards, mod over game), `sizes`, `add(plan, culture, group, pics)`; window gui_family.PortraitLibrary (Character editor, pending in FamilyEditor.lib_adds) |
| `cli.py` | `list towns names example new scan newmod slim manifest restore` |

Tests: `python -m unittest discover -s tests` (a synthetic mini-mod; 20+ tests,
restore byte-identical). GUI checks: `xvfb-run -a python3.12 script.py` with
`PIL.ImageGrab` screenshots (python3.12 has tkinter + Pillow here).

## The aim: user-friendly (the user, 2026-09-29 - weigh every feature against it)

The user wants modding made friendly for everyone, not only for people who know the game's files by heart:
one works with factions, towns, armies and the map, and the tool finds the files, lines and formats. So:
no digging in files (pictures converted and placed, tied things kept in step); preview before anything is
written; nothing lost (backup + byte-exact Restore, Undo/Redo); mistakes the game would crash on refused or
warned about in plain words; set-up fixes only with a yes. Something confusing or hard to find counts as a
bug. Said on the wiki's Home page ("Made to be easy", docs/wiki/Home.md).

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
8. **Keep ROADMAP.md current** (public, English; the user shares it on GitHub and Discord): coloured emoji, never
   `- [x]` / `- [ ]` (GitHub draws those as grey disabled boxes - the user asked for colour, 2026-09-29): 📦 released,
   ✅ released + confirmed in the game (with *(in-game ✓ ...)*), 🧪 being tested, 🔜 next, 💡 later; move items between
   the sections as they go.
9. **Keep this file current** at the end of every piece of work: what changed, what was learned,
   what is open.

10. **REX first (the user's standing rule, 2026-09-29)**: for every new feature, look first at what REX can do and
   build on it where it helps - its settings (descr_ex.txt, descr_caps_ex.txt), xml sprites (sprite_format xml),
   Squirrel / Lua scripts (script/modules/*.nut, EOP-Lua), console commands (rename_settlement, rename_region,
   rename_faction, ...), lifted limits. Check REX's own docs (`dump_docudemon` output, REX.exe strings, its script/
   folder) before guessing. Vanilla Rome and Medieval II keep working (say plainly what needs REX), unless the user
   says to drop them.

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
- **Character names are unique within a faction** (characters + character_record, as written): REX "descr_strat.txt,
  at line N: duplicated character name in this faction, skipping" (world.cpp(987)) - the user's nabataea lost an army
  named like its leader and a spy named like an automatic captain. strat.faction_names / duplicate_names /
  check_names (build.validate and edit refuse a new duplicate); captains skip taken names; the New army dialog
  refuses one (App._faction_names). Vanilla RTW / M2 have none.
- **Rivers** (the user, in game): the game follows a river side to side from where it joins another river (also the
  sea / map edge / a source - the tool counts those) and stops at a corner-only step; everything past it is not drawn.
  terrain.river_warnings = pieces (4-connected river/ford/source) joined to nothing; terrain.river_path = the
  1-tile brush's staircase (gui_terrain.paint, _last_river). 0 such pieces on vanilla RTW / M2 maps.
- **Faction limit** = limits.py: original exes 21 (Rome) / 31 (M2); REX / M2EX read `max_factions` in
  data/descr_ex.txt (the mod's, else the game's; REX ships 21, M2EX 31; the user's REX: 22 factions ran with 31).
  Over it: "Too many factions described here, maximum is(21)" -> closes at start. build -> limits.check raises
  LimitError (can_raise when REX.exe / M2EX.exe is beside the data); App._faction_plan asks and sets
  opts raise_faction_limit (once per mod, App._limit_raise); no exe found = warning only. Regions: REX has no
  setting (HLR > 300 regions run); original-exe region limits unknown - not built.
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
- **Family tree** (descr_strat): `relative Father, Wife, Kid, ..., end` per couple, after the `character_record`
  lines, which come after every `character`; every name on it is a character or record of the faction, so a
  rename must follow on the relative lines (0.8.0: edit._people now does, via family.rename_in_tree). Rome records
  carry `command 0, influence 0, management 0, subterfuge 0`, M2 records not; new ones copy a record of the file.
  Traits: `traits T n , U m` (n = level 1..number of `Level` lines), `ancillaries a, b`; trait kinds from the
  trait's `Characters` line (family / spy / princess ...). Checked on vanilla julii and england (write + Restore
  byte-exact); not yet in game. Open: portraits on the cards, dead people (M2 `dead_until_resurrected` is a
  faction line, not a person), a wife for a man on the map written as a record (vanilla does the same).
- **Terrain** (both games' vanilla checked): map_ground_types.tga is 2W+1 x 2H+1, a tile = the 3x3 block around
  (2x+1, 2y+1); colours in terrain.GROUND (M2 adds 64 64 64 impassable land, 128 128 128 impassable sea).
  map_features.tga is W x H: 0 0 255 river, 0 255 255 ford, 255 255 255 source, 255 255 0 cliff, 255 0 0 volcano,
  0 255 0 M2 land bridge. map_heights.tga 2W+1 grey, sea (0 0 253). Ground type and height are separate: a
  mountain tile does not raise the land (next: heights brush keeping mountains/hills high). Map rebuilt by the game
  when map.rwm is deleted. **New map from scratch: YES** (the user, 2026-09-29): create a campaign map of one's
  own (all map_*.tga, descr_regions, descr_strat with one region + one faction, texts, win conditions, loads in the
  game) as well as editing an existing one. WAIT: he tests 0.10.0's Terrain editor in the game first.
- **Portrait pools keep numbers in step** (checked on vanilla RTW): generals young/N, old/N, dead/N and cards
  young|old|dead/N are the same man, every folder of a group has the same count (roman 479, greek 188, barbarian
  151 - barbarian writes Young/Old/Dead); civilians/rogues have young/old + cards only. portraits.add writes the
  next number into all of them in the existing folder case (mod folder; REX portrait_pool merged pools mod+game).
- **Portraits**: Rome - no portrait of one's own in descr_strat (as far as the files show); the game rolls one of
  ui/<portrait_mapping>/portraits/portraits/young|old|dead/<generals|civilians|rogues>/NNN.tga (69x96, cards
  44x63 under portraits/cards/ with the same numbers), off-map family ui/<c>/portraits/family/wife|son|daughter.tga
  (only eastern/egyptian/roman in vanilla). Medieval II (medieval2.exe / M2EX strings): `, portrait <folder>` on the
  character line -> data/ui/custom_portraits/<folder>/portrait_young|old|dead.tga (norman_prologue uses it); pool
  ui/%s/portraits/portraits/young|old/%s[_%s]/%03d.tga. family.portraits / set_portraits; the user's M2 upload has no
  ui/ folder, so M2 pools are untested; ask for ui/<culture>/portraits + ui/custom_portraits.
- **Pictures named by path** (descr_banners `standard/rebels/routing/ally_texture`, descr_sm_factions
  `loading_logo`; clone.PICTURE_LINKS, `picture_links`): a copied faction block keeps the template's paths, so
  a replaced picture would change the template's too (found 2026-09-29, the user's Epirus-from-Macedon question).
  `clone.own_pictures` gives the new faction copies named after it (`own_picture_ref`: standard_macedonia ->
  standard_epirus) when only the template names the file; shared ones (rebels, routing) stay shared until the Art
  tab's Replace, which writes an own copy (`<name>_<faction>`) and repoints only that faction's line
  (`factionart.write_art`, pick {'src', 'link', 'exact'}). Rome keeps `x.tga` as `x.tga.dds` (DXT5 + mipmaps):
  `image_dds` writes the replaced one's format and mip count (Pillow >= 11 encodes DXT). **Back to the original**
  = `factionart.original_picture` (oldest backup's copy, or manifest `copied_from` for a file the tool made).
  Checked on vanilla RTW (macedon -> epirus, stand-in textures: the upload has no models/ or loading_screen/).
- **Faction limit: plain Rome (the game's own data, imperial_campaign) = 21 factions with slave** - REX
  (build Sep 27 2026) on vanilla RTW + a 22nd faction (nabataea from egypt, 2026-09-29): fatal
  "faction_db.cpp(564) Too many factions described here, maximum is(21). The rest will be ignored", then
  "Invalid ownership type 'slave' found in unit 'barb peasant slave'" (slave, the 22nd, was dropped) -> the
  game closes at start. Vanilla RTW already has 21, so there is NO room for a new faction on plain Rome.
  HLR has 31 factions with slave (the user, 2026-09-29) - whether a 32nd runs depends on HLR's own max_factions. build.validate warned only above 31 ("Classic RTW stops at 31;
  REX lifts the faction limit") - WRONG for plain RTW. To do (next patch): the limit per game (plain RTW 21;
  BI / Alexander / BI-based mods 31 - check how REX decides, and whether it can be raised), refused in
  Preview with plain words before anything is written, and the New faction tab should say up front
  "this campaign is full (21 of 21)". The user's fix for his video: Restore the nabataea backup, make the
  faction on HLR (or a New mod folder built on it).
  The user objected "but REX is there": REX's README says only "Removed every single major engine limit like
  factions, regions, religions, cultures etc." - yet his REX log on plain RTW says maximum 21. REX's own files
  (docs/reference/rex_manifest) hold no config for it; REX's data/descr_sm_factions.txt has no directive.
  Guess (unchecked): the lifted limit comes with REX's descr_sm_factions.json (HLR has one, vanilla has none)
  or with the BI-format game. To settle: HLR's descr_sm_factions.json + ask REX's Discord / README docs.
  He then sent a descr_sm_factions.json (2026-09-29): NOT HLR's - it is the Rome Remastered format ("factions":
  {name: {string, description, culture, ethnicity, tags, namelists{men,women,surnames}, logos{loading screen icon,
  standard index, rebel standard index, logo index, rebel logo index, strat symbol model, strat rebel symbol
  model}, colours{primary, secondary, family tree{...}}, movies{intro, victory, defeat}, available in custom
  battles, prefer naval invasions, default battle ai personality, allow reproduction}}) with 24 factions: the 20
  vanilla + baktria, epirus, bosporan_kingdom (Remastered's) + slave. His vanilla data (tw-game-data RTW/data)
  has no .json, and the nabataea write touched none. Asked where the file lies. If REX reads it when present,
  that may be how REX lifts the 21 limit (24 here) - to test once we know its place.
  **The user: the json is from HLR.** It lists 24 factions, not HLR's 31, so it cannot be what HLR runs its
  factions from - REX reads the .txt there; the json is likely a leftover. So what we know: under REX, plain
  RTW stops at 21 (his log), HLR has 31. He proposed "base the tool strictly on REX, drop vanilla";
  answered: no - the limit is the game's, REX or not, and people use vanilla / the original exe / M2 too;
  instead the tool knows each game's limit from evidence and says it up front. Awaiting his word.
  **SOLVED (the user sent the REX package, 2026-09-29; its text settings are in tw-game-data REX/)**: the limit is
  REX's own setting **`max_factions` in `data/descr_ex.txt`** ("Maximum number of factions (default in M2: 31,
  RTW: 21) / Increase to support more factions in mods"; REX ships `max_factions 21` in data/ and bi/; the file is
  optional, missing = the default). HLR must set it to 31 or more in its own descr_ex.txt (the user, 2026-09-29: HLR's max_factions is 31 = exactly its 31 factions, so a 32nd faction on HLR needs it raised - the tool offers that with a yes. The descr_ex.txt he uploaded with that answer says `max_factions 50` and is a newer REX file: also max_num_ancillaries 16, max_num_children 6, ages, bribery, horde, battle visuals - asked which file it is). Fix for his nabataea: raise
  it to 22+ (not yet confirmed in game). To do (next patch): ModData reads max_factions (the mod's descr_ex.txt,
  else the game's data/, else the default: RTW 21 / BI 21 per REX's file / M2 31); the New faction tab shows
  "N of max"; Preview offers, with a yes and a backup, to raise max_factions itself when REX is there
  (REX.exe in the game folder); without REX (original exe) the limit cannot be raised - say so. Other REX
  settings of note there: max_num_ancillaries 8, max_num_children 4, ages, faction_unlock (descr_caps_ex).
  **The user wants it (2026-09-29, "write it down for now")**: the tool does this itself - faction limit shown
  and raised with a yes - **and the same for regions**. Checked REX's descr_ex.txt / descr_caps_ex.txt: there
  is NO region setting (only max_factions); HLR has 315 ports, so > 200 regions already run under REX without a
  setting (the README: "Removed every single major engine limit like factions, regions..."). Without REX the
  original exes stop at about 200 regions (RTW / BI / M2 - check the exact numbers and error text before
  building). So: regions - show "N regions" and warn only for the original exe; factions - max_factions as above.
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

## Status (2026-09-29: main = v0.16.1 released (castle core fit with a hand-set size); v0.16.0 (modeldb: clone + packs; army steps aside; old .nut migration); v0.15.1 (castles: buildings.castles_allowed = game_kind medieval2 AND castle levels - GUI + with_kind; castle_fits refuses a castle > large_city in edit/start, level_picked refuses it in the window); v0.15.0 (M2 city / castle switch); v0.14.1 (M2 spaced surname keys kept); v0.14.0 released (own name lists, names-by-culture table; Discord text given); v0.13.0 released (names by culture, live on the map); v0.12.0 released; v0.11.0 the user's test round fixed - unique names, faction limit (limits.py), family with existing people, river chain, window fixes; v0.10.0 Terrain editor (terrain.py + gui_terrain.TerrainEditor, App.editors['terrain']); v0.9.4 (bi descr_regions fix: moddata.region_entries is the one reader/writer layout; bi manifest merged into rtw_gold_steam_manifest as bi/...); v0.9.3 (portrait library portraits.py + PortraitLibrary window; Art select map optional, off = originals kept, sel_map {'on'}); v0.9.2 renamed RTW & M2TW Campaign Editor; v0.9.1 released (Edit region..., new regions in the towns list at once, a new faction starts in a new region by one Apply - regionedit.apply_opts is the one writer of region work, plan_land/free_tile(start, own)); v0.9.0 released (Character editor = FamilyEditor(standalone) in App.editors['characters']; portraits); v0.8.0 released (Family tab: characters, traits, ancillaries, family tree drawn like the game's); v0.7.5 released (M2 castle core level crash; README report box); v0.7.4 released (Art map <= 40 % of the tab's height - it squeezed the picture list); v0.7.3 (Save logs zip -> RTW-Campaign-Editor-files/logs); v0.7.2 (log + settings in RTW-Campaign-Editor-files); v0.7.1 (the bottom buttons fix); v0.7.0 released - the first release since v0.1.2; github.com/MasterOogwayHomebrew/RTW-faction-tool/releases)

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
**Reply on Discord (2026-09-29)**: "It may throw an error when opening very large maps (hardcoded limits)" - agreed:
the game's own size limits come first; before a rescale the tool must know the engine's limit (original RTW / BI,
REX, M2 / M2EX) and refuse or warn in plain words - find the numbers (REX docs / strings, a test map in game).
The tool itself has no map-size cap (HLR's map loads); not tested on a much bigger map.

**Code signing** (the user, 2026-09-28: browsers / SmartScreen warn about the exe): needs a certificate
the user must get (identity checked): free for open source via **SignPath Foundation** (signpath.org, apply
with the repo; signs in GitHub Actions), or Azure Trusted Signing (~10 USD/month, identity validation),
or a paid OV certificate (SmartScreen still warns until reputation grows; EV removes it at once, costly).
Meanwhile: submit each release exe to Microsoft (microsoft.com/wdsi/filesubmission) as a false positive.
Once he has one, add the signing step to release.yml / build.yml. License: MIT already (LICENSE, README).
**Applied to SignPath Foundation 2026-09-29** (name RTW Campaign Editor, homepage = repo, download URL =
README#code-signing-policy, reputation = the YouTube video m1sCPg-Lzsw + releases + REX Discord). README has
the "Code signing policy" section (their wording) and SECURITY.md exists. When approved: the user sends the
SignPath organisation / project / signing policy slugs, he adds the API token as a repo secret, then add
signpath/github-action-submit-signing-request to release.yml (upload the exe as an artifact first). Remind
him to enable Private vulnerability reporting (Settings -> Security) for SECURITY.md.

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

## Open with the user (2026-09-29, before a /clear)

- **Name**: renamed to "RTW & M2TW Campaign Editor" in 0.9.2 (the user's pick). The repo is still
  RTW-faction-tool until the user renames it (Settings -> General; old links redirect). SignPath knows the
  project as "RTW Campaign Editor" - one line to them if they ask.
- **SignPath Foundation: REFUSED (2026-09-29, Phillip)** - not enough public signals yet (stars, forks, contributors,
  articles, Reddit / YouTube mentions, sustained activity); reapply once the project is better known, or a paid
  SignPath plan. Polite thanks-and-will-reapply reply drafted. Meanwhile: submit each release exe to Microsoft as a
  false positive; Azure Trusted Signing (~10 USD/month) if he wants signing sooner. Old note: application sent 2026-09-29, only the receipt mail so far ("few business days"). When
  approved: he sends organisation / project / signing-policy slugs, adds secret SIGNPATH_API_TOKEN; then add
  signpath/github-action-submit-signing-request to release.yml. He should enable Private vulnerability reporting.
- **Repo renamed** by the user to MasterOogwayHomebrew/RTW-M2TW-Campaign-Editor (GitHub redirects; the session's
  git remote still says RTW-faction-tool - repointing it was refused by the permission check, pushes work via the
  redirect). He turned on **code scanning** (security/code-scanning/1): the GitHub tools here cannot read alerts -
  ask him to paste the alert text (rule, file, line) and fix it.
- **GitHub security settings** (2026-09-29): security policy, advisories, code scanning (CodeQL on every push; alert
  #1 missing-workflow-permissions fixed by `permissions: contents: read` in both workflows), secret scanning,
  **private vulnerability reporting and Dependabot alerts all enabled** by the user. New alerts: he pastes the text.
- **Tester** (a Discord person) will try a version and look for bugs; reply given (releases link + Save logs zip
  + screenshot/video).
- **Not tested in game yet**: Family tab / Character editor (0.8-0.9), M2 own portraits, Edit region, new faction
  in a new region (0.9.1), M2 castle fix (0.7.5), unit packs, M3.
- **Art "Remove"**: dropped (the user, 2026-09-29): unlinking a picture only gives errors and the game's "cat"
  placeholder (he tried it with unit cards); instead **Back to the original** (below).
- Performance measured 2026-09-29 (vanilla RTW / M2 copies, Linux Xeon 2.1 GHz): ~100 MB RAM, load ~1-2 s, tabs
  < 1 s; HLR is ~3x the data (deep Check ~2 min). Exe: Python 3.12 (Windows 8.1+, 64-bit).
- The user's wishes not built: whole-map rescale; faction / building packs; culture of
  its own; strat-map flags; texture recolour; model viewer; Rome portraits of one's own (only if REX supports a
  `portrait` line - ask/check REX); portraits for records (M2 may take `portrait` there too - check).

## Where we stopped (2026-09-29, the latest /clear - read this block first)

- **STATE AT THE /clear OF 2026-09-29 ~12:15 UTC - READ THIS FIRST** (everything is pushed; main = session branch):
  - **Released today, in order**: v0.13.0 (names by culture live on the map), v0.14.0 (own name lists, all-towns
    names table), v0.14.1 (M2 surname keys with a space kept), v0.15.0 (M2 city / castle switch), v0.15.1 (castles
    Medieval II only + never above large_city), v0.16.0 (M2 battle_models.modeldb: clone + unit packs; army steps
    aside for a moved town; old ft_settlement_names.nut migrated), **v0.16.1 = latest** (castle core fit with a
    hand-set size). github.com/MasterOogwayHomebrew/RTW-M2TW-Campaign-Editor/releases
  - **In-game confirmed today**: M2 city / castle switch loads and runs (scotland, the user's log 14:03).
  - **Waiting on the user**: files for tw-game-data (asked 2026-09-29: a big mod's modeldb - Stainless Steel best -,
    Kingdoms modeldb + descr_model_battle, HLR root .txt + text/ + imperial_campaign/, BI descr_regions.txt);
    in-game tests (🧪 list in ROADMAP: modeldb clone / packs, names by culture under REX, own name lists, BI, climates,
    flag symbols...); he must UPDATE his exe (his HLR log came from a pre-0.13 build) and say yes to the old
    names-module fix on Load.
  - **Got 2026-09-29 (after the /clear), in tw-game-data M2/data**: models/ (strat/battle markers .cas, a few
    textures), unit_models/ (_generals_and_captains with .texture files, shields_library, weapons_library,
    equipment_library, weapon_testing - 353 files, 21 MB; M2 .mesh / .texture = the real unit models, useful for a
    model view and texture recolour), editor/ (brush_*.tga), tools/viewer/grass.texture. The re-sent
    battle_models.modeldb is byte-identical to the one already there. Big files still to come from him.
  - **Got next (2026-09-29)**: HLR text/ (+ russian/), HLR imperial_campaign (without map.rwm - the game rebuilds it),
    HLR enhanced_tweaks/*.json (kirsi / lanjane campaign tweaks, place in HLR assumed data/) -> tw-game-data HLR/data.
    M2 data/unit_models/_units (3336 files: 3082 .mesh + 254 .texture, 817 MB raw, ~310 MB in git): NOT pushed yet -
    **the user proposed one private repo per game** (done 2026-09-29: RTW-game-data = renamed tw-game-data, M2TW-game-data
    new, M2TW files + _units moved there and checked md5 for md5).
  - **Discord question "Can you create new religion with it?"** - the user's answer: edit, not create. True: M2 region
    religion shares are editable (Religions... dialog, regionedit.set_religions); Rome has no religions in vanilla; a
    new religion (M2 descr_religions.txt + religions text + EDB temples / religion requirements + traits + UI icons)
    is not built. Idea for later, like a culture of one's own.
  - **New climate for M2TW - a guide the user got (2026-09-29, not built, not promised)**: "Add new custom climate
    [max 32 slots] for MED2, use custom1 as reference, name slots custom_[1-20]". Files it names: strat - descr_climates
    (models, colour id, winter, heat), descr_sounds_stratmap (enviro sound), descr_aerial_map_ground_types (summer /
    winter textures); battle - descr_sounds_enviro, descr_vegetation (summer / winter vegetation + settings, "you have
    to generate them"), descr_geography (textures per climate + season), weather_db.xml (weather chance),
    descr_battle_map_movement_modifiers, descr_battlefield_roads.xml (road textures per climate); winter sounds in
    descr_sounds_units / _run / _anims / _march / _ambient / descr_sounds_engine; descr_water; text climates.txt;
    descr_climates_lookup. Checked on vanilla M2TW: the lookup has 13 names (mediterranean ... semi_arid, with unused1 /
    unused2 as free slots) and NO custom1 - the guide's custom slots and the 32 cap come from some other base (a mod
    or an engine patch - ask which); vanilla files naming a climate: descr_sounds_stratmap 18, aerial_map_ground_types
    2, sounds_enviro 7, vegetation 120, geography_new 77, weather_db 4, battlefield_roads 30, water 14; the unit sound
    files and movement modifiers name none by desert / semi_arid (winter / ground terms instead - to read).
    Hard part: descr_vegetation "generate" (raw_distribution_maps; M2EX text vegetation) - research before offering.
  - **REX docs the user pasted (2026-09-29; more coming)** - REX features the tool must know (rule 10):
    * EDU `stat_pri_attr ... sp` = shield piercing (halves the enemy's shield value) - a new attribute tag.
    * descr_caps_ex `trade_fleet_source port_level | capability` (default capability): which buildings raise
      trade_fleet levels (ports vs merchant wharfs).
    * **EDB brackets**: `requires ( ( factions { greek, southern_european, } and building_present_min_level port port )
      or ( factions { middle_eastern, } and ... ) )` - a level may carry SEVERAL factions lists, each with its own
      conditions. **Gap found in our code**: roster.factions_in / with_factions / covers (and buildings.Level's
      requires regex, editors / gui_editors callers) read and rewrite only the FIRST `factions { }` of a line, so on
      such a line the Roster tab says a faction of the second group cannot build it, Give adds to the first group only
      (wrong conditions), Take leaves it in the other groups. To fix (one shared place): all lists of a line; covers
      = any group; give = a group of its own copying the template's conditions (or refuse with plain words), take =
      out of every group; test with the doc's merchants_wharf example (Rome + M2TW).
    * .sd.xml sprite sheets (strat3, shared2, battle3, strat_ed, battle_ed, shared_editor + radar; in RTW-game-data
      RTW/data/ui) - already used by symbols.py for faction logos under sprite_format xml.
    * **EDU (REX)**: row spacing may be smaller than column spacing (formation line); new attributes
      `ai_cannot_skirmish`, `ai_cannot_toggle_formation` (attributes line); `recruit_priority_offset` in RTW EDU like
      M2TW's (AI recruitment weight). Our attributes are free text (no whitelist) - fine. **Gap**: editors.room_for
      allows a key only up to what some unit of the mod already has, so on a Rome mod with no recruit_priority_offset
      line anywhere the Unit editor's Add line refuses it (and does not offer it). To fix: a list of keys the engine
      knows (REX EDU keys, M2TW's) that may be added even when the mod has none yet - one place, both games.
    * **REX console / EDB / EDU additions**: `add_soldiers <character|settlement> <unit_type> <amount>` (absolute
      amount); `downgrade_building <settlement> <building_level_id>` (one level down, or destroyed at level 0; RTW +
      M2TW); EDB `retrain` (RTW) / `retrain_pool` (M2TW) = like recruit / recruit_pool but only retraining (both lines
      for one unit = recruitable); EDU attribute "Immune to Psychology" (the pasted spelling was `immue_to_psychology`
      - check the real keyword in REX docs / strings before offering it): no fear morale penalties.
    * **BUG FOUND (ours, M2TW, not fixed yet)**: vanilla M2TW export_descr_buildings has 1475 `recruit_pool` lines
      and 0 `recruit` lines, but roster.RE_RECRUIT / recruit_lines, editors.rename_unit (recruit lines follow a
      rename), packs._recruit_places and editors line 114 / 386 / 647 read only `recruit` (line 114 also
      recruit_pool). So on M2TW: the Roster tab finds no recruit places, a unit rename leaves its recruit_pool lines
      on the old name (the game then refuses them), unit packs carry no recruit places. Fix in one place: a
      recruit-line reader for recruit / recruit_pool / retrain / retrain_pool (unit name = the quoted first
      argument), used by every caller; LIST_KEYS gets retrain + retrain_pool; retrain-only = not recruitable.
      Test on M2TW-game-data (england) + Rome.
    * **descr_campaign_ai_db.xml invade values** (inside the AI labels; a faction's ai_label picks the tree):
      invade_immediate (ATTACK_NORMAL, attacks at once), invade_opportunistic (ATTACK_BLITZ, take + hold one region),
      invade_buildup (ATTACK_GRIND, waits until ~50 %+ of its targets are ready - why buildup-only AIs look frozen),
      invade_raids (ATTACK_RAID, no conquest), invade_start (masses on the border, never attacks), invade_none. Idea:
      the Faction tab's AI choice explains the ai_label's behaviour in these plain words.
    * descr_ex `max_factions` - known (limits.py); the log line `descr_ex.txt: max_factions = 31` confirms it.
    * ALX trait `Immortality` (Characters family, Hidden) restored in RTW + M2TW under REX: generals live past the
      hardcoded 122 - the Character editor may offer it for old characters (ages > 122).
    * descr_strat `use_two_seasons true|false` (false = spring + autumn too; 4 seasons start in winter) and
      `turns_per_year N` (>= 2, a multiple of 4 with 4 seasons; income divided by turns/2), after start/end_date.
      **REMOVED from REX for now** (REX note, 2026-09-29: "Turns per year changes have been removed for the time being
      as additional fixes are needed") - do not build anything on them until REX brings them back.
  - **Discord**: the Stainless Steel author praised the tool and asked for modeldb (done in 0.16.0, reply text
    given); Espartan asked for castles (done in 0.15.0, reply given); a tester loaded a 5456 x 2464-tile map.
  - **Next ideas (not promised)**: Unit editor model view (a unit's modeldb / descr_model_battle models, textures per
    faction, scale); modeldb in Check mod; kind (city / castle) for rebel-owned new regions; REX settings panel;
    heights brush + tilted preview; new map from scratch; map rescale after the engines' limits are known.
  - ROADMAP uses coloured emoji now (rule 8).


- **Released v0.14.0 (2026-09-29)**: (1) **own name lists** (the user: "add new name lists for e.g. an Arab country; type the
  names in a format - comma or space separated - then surnames in a second step"): namelists.py (parse: commas /
  semicolons / new lines, else spaces; key_of = spaces -> _; problems: >= 1 men + >= 1 women, keys only
  [A-Za-z0-9_'-]; apply = own descr_names section (replaced when alone, taken out of a shared BI header), names.txt
  {Key}\t\t\tText and descr_names_lookup.txt keys appended when missing; keep_used: names the faction's characters /
  records carry in any campaign stay, warned). **Plan.name_pool(faction)** = the pool as the plan leaves
  descr_names (moddata.pool_in is the one parser) - start / edit / family pick names through it, so the leader of a
  new faction with its own list takes its names. clone.names writes opts['names'] instead of the copy; edit opts
  'names'. Window: gui_names.NameListWizard (3 steps, copy / add from any faction), App.name_list {faction|'(new)':
  pools} in UNDO_KEYS, pool_for / leader_pool / refresh_name_combos. (2) **names-by-culture table**:
  gui_culturenames.CultureNamesTable (column per culture, sort, filters, edit in place, grey = culturenames.foreign
  = rename_settlement lines of the mod's own script); App.owners_after is the one "owners after Apply" (map + table).
  (3) A tester's map of **5456 x 2464 tiles** loaded (the user: "pixels"; his screenshot shows tile x 5144, so they
  are map_regions.tga pixels = tiles; vanilla Rome 255 x 156): Map tab, Regions mode, new regions painted, no
  trouble. The game's own map-size limits are still unknown.
- **0.16.1 (2026-09-29, the user's M2 log Medieval_II_Total_War_logs_20260929_140307)**: scotland, Edinburgh -> castle
  -> city again, Inverness taken + made a city + large_town by hand: the game (M2EX, 13:59) started and ran - castle
  / city in-game ✓ (loads). The game's own log converts like convert(): "Conversion target building not specified:
  England, large_town -> castle, market[0](corn_exchange) : building will disappear during conversion". Bug fixed:
  with_kind refitted the picked governor's building to the FILE's level (town) -> wooden_pallisade in a large_town
  (Preview warned "the game refuses"); now convert(fit_core=picked is None) and the level = sizes' hand level.
  Then he Restored (14:02) and took the vegetation set-up fix again.
- **0.16.0 (2026-09-29, the user: "do modeldb and release")**: modeldb.py - ModelDB(text) parses the Boost text
  archive (strings = len + space + chars, may hold spaces; class info pairs only on a class's first appearance;
  layout in the module docstring: lods, textures [faction, tex, normal, sprite], attach (same class as textures,
  no vector class info), mounts [type, primary, secondary, weapons (ci), weapons2], torch bone [ci] 6 numbers);
  dump() byte-exact on the vanilla 701 models; add_faction(template, new) (textures + attach), add_model,
  to_dict/from_dict/same/files_of/give_owners; find(mod) = the mod's unit_models copy, else the game's (the edit
  goes into the mod); plan_add_faction in build after texture_lines. packs: manifest 'modeldb' {name: dict} +
  their files (add_ref: paths with spaces), _modeldb on import (renamed["model"] shared with descr_model_battle,
  give_owners), _owner_textures (descr_model_battle texture lines for owners, Rome too), case-insensitive model
  names (EDU Feudal_Knights vs feudal_knights). Also from the user's HLR log (HLR_logs_20260929_134313): mapedit
  moved-town army steps aside (mod.free_tile) instead of "move it first"; gamefix 'old_culture_names' migrates
  script/modules/ft_settlement_names.nut (his exe was older than 0.13 - tell him to update). Not built: Unit editor
  model view / scale; modeldb in Check mod.
- **The Stainless Steel author on Discord (2026-09-29)**: "Already seen it, looks great! Once you've built the modeldb
  additions it will be epically useful for modding ... rather than just extremely useful" - battle_models.modeldb
  (M2 clone / unit packs) is the most wanted next step from known M2 modders; the vanilla file is in tw-game-data
  M2/data/unit_models.
- **M2 city / castle BUILT, released 0.15.0 (the user: "do it and release")**: buildings.py - Level.kind ('city' |
  'castle' = the word after the level name), Level.convert_to (int, the target chain's level), Building.convert_to
  (chain); settlement_kind / set_kind (header), has_castles, core_chain, kind_problem (huge_city cannot be a castle:
  core_castle_building has 5 levels, core_offset 0), convert(items, kind, known, level) (the game's convert_to;
  none = goes; core refitted via core_level_for), with_kind(plan, f, region, raw, kind, picked, known) = the one
  writer, called by start._with_buildings and edit._buildings before sized(); opts 'kinds' {region: kind}.
  Window: BuildingsEditor 'Settlement is a' combobox (only when has_castles), chains() offer only levels of the
  kind; App.kinds in UNDO_KEYS, set_kind converts buildings_picked at once, lb_build shows '(-> castle)'. Checked on
  vanilla M2 england (London city -> castle, Nottingham castle -> city; window; Restore byte-exact) + a synthetic
  test. Not built: kind for a rebel-owned new region (only the faction's towns). Old note:
**M2 castle vs city - NOT in the tool (found 2026-09-29, Espartan on Discord: "I wanted a castle, I only get
  cities")**: the user answered him "the core building decides it, pick it on the Buildings tab" - WRONG for us. In
  M2 a castle is the descr_strat block header `settlement castle` (vanilla imperial_campaign: 50 of them) plus
  castle-marked levels (EDB: `motte_and_bailey castle requires ...`, `wooden_pallisade city requires ...`; the core
  chains are core_castle_building (convert_to core_building) / core_building, same for castle_barracks <->
  barracks). The tool never writes or changes the `castle` header (start / edit / new regions write `settlement`),
  and the Buildings tab does not filter levels by their city / castle mark, so a castle core in a city block is a
  mismatch the game may refuse. To build (asked the user): a City / Castle switch per town (Buildings tab + New
  region dialog, M2 only): header, core chain swapped via convert_to with the level from core_offset (castle =
  settlement level, city = level - 1), other buildings swapped by convert_to or dropped, the pickers offer only
  levels marked for that kind; Preview says it in plain words.
- **0.14.1 (2026-09-29)**: the user: "no spaces in names - the console wants \"Gaius Julius_Caesar\", \"Diodotus
  of_Spartocid\"". Our keys already use _ (key_of); RTW vanilla does too ({of_Scaldis} of Scaldis). But vanilla
  **M2 has surname keys WITH a space** (descr_names: de Avena, Della Corte; 8 factions' characters carry them:
  france de Lyon, hre von Saxony, turks al Rashid...) - keep_used rewrote them as de_Avena (another key -> crash).
  Fixed: used_names matches first name / whole surname, kept keys are namelists.Kept (key_of returns them as they
  are); names.txt text = key with _ -> space. Wizard FORMAT text explains _.
- **Released v0.13.0 (2026-09-29, after the evening /clear)**: settlement names by culture + New mod folder -bi / -alx
  (both were Unreleased) + **the name live in the window** (the user: "the change should show on the map in real
  time - the name of the culture of the faction I took the town for"): culturenames.name_for / labels(table, towns,
  owners, culture_of); App.culture_labels(owners, me) = the script's table + pending culture_names, owner cultures
  from mod.factions() (a new faction = its template's); show_map passes labels= to MapView.load (town labels),
  map_city's status says "(now X)", fill_towns "(shown: X)", the dialog's OK redraws. Checked in the window on
  vanilla RTW (julii take Mediolanium -> "Mediolanum"). In game still to test.
- **STATE AT THE LAST /clear (2026-09-29, evening)** - read this first:
  - **Released: v0.12.0** (github.com/MasterOogwayHomebrew/RTW-M2TW-Campaign-Editor/releases/tag/v0.12.0): climates,
    flag symbols + faction logos (symbols.py), Restore to any backup, BI names + building pictures, recruit cap
    lifted, descr_ex ancillary / children limits, captain names, Linux tkinter message.
  - **On main, NOT released (CHANGELOG "Unreleased")**: settlement names by culture (culturenames.py -> marked block
    in the campaign's campaign_script.txt, REX's documented rename_settlement); new mod folder from bi / alexander
    starts with `REX.exe -bi` / `-alx`. Release as 0.12.1 / 0.13.0 when the user says "patch".
  - **The user's standing rules added today**: REX first for every feature (rule 10 above); keep vanilla + M2 working.
  - **REX documentation** (dump_docudemon: console_commands, docudemon_commands / _conditions / _events) is in
    tw-game-data REX/documentation - use it before guessing; REX.exe strings also list a Squirrel API (::game,
    ::events.on, ::stratMap) and an EOP-Lua API (M2TWEOP.callConsole, regionStruct...).
  - **Waiting on the user (in-game tests)**: names by culture (take Rome with barbarians), `script` line at the end
    of a Rome descr_strat under REX, `-bi -mod:<name>` together, flag symbol + faction logo of a new faction,
    climates, BI Eastern Empire building pictures; how vanilla treats foreign buildings on capture (culture
    conversion wish); the Discord tester's Tarentum garrison logs; Andy's Take's answer.
  - **Next, in his order**: a REX settings panel (descr_ex / descr_caps_ex with plain words) was proposed - ask;
    heights brush + tilted 3D preview; a new campaign map from scratch; map rescale only after the engine's size
    limits are known.
  - SignPath Foundation refused (reapply later); Linux works from source (checked here under Xvfb).

- **Released: v0.12.0 (2026-09-29)**: climates, flag symbols + faction logos, Restore to any backup, BI names /
  building pictures, recruit cap, descr_ex limits, captain names (family records, M2 two-word names), Linux tkinter
  message; checked on Linux from a clean `git archive` (window under Xvfb, Rome + M2, 0 errors), deep Check Rome
  20/21 + M2 18/21 fine (the rest: correct refusals - a one-town faction's leader has nowhere to go).
  Earlier: **v0.11.0** (the whole test round fixed); then on main the
  Terrain editor's **Climates** mode (see the note under "Asked on Discord (Tymon)" below) - CI green (run
  36514540391). The user should test it in the game (paint a climate, start the campaign, see the vegetation);
  release it as 0.11.1 / 0.12.0 when he says "patch" (bump gui.VERSION + CHANGELOG, push main, run release.yml).
- **Next, in the user's order**: heights brush (raise / lower / smooth; mountains and hills kept high, switchable)
  + a tilted 3D-like preview; then **a new campaign map from scratch**. A new climate of one's own: only after
  research (descr_climates + every file keyed by climate, engine caps) - not promised.
- **Waiting on the user** (older list): bi descr_regions.txt; Andy's Take's answer. HLR max_factions = 31 (answered).
  descr_ex ancillary / children limits: BUILT in 0.12.0 (limits.ex_setting, family.limit_warnings).
- Session set-up for a new session: add_repo MasterOogwayHomebrew/tw-game-data, `git clone --depth 1` into
  /home/user/tw-game-data; GUI checks under Xvfb :57 with python3.12 (scripts like the scratchpad's clim.py:
  gui.App(), v_path.set(data), load(), v_work.set('terrain'), work_changed(), editor()).
- Older (v0.10.0 time): the user tested the Terrain editor in the game - done, see the test round below.
- Then, in his order: heights brush (+ mountains/hills raise the land, switchable) and a tilted 3D-like preview;
  **a new campaign map from scratch** (one region, one faction, loads in the game) and editing existing maps.
- **Art pictures of one's own** (2026-09-29, on main, not released - goes into the next release): new faction's
  banners / loading logo are its own files; Replace of a shared picture = own copy + repointed line; real DDS
  writes; Back to the original. Art "Remove" dropped (his test: unlinked pictures = errors + "cats"). To test in
  game: a clone's banner in battle (standard_<new>.tga.dds written by Pillow DXT5 + mipmaps), the loading logo.
- **Why the clone exists** (the user's words, keep to it): a clone is a ready template that surely starts in the
  game, so every change can be checked in the game at once, instead of building a faction from nothing first.
  It ADDS a faction, never replaces one: everything of the new faction must be its own (files named after it,
  lines pointing at them); the template must stay untouched whatever is edited on the new one. He expects files
  named after the new faction (Epirus from Macedon -> *_epirus*), not the template's names.
- **Files asked of the user for tw-game-data** (2026-09-29): RTW `data/models/textures` (banner .tga.dds),
  `data/loading_screen`; M2 `data/loading_screen`, `data/unit_models/battle_models.modeldb`, `data/ui/<culture>/
  portraits` + `data/ui/custom_portraits`; RTW `bi/data/world/maps/base/descr_regions.txt`. He sends 7z volumes
  of 30M in the chat; we push them to the private repo only. **Got 2026-09-29** (in tw-game-data now): RTW
  models/textures + loading_screen, M2 loading_screen + battle_models.modeldb (Boost text archive, 1 MB). M2
  southern_european (portraits, buildings, cities, interface), northern_european, ui/custom_portraits,
  ui/generic, ui/*.sd(.xml) sprite sheets also in (eventpics left out: the tool does not use them). Still
  missing: bi descr_regions. Repo ~620 MB (GitHub advises < 1 GB): pictures only on demand, never whole ui/.
- **M2 portrait pools (vanilla, checked 2026-09-29)**: ui/southern_european/portraits/portraits/young/<9 groups>
  (generals 201, others 100, inquisitors/witches 20), old/generals only, dead/NNN = generals, dead/princesses;
  **no cards folder** (general_card.tga at the portraits root); family/ + family/dead. northern_european and
  greek have portrait_mapping southern_european (their own folder has only family/). custom_portraits:
  william, rufus, henry, fernando, hernan (portrait_young/old/dead.tga); harold is named in norman_prologue
  but has no folder. portraits.library/add now follow this (no cards/old made where the game has none,
  princesses' dead written).
  Checked on the real RTW files: macedon -> epirus gets standard_epirus(.tga.dds, DXT5 256x256, 9 mips) +
  _ally + symbol128_epirus, lines point at them; Replace writes DXT5 with the same mips; macedon untouched;
  Restore identical (diff -r).
- **Wiki** (the user offered it for game files, 2026-09-29): NO game files there - a public repo's wiki is public
  (CA / SEGA files). Game files only in the private tw-game-data. The wiki is fine for a user guide; the first page
  must be made in the web UI before its git repo (<repo>.wiki.git) exists.
  **The wiki's pages live in docs/wiki/** (English; Home, _Sidebar, Installing, First-steps, New-faction,
  Edit-a-faction, Campaign-map, Terrain-editor, Faction-art, Characters-and-portraits, Units-and-buildings,
  Backups-and-Restore, Reporting-a-bug); `.github/workflows/wiki.yml` copies them into <repo>.wiki.git on a push
  to main that changes docs/wiki (GITHUB_TOKEN, contents: write; pages made only in the web editor are kept).
  The session's git proxy refuses .wiki repos (403, add_repo cannot add them). Keep the pages current with the
  README when features change.
- **The user's test round (2026-09-29) - ALL FIXED in 0.11.0** (kept for the record):
  1. Portrait library (Rome, roman / generals, dark theme): the portraits stand in ONE column down the left, the
     rest of the window empty. Cause (not fixed yet): gui_family.PortraitLibrary.show computes
     `cols = max(1, (cv.winfo_width() or 900) // 56)` - before the canvas is laid out winfo_width() is 1, not 0,
     so cols = 1; and nothing re-lays out on `<Configure>`. Fix: take the width after update_idletasks (or the
     window's), and redraw on the canvas's `<Configure>` (like gui_art's _reflow). The user: after clicking
     young / old / dead the grid laid out right - confirms it (the second show() sees the real width).
  2. Traits / ancillaries "not all for everyone - is there sorting by agents, admirals, characters?" (the user,
     Character editor trait picker). Traits ARE filtered by kind already (gui_family: `Characters` line of the
     trait vs family.trait_kind: family / spy / assassin / diplomat / admiral; M2 also princess, priest,
     merchant, inquisitor, witch, heretic). Gaps found (not fixed yet): `Characters all` (2 vanilla RTW traits)
     is shown for nobody - must match every kind; ancillaries are NOT filtered at all (cb_anc = every
     ancillary; ancillary_list reads ExcludeCultures but nothing uses it) - filter by the faction's culture
     (ExcludeCultures) and, where the file says so, by kind; show the kinds a trait is for next to it.
  3. Rome, Character editor, Portrait: "why can't I Replace?" - the three Replace buttons are shown but greyed
     (Rome has no portrait line of its own: set_portraits refuses; the grey text on the right says so, but the
     user did not see it / it does not say what to do instead). Also old / dead show empty boxes though the pool
     has the same number old and dead. To do: in Rome show the old / dead of the same pool number; replace the
     greyed buttons with a plain line + a button that helps: "Rome picks from the culture's pool at random -
     add your picture to the pool (Portrait library...)" (and, when checked, REX: does it read a `portrait`
     line or a portrait per name? - find out before offering a real Replace).
  4. Terrain editor: the top **Undo stroke** works, the bottom **Undo / Redo** "does something unknown - maybe
     undoes elsewhere?". Checked: it undoes nothing - App.undo/_in_editor only sets a status line, and that line
     is wrong in the Terrain / Character editor ("In the building editor: 'Undo all changes here'..." - it names
     unit or building only). To do: the bottom Undo / Redo (and Ctrl+Z / Ctrl+Y) go to the editor on show
     (Terrain: undo stroke / redo stroke - needs a redo stack; Character editor, Unit / Building editors: their
     own steps), or are greyed there with the right editor's name - never a silent click.
  5. **Terrain editor in the game (RTW, vanilla imperial_campaign, 2026-09-29): no crash, the campaign loads,
     the painted river is drawn** - the first in-game check of 0.10.0. The user found the game's river rule:
     **river tiles must touch by an EDGE (4-connected); where two river tiles meet only by a corner, the game
     does not draw the river there** (his long painted river south of Carthage/Thapsus shows gaps at the
     diagonal steps). To do: the river brush keeps rivers 4-connected (a diagonal step fills one of the two
     corner tiles itself - the one that is land and not a town/port), Preview warns about corner-only contacts
     (terrain river check today only finds a river tile touching no other); same for fords (part of the river)
     - check M2's rule too. Add to Hard-won rules once built. He is still checking the drawing of all layers.
     **Corrected by the user (second screenshot pair, Cyrene - Siwa - Alexandria)**: not gaps - the game
     **traces a river from where it joins another river (here the Nile at Alexandria; probably also a map edge
     / the sea / a river source - not checked) and stops at the first corner-only step; everything past it is
     not drawn at all**. His river painted west from the Nile shows in the game only up to the first diagonal
     step (red mark), the rest of the desert river is missing. So: a river must be one edge-connected chain from
     its start (another river, the sea, or a 255 255 255 source tile); Preview should name the tile where the
     drawn river will stop and how many river tiles beyond it the game will not draw.
     **His logs (2026-09-29 03:23-03:56, vanilla RTW + REX build Sep 27 2026)**: three terrain Applies (ground
     only; 193 river tiles + 1 shallow sea; 15 cliffs, 13 river, 7 fords + 100 ground tiles of 7 kinds), the
     game rebuilt map.rwm ("map.rwm out of date - rebuilding") and loaded the campaign with no terrain error;
     then Restore of all three, newest first, worked. Only game-side noise (Combat_V_Romans ancillary assert =
     vanilla's, REX sprite warnings). ROADMAP: Terrain editor ticked (in-game ✓ on Rome); the river-chain step
     added to Next. Not checked in game yet: Medieval II terrain, heights (no brush yet).
  6. **New faction nabataea (from egypt) in the game, vanilla RTW + REX with `max_factions 31` (2026-09-29
     04:20)**: the campaign loads with 22 factions ("descr_ex.txt: max_factions = 31" in the log) - the limit fix
     confirmed. The user's own picture (Art Replace) shows everywhere as the faction icon - Art in-game ✓.
     **Bug (ours): duplicate character names** - REX: "descr_strat.txt, at line 3978 / 3990: duplicated character
     name in this faction, skipping" (world.cpp(987), logged fatal, the game goes on without them). The tool
     named the new army "Ptahotem" = the leader's name, and the spy "Heruben" = the captain who came with Petra1
     (log: "army Ptahotem at 211, 35", "spy Heruben at 208, 34", "captain Heruben leads your garrison").
     Rule to add: **a character's name must be unique within its faction** (in descr_strat, the first name as
     written); every name the tool picks (new armies / agents / fleets / captains / heirs / records) must skip
     names the faction already uses, and Preview must refuse duplicates. Test first on a synthetic mini-mod.
     Game-side, not ours: REX assert "AI_REQUEST::set_move_position not implemented ... Please tell ***" (a
     Pontus captain embarking, ai_action_request_controller.cpp(526)) - the game went on to 04:23 - worth
     reporting to REX; Combat_V_Romans (vanilla).
  7. **Family tree does not work for a new faction** (the user: nothing can be added). Not looked at yet - the
     clone writes no character_record / relative lines for the new faction (leader + heir only); check
     FamilyEditor / family.read with an empty tree, Give a wife / Add a child with no records to copy the form
     from (family.apply copies "a record of the file" - the new block has none: take one from another faction).
     Wait for his command before fixing (he said so again).
- **Released v0.11.0** (2026-09-29, github.com/MasterOogwayHomebrew/RTW-M2TW-Campaign-Editor/releases/tag/v0.11.0).
- **Asked on Discord (Tymon, 2026-09-29): edit map_climates.tga / add a new climate?** Facts (both vanilla):
  map_climates.tga is 2W+1 x 2H+1 like map_ground_types (RTW 511x313, M2 591x379); each colour is a climate of
  data/descr_climates.txt (`climate <name>` + `colour r g b` + its vegetation / textures per season): RTW 12
  (test_climate 236 0 140, sandy_desert, rocky_desert, temperate_grassland_fertile/_infertile, temperate_forest_open/
  _deep, swamp, highland, alpine, sub_arctic, semi_arid), M2 12 with two named unused1 / unused2 (placeholder
  slots - a fixed count?). Painting existing climates = the Terrain editor's ground brush on another picture
  (ROADMAP Next "Terrain: climates") - not built yet. A new climate = a descr_climates entry + every file keyed by
  climate (vegetation, battle-map textures, ...) and maybe an engine cap (REX's README says cultures/religions
  limits are lifted, climates not named) - not checked, not promised. Answer given in English for Discord.
  **Climates brush BUILT (the user said "da", 2026-09-29; on main, Unreleased, not in game yet)**: Terrain editor
  third mode "Climates": `terrain.climates(mod)` = [(name, colour, heat)] from descr_climates.txt (commented
  blocks skipped); `terrain.apply(..., climate=)` writes map_climates.tga in 3x3 blocks like the ground (notes by
  climate name); paint_problem 'climate' refuses sea only; `CampaignMap.climate_at` + `show_climates` (land tinted
  in the file's colours, part of the background cache key); gui_terrain keeps self.climate beside ground/features
  (undo/redo/_state/_restore_to, _signature reads map_climates too); palettes wrap 6 per row (> 8 brushes).
  Checked in the window on vanilla RTW + M2 (30 tiles sandy_desert, undo/redo, Preview). To test in game: that the
  painted climate shows (vegetation) after map.rwm is rebuilt. Next per his order: heights brush, then new map.
- **BUG (the user, 2026-09-29, screenshot; to fix later - "write it down for now")**: BI, Edit faction, the Roman
  Empire (Thracia, Achaea... = the eastern empire), Buildings tab: core_building / defenses / barracks / market ...
  show BARBARIAN pictures (thatched huts) though the culture is roman; academic, amphitheatres, temples: empty boxes.
  Likely cause (read, not yet checked on BI files): `buildings.BuildingPictures` - (1) `cultures()` ends with EVERY
  other culture sorted (barbarian first), so a level the roman folder lacks takes the barbarian picture; (2) `find()`
  loops names outside cultures, so the full level name in a foreign culture beats the roman alias / shorter name;
  (3) it indexes only `mod.data/ui` - bi/data/ui holds only BI's own pictures, the rest lie in the game's data/ui
  (the fallback the game uses), so the roman pictures are not seen at all. Fix: search the game's data/ui after
  the mod's; never a foreign culture's picture (only the culture + its descr_ui_buildings variants), an empty box
  with "no picture for roman" instead; names inside the culture loop.
  **The user's wish on top (2026-09-29, to build with this fix)**: a **Culture** choice on the settlement in the
  Buildings tab - the pictures (and which levels are offered) follow the chosen culture, so one can convert a
  town's buildings by hand; and when a faction takes a town of another culture (Take towns, a new faction's
  start towns), the buildings **convert by themselves** to the new owner's culture: a level the new owner may not
  build (EDB `factions { ... }` / `requires factions`) is swapped for the matching level of its own chain (same
  chain type / same rank - e.g. a barbarian temple -> a roman temple of the same level), or dropped when there is
  none, shown in Preview with plain words. Note: descr_strat buildings carry no culture - the game shows a chain
  in the owner's culture; the real work is swapping levels the owner cannot have. Check how the game itself
  treats foreign buildings on capture (RTW: destroyed / kept?) before choosing the rule.
  The user (2026-09-29): as far as he knows the game converts nothing on capture - foreign temples stay until the
  player demolishes them and builds his own; he will check vanilla and say exactly. Wait for his word. Test first on BI files (ask for bi/data/ui/
  roman + descr_ui_buildings.txt, or use tw-game-data RTW ui/) and check M2 the same way.
- **Night of 2026-09-29 (the user: "finish everything, I'm off to sleep")** - on main, Unreleased, CI checked:
  (1) building pictures: buildings.BuildingPictures = the culture + its descr_ui_buildings variants only (the old
  tail of every other culture gave BI's roman towns barbarian huts), mod ui first then the game's data/ui
  (buildings._game_data via newmod.game_of - BI and REX mods take what they lack from data/); a level with no
  picture says so in the Buildings tab info line. Vanilla RTW: only levels a culture cannot build lack a picture
  (roman: odeon, lyceum... = greek). Checked in the window (julii, Buildings tab). BI ui/ not uploaded - the user
  should look at the Eastern Empire again. (2) limits.ex_setting(mod, key) reads descr_ex.txt numbers (mod,
  then game, then default); family.limit_warnings: Preview warns on > max_num_ancillaries (8) per character and
  on children added past max_num_children (4; M2 not counted). (3) BI root .txt + text/ pushed to tw-game-data
  RTW/bi/data. NOT done, waiting on him: culture conversion of buildings (his word on vanilla), BI New-mod-folder
  imperial_campaign errors (did the game crash at 05:25:41?), release (say "patch").
- **FIXED (2026-09-29, on main, Unreleased)**: BI names - bi/data/descr_names.txt heads sections with a LIST of
  factions (`faction: empire_west, empire_west_rebels`, `faction: empire_east, empire_east_rebels`; alemanni has 4
  sections, the first differs - the first counts; BI has no slave section). moddata.name_sections is the one reader
  of the headers (name_pool, clone.names: the clone writes `faction: <new>` alone). Checked on the user's bi/data
  (empire_east 131 men / 430 surnames / 90 women). The user uploaded bi/data root .txt + text/ (no ui/, no world/)
  - put into tw-game-data RTW/bi/data when convenient. **Restore made smarter** (the user: "clicking every backup
  one by one?"): plan.restore_to(mod, bdir) undoes bdir and every newer one, newest first; backups() orders by
  stamp + manifest mtime (one Apply writes terrain + faction backups in the same second - by name the order was
  wrong); backup_label for the list; the dialog selects the whole range and says how many; cli restore uses it.
  **His BI log (05:25, mod bi_Empire_east made by New mod folder from bi/data)**: the mod's fallback under REX is
  the game's data/ (plain RTW), so the menu's imperial_campaign is read with BI's factions ("Expected faction list
  terminated by end", "Expected start date of campaign" at imperial_campaign descr_strat line 8); barbarian_invasion
  loaded (REX "armour 1 is beyond this unit's 1 upgrade tiers; clamped" x24 - BI's own lines 478-561?), log ends
  while loading region labels - asked whether it crashed. To do: a New mod folder made from bi/ must know that REX
  falls back to data/ not bi/data (copy what BI takes from bi/, and hide / drop imperial_campaign?).
- **BUG (the user, 2026-09-29, screenshot, BI)**: Edit faction empire_east, a garrison for Numid1 (a town nobody
  holds): "Numid1: no name in empire_east's name list for a captain" (edit._garrisons: `mod.name_pool(faction)
  ['characters']` came back empty). The user: "solve it once and for all - the tool is for other mods too, it must
  find everything". Not reproduced yet: tw-game-data has no bi/data/descr_names.txt (vanilla RTW's format reads
  fine; REX/bi descr_sm_factions has `faction empire_east, shadowed_by empire_east_rebels`). Suspects:
  moddata.name_pool (the one reader of descr_names) misses BI's layout (shared / differently named sections, a
  pool under another faction, names in names.txt only), or the file is taken from the wrong folder. Asked for
  bi/data/descr_names.txt + bi/data/text/names.txt. Fix in name_pool itself (every caller: start, edit, gui New
  army, family), a test on the real file, and a plain message saying which file and which faction section was
  looked at, never a dead end.
- **Discord tester (2026-09-29, via the user)**: made two new factions + new units, campaign and custom battles run
  with no crash. Asked: (1) Building editor Add line refused "no building level in this mod has more than 101
  'recruit' lines in its capability" - that is OUR rule (editors.room_for / line_limits: never beyond what the mod
  already has), not the game's (HLR has 702 in one capability). Proposed to the user: lift the cap for `recruit`
  (lines that only list units); workaround now: Unit editor "Copy as new..." of a unit already recruited in that
  level (copy_unit writes a recruit line next to each of the old one's). Waiting for the user's word. (2) New
  factions show the template's symbol on the strat-map flags (banners/symbols*.tga.dds slot via descr_sm_factions
  standard_index) and on the faction button (logo_index sprite in ui/*.sd) - NOT built (see "RTW strat-map
  flags"); answered "planned". (3) Tarentum garrison "bugged" after switching faction before removing the
  garrison: units with blank cards in his army panel - not looked at; asked for the Save logs zip + descr_strat.
- **Flag symbols + faction logos BUILT (the user: "do it now", 2026-09-29; on main, Unreleased, not in game yet)**:
  symbols.py. Facts (vanilla RTW + REX, checked): `standard_index k` -> banners/symbols<k//4+1>.tga.dds (128x128
  DXT5, 8 mips), quadrant k%4 = TL, TR, BL, BR (julii 0 laurel, brutii 1 dagger, scipii 2 wolf, senate 3 eagle,
  macedon 4 lambda); vanilla uses 0-20, BI 0-19 (a faction and its shadow share one), BI adds symbols9-15.
  `logo_index` / `small_logo_index` = sprite NAMES in ui/strat3.sd.xml (52x52, stratpage_02.tga - full, no room) /
  ui/shared2.sd.xml (32x32, sharedpage_01.tga); pages in ui/<culture>/interface, REX falls back to
  ui/roman/interface (REX.exe strings). REX descr_caps_ex.txt `sprite_format xml` ("v7 .sd.xml with runtime atlas
  packing, allows you to freely add new sprites"; default sd = binary .rsd, which the original exe reads). So: a
  new faction (build -> symbols.give_own after clone.own_pictures) gets free_slot() (lowest standard_index no
  faction uses) with the template's quadrant pasted (the sheet re-encoded with image_dds in the sheet's format,
  written to the mod's banners/), and under xml mode a <page file="faction_logo_<f>.tga"> / faction_logo_small_<f>
  with one sprite FACTION_LOGO_<F> / SMALL_FACTION_LOGO_<F> appended to the sheet (the mod's copy; byte-exact
  otherwise), logo lines repointed. Art tab: symbols.entries first (crop of the sheet, 'symbol' flag, key
  symbol:flag / symbol:logo / symbol:small_logo in App.art_replace; factionart.apply_opts -> symbols.write). No xml
  mode: logos shown, locked, warning. Rome only (limits.game_kind). Checked: vanilla RTW copy (epirus from macedon:
  slot 21, own sprites, red flag replace, macedon untouched, Restore byte-identical), window (Edit julii, New epirus),
  synthetic test. To test in game: the flag on the campaign map, the faction button logo (REX), and a slot > 31
  (symbols9+ on plain RTW - BI's exe reads them, not checked for RTW data). Also done: Building editor recruit
  lines uncapped (editors.LIST_KEYS recruit / recruit_pool) - the tester's 101.
- **Linux user (Discord, 2026-09-29)**: Mint, 0.11.0 source zip: `python` missing (use python3), then
  "No module named 'tkinter'". rtw_faction_tool.py now says what to install (apt python3-tk python3-pil
  python3-pil.imagetk; dnf python3-tkinter python3-pillow-tk; pacman tk python-pillow); README + wiki Installing.
- **The user noticed (2026-09-29)**: changing primary/secondary colour recolours the campaign-map flags (the 3D
  strat_flag model) in the game - the engine tints banners/strat_flag.tga.dds with the faction colours at run
  time and draws the standard_index symbol on it; only the symbol is a picture (now replaceable). Battle banners
  (models/textures/standard_<f>.tga.dds) are full textures, not tinted.
- **Asked on Discord (2026-09-29): settlement names by the owner's culture (scripts)?** Not in the tool. Facts: vanilla
  RTW / M2 files show no per-culture settlement names (M2 lookup / labels checked). REX.exe has console commands
  `rename_settlement <settlement> <name>`, `rename_region <region> <name>`, `rename_faction <faction> <name>` (bare
  name = key in expanded.txt, "quoted" = literal) and `dump_region_names` (writes <campaign>_regions_and_settlement_
  names.dump.txt), plus Squirrel/Lua scripting (script/*.nut, EOP-Lua plugin). So under REX a campaign script could
  rename on capture by the new owner's culture. Idea (not promised): a per-region table "name for each culture" in the
  tool that writes the expanded.txt keys and the script lines. Not checked: which script event / console_command
  path REX runs from campaign_script.
- **Settlement names by culture BUILT (the user: "do it", 2026-09-29; on main, Unreleased, not in game)**:
  culturenames.py - the table {settlement internal name: {culture | '*': shown name}} lives in the REX Squirrel
  module <mod root>/script/modules/ft_settlement_names.nut (JSON on a `// DATA` line = what the tool reads back;
  the Squirrel below it is generated). REX facts (REX.exe strings + its script/ folder): squi's main.nut requires
  every module from `::scripting.listModules("modules")` (VFS, mod scope over the game's - mod scope root assumed
  = the mod folder next to data, NOT CHECKED); `::events.on("turnChanged"/"campaignMapLoaded", fn)`;
  `::game.factionCount()`, `::game.faction(i)`, `faction.settlementCount`, `faction.settlement(i)`,
  `settlement.owner.cultureId` (ui_cards.nut), `settlement.displayName` (labels); assumed: `faction.cultureId`,
  `settlement.name` (internal), `::game.cultureName(id)` (strings: cultureCount/cultureName), `::game.
  runConsoleCommand(line)` (string listed beside stratText etc.). Console: `rename_settlement <settlement>
  <name>` (bare = expanded.txt key, "quoted" = literal), rename_region, rename_faction, dump_region_names.
  Also a Lua EOP-compat API (eopData/eopScripts/luaPluginScript.lua, M2TWEOP.callConsole, regionStruct,
  factionStruct.cultureID...). **Asked the user to run `dump_docudemon` in REX's console** (it writes the full
  documentation of script commands, conditions, events and console commands to documentation/) and send it -
  then fix the module's calls to the documented names and test in game. Written through regionedit.apply_opts
  (regions['culture_names'], App.culture_names in UNDO_KEYS); refused cultures not in descr_cultures; not REX =
  warning, nothing written. Dialog: Faction tab 'Names by culture...' + Map region bar.
- **Names by culture REWORKED on REX's own documentation (2026-09-29)**: the user sent REX's `dump_docudemon`
  output (documentation/console_commands.txt, docudemon_commands / _conditions / _events.txt - now in tw-game-data
  REX/documentation; the campaign-script reference: commands, conditions, events, console commands). The Squirrel
  module (guessed API) is gone; culturenames.py writes a marked block into the campaign's campaign_script.txt:
  per town and culture `monitor_event SettlementTurnStart|GeneralCaptureSettlement SettlementName <town>` + `and
  FactionCultureType <c>` (the default: `and not FactionCultureType` of every listed one) + `console_command
  rename_settlement <town> "<name>"`, before the script's wait_monitors (added when missing); no script = one made
  (script ... wait_monitors end_script) + `script` / `campaign_script.txt` at the end of descr_strat (as M2's
  campaigns). Table on a `; DATA {json}` line. Names latin-1 only. Not tested in game: that `script` at the end of a
  Rome descr_strat is read (M2 does it), and REX runs it. **The user checked**: REX reads a mod's own folder when the
  bat names it (-mod:<name>), like ours. **New mod folder from bi / alexander**: REX's own bats start them with
  `REX.exe -bi` / `-alx` (not -mod); our fallback bat now adds -bi / -alx for a bi / alexander base (newmod._bats) -
  the cause of the user's bi_Empire_east imperial_campaign errors. Whether `-bi -mod:<name>` together works: to test.
- **The user's direction (2026-09-29): "the program should be built on full REX support, almost depend on it"**
  (earlier he was answered that vanilla / M2 stay supported - this now tilts the priority: REX first). Plan
  proposed: (1) REX's own docs via dump_docudemon -> derived notes in docs/reference; (2) a REX settings panel
  (descr_ex.txt / descr_caps_ex.txt with plain explanations: max_factions, ancillaries, children, ages, sprite_format,
  sources...); (3) use REX features by default where they help (xml sprites - done, scripts - culture names, rename,
  REX's limits); (4) Load says plainly which features need REX when it is missing; (5) vanilla and M2 keep working
  (not dropped) unless he says otherwise.
- **Keep this file current in git** (the user, again 2026-09-29): every point of a conversation - his answers,
  decisions, what was found - goes into CLAUDE.md and is pushed, not only kept in the chat.
- Waiting on him: bi descr_regions.txt to confirm the 0.9.4 fix (M2 modeldb + portraits already received).
- ROADMAP.md is public and kept ticked by us (rule 8 above). Discord text for sharing lives in the chat only.
- **Reviewers** (the user, 2026-09-29): asked about YouTube channel Andy's Take (@AndysTake, strategy / Total War
  reviews). youtube.com and patreon.com are blocked from the session; search only showed Patreon (patreon.com/andystake,
  its Discord for patrons). Contact e-mail and paid-review terms not found - the user checks the About tab himself
  ("View email address" behind a captcha). Advice given: a free, short e-mail with the release link + the video.

## Next

1. User's in-game test: existing armies/fleets/agents in the list (units, remove),
   garrison shown as it stands, empty-town warning; and M3 again after the crash fix (fleets: HLR marks every
   ship a mercenary; vanilla gives ships by culture).
2. (done 0.9.4: the bi manifest is merged into rtw_gold_steam_manifest as bi/..., REX's overlay file left out.)
3. (done in 0.5.0: mod finder, roster) - the user tests Roster and Add line in the game.
4. Slimmed plain-game mods: load them with the game's data as a fallback (see 0.5.0 notes).
5. Run Check mod (deep) on other mods the user sends (only .txt + world/maps).
6. Later: appearance (banners, logos via REX sprite packer,
   recolour), unit/building editors, model viewer, map/region editor.
