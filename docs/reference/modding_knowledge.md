# Rome: Total War and Medieval II modding knowledge

What twenty years of modders found out about the two games' files: limits, what crashes, map rules, the tools
people use. Collected 2026-09-29 for RTW & M2TW Campaign Editor, to decide what the tool must check and build.

**How it was collected.** Round 1 (2026-09-29, network closed) and round 2 (2026-09-29, network open:
twcenter.net, its wiki, forums.totalwar.org, moddb and reddit still answer every request with a Cloudflare bot
check, even in a real browser - not bypassed; **rtw.heavengames.com and medieval2.heavengames.com read in full**
- all 30 RTW tutorials incl. Ferret's "A List of Known Hardcodes" and the 6 M2TW ones -, steamcommunity threads
and web search excerpts of the TWC pages). The facts come from:
- web search excerpts of those pages (each fact names the page);
- the open source of **Medieval 2 GUI Toolkit** (github.com/ProJ-Yeet/Medieval2-GUI-Toolkit, no licence stated:
  facts about the game only, no code taken). Its authors measured every rule on two big shipping mods (Divide
  and Conquer, ROCSS) and keep the source of each: TWC's "GUIDE - Crashes and how to fix them", "Crash to
  Desktop (TWC Wiki)", Mylae's and Gigantus's map rules, TWMapReader, Geomod, IWTE's authors on Discord;
- the user's own vanilla files (RTW-game-data, M2TW-game-data) and in-game tests - the tool's Hard-won rules
  in CLAUDE.md, which win over anything here.

A fact marked *(said)* comes from one source and was not measured; *(measured)* was checked on real files.

---

## 1. Engine limits

| Limit | Rome (original exe) | Medieval II (original exe) | Lifted by |
|---|---|---|---|
| Factions (with the rebels) | 21 (BI 31?) | 31 | REX / M2EX `max_factions` in descr_ex.txt (measured, in-game) |
| Regions (the sea counts as one) | 200 | 199-200; DaC sits at the cap | REX: no cap found (HLR 300+ run) |
| Factions shown on the campaign-select screen | 20 (so slave playable means one other left out) *(heavengames)* | | |
| map_regions.tga size | **500 x 500** (descr_terrain; the 2W+1 maps up to 1001 x 1001) *(heavengames)* | vanilla 295 x 189, **510 x 510** (2W+1 maps 1021 x 1021) *(TWC wiki)* | ? - a tester's 5456 x 2464 map loaded in our tool; in game unknown |
| Landmasses (islands) | 20 *(heavengames)* - **doubtful: vanilla RTW's map_regions has 32 side-joined land pieces and runs** (measured), so the game counts something else; not checked by the tool | many islands of different regions cause map faults *(TWC wiki)* | |
| Hidden resources (EDB `hidden_resources` line) | 63 (64 risky) *(heavengames)*; vanilla uses 4 | 64 *(TWC wiki)*; vanilla uses 17 | a TWC tutorial goes past 64 |
| Resource types (descr_sm_resources) | vanilla 26 | 26 said *(TWC wiki)* - but vanilla M2TW has **28** `type` entries (measured), so the number is doubtful | |
| Character types (descr_character) | | 12 | |
| Cultures | 6 vanilla (+ BI nomad, hun), HLR 11 under REX | **7** *(TWC wiki)* | REX: cultures unlimited (README) |
| Units in export_descr_unit | 500 (vanilla 265) | 500 (a table in the exe; vanilla 413) | M2EX lifts the unit count *(Toolkit)* |
| Units a faction may own | 100 - more only drop out of custom battles *(heavengames)* | not checked | |
| Units recruitable in one town | 32, agents not counted, more = CTD *(heavengames)* - the game's cap on what one town offers, not on recruit lines in one level (HLR has 702 in a capability) | | |
| Building chains (trees) | 64, more = CTD (vanilla 39) | 128 (vanilla 64) | |
| Levels per chain | 9 | 9 | |
| Levels per trait | 9 | | |
| Trait threshold points / points per trigger | 600 / 100 *(heavengames)* | | |
| Kinds on a trait's `Characters` line | only the first works *(heavengames, RTW)*; vanilla RTW has 2 `spy, assassin` traits | lists of several kinds in vanilla (6 traits) - they work | |
| Antitraits per trait | 10 (1.2) / 20 (1.6) *(said)* | | |
| ExcludedAncillaries | 3, more = crash *(said)* | | |
| Religions | none in vanilla | **9** (5 in vanilla: catholic, orthodox, islam, pagan, heretic) *(said, confirmed in game by a modder)*; the TWC wiki says 10 | REX's README: religions unlimited |
| Men per unit | 12 to 60 (normal scale), more = CTD *(heavengames)* - **not true for M2TW** (300 DaC units exceed it) | 4 to 100 | |
| Attack / charge / armour / defence | 63 (more read as 63) | attack 63 | |
| Shield | 31 (more read as 31) | | |
| Turns to build a unit | 1 to 244 | | |
| Collision mass | 100 | | |
| armour / weapon_lvl in descr_strat | 0 to 3 | | |
| Model faces | 20,000 per model *(heavengames)* | | |
| stat_health | | 0 to 15 | |
| Officers per unit | 2 in vanilla files | 3 | |
| Mount effects | | 3 | |
| Formations | | 2: one of square / horde, one of shield_wall / phalanx / schiltrom / wedge | |
| Memory | | 2 GB unless the exe is Large Address Aware (the common cure of mod crashes) | |

Sources: rtw.heavengames.com "A List of Known Hardcodes" (Ferret) and "Adding New Regions" (SubRosa), TWC
"Hardcoded Limits - M2TW" wiki (via search excerpt), TWC "Hardcoded Limits - RTW/M2TW" wiki pages, heavengames "A List of Known Hardcodes", TWC "The
Hardcoded List", Toolkit `educeil.py` (sourced to "A Beginner's Guide to the Export_Descr_Unit (M2TW)" and "M2TW
Ultimate Docudemons 5.3"), .Org "Adding a new religion", TWC "Crashes and how to fix them".

## 2. What crashes the game (by file)

| Where | What | Game | Our tool |
|---|---|---|---|
| descr_strat | a name not in the name list | both | refused (Hard-won rules) |
| descr_strat | two characters of a faction with one name (skipped) | both | refused |
| descr_strat | a character on sea / mountains / river / ford / cliff | both | refused |
| descr_strat | a character after the family tree | both | refused |
| descr_strat | a **living male `character_record` older than 16** (he should be on the map): crash *(heavengames Descr_Strat Reference)*. Vanilla keeps to it: RTW 0 of 74, M2TW 0 of 21 living male records are over 16 (measured) | both | **NOT checked - the Family tab adds sons at parent's age - 20 and new records at 20 by default** |
| descr_strat | a `relative` line without its closing `end`: the next line is read as a child, crash | both | written by us with `end` |
| descr_strat | a name on a `relative` line that is neither a character nor a record of the faction | both | tree_problems refuses |
| descr_strat | a captain's name must be a first name only, from names.txt | RTW | captains take first names |
| descr_strat | playing the Senate / the rebels and opening the faction summary (Senate tab): crash - hard-coded | RTW | slave is never made playable |
| descr_strat | spacing unlike the original's "may crash" | RTW | we write the file's own form |
| descr_strat | a faction's `ai_label` that descr_campaign_ai_db.xml does not declare (`papal_faction` is built in) - crash in that faction's turn | M2TW | **not checked** |
| descr_regions | a region whose colour does not match map_regions.tga (the most common map crash) | both | new regions get their own colour; **no whole-map check** |
| descr_regions | every region needs the `slaves` resource (all 103 vanilla RTW regions have it, measured) - **but HLR's 750 regions have none and run under REX**, M2TW does not use it | RTW | Check mod: warns only when the mod's other regions have it |
| descr_rebel_factions / descr_regions | a rebel type whose units the slave faction may not own: crash *(TWC "Crashes and how to fix them")*. Vanilla M2TW / BI: 0 such units; vanilla RTW has 5 (roman ones) and runs - so M2TW only | M2TW | Check mod |
| descr_win_conditions | a region that does not exist: CTD when that faction is played | M2TW | Check mod (hold_regions, outlive) |
| descr_regions | a region too large: crashes; keep regions one landmass, centres of neighbours <= 50 tiles apart *(TWC wiki)* | M2TW | not checked |
| descr_regions | religion shares not summing to 100 | M2TW | **not refused everywhere** (new regions: see CLAUDE.md item 22) |
| descr_regions | triumph value other than 5 "may crash" (Geomod manual); farming 4 average, 6-7 fertile | M2TW | not checked |
| descr_regions | a region with no settlement (wasteland short form) must be the LAST entry | M2TW | not checked |
| descr_regions | DaC writes a `legion:` line: ten lines, not nine | M2TW mods | **our reader would take it as the rebels line** |
| religions | a religion with no text in text/religions.txt: crash with no message | M2TW | - |
| religions | a pip picture in 16 or 32 bit fails; 24-bit works *(said)* | M2TW | - |
| EDU | a mercenary_unit with no `merc` texture line in descr_model_battle, or an owner with no texture line | RTW | clone copies texture lines; **Roster Give adds no texture line** |
| EDU | a second weapon without its skeleton: crash when the mouse reaches the unit | RTW | not checked |
| EDU | animals (pigs, dogs) with a mount, or on a unit that needs a secondary attack (missile, phalanx) | RTW | not checked |
| EDU | a unit with no ownership for the faction cannot be recruited even with a recruit line | both | Roster keeps ownership + recruit in step |
| descr_model_battle | a texture baked into the .cas model that is missing: crash naming the file, whatever the texture line says | RTW | packs carry the model's files |
| ancillaries | the info part and the trigger part of export_descr_ancillaries in different orders, or text moved across the divider: crash | RTW | we never reorder |
| mod folder | a mod:switch folder that lacks the base files: the campaign fails back to the menu; models / textures in descr_model_battle, descr_model_strat, descr_sm_factions, descr_sm_resources, **descr_standards**, descr_banners need `../<mod>/data/` paths on the original exe | RTW | New mod folder copies / links everything; REX reads the mod folder itself |
| unpacker | after the 1.2 unpacker descr_geography_new.txt / .db crash every battle (timestamp) and must go; a missing DLL = copy the game's .dll files next to the unpacker *(heavengames)*. The user's Steam M2TW keeps both geography files and runs, so it is a 1.2-era rule | M2TW | gamefix.unpack copies msvcp71 / msvcr71 |
| EDB / EDU | a name that cannot be found (the log names it) | both | line checks refuse unknown units / chains |
| EDB | a building level with no text key: crash at the construction panel | M2TW | clone copies texts; **new levels not checked** |
| traits | a trait and its antitrait excluding different cultures: crash when one replaces the other | M2TW | not checked |
| ancillaries | an ancillary a trigger names but the file no longer defines: crash when it fires | M2TW | not checked |
| campaign_script | `historic_event X` with no {X_TITLE} / {X_BODY} text - crash when it fires (case does not matter in practice) | M2TW | not checked |
| battle files | absolute paths (C:\...) in descr_banners_new.xml, descr_projectile, descr_standards: crash once the folder moves | M2TW | not checked |
| battle_models.modeldb | 3+ spaces in a row on a line (paths with spaces aside) | M2TW | modeldb.py writes the file's own form |
| map | a settlement pixel on sea, impassable land, river, ford, source or volcano: back to the menu | both | moving towns refuses river / sea |
| map | a settlement or port pixel touching another region's pixel, even at a corner | M2TW | **not checked** |
| map | a region colour with no pixels, two regions with one colour, a colour nobody declares | M2TW | new regions get a free colour; **no check of a whole map** |
| map | a town on inaccessible land (a mountain top): crash on a new campaign | both | refused |
| map | too many rivers in one region: crash when the mouse passes over it *(TWC wiki)* | M2TW | not checked |
| map | feral_radar_map.tga of the wrong size (1020 x 624) *(TWC wiki)* | M2TW | not written by us |
| map | TGA descriptor byte 0x18 / 0x20 crashed M2TW; 0x08 / 0x00 work (TWMapReader) | M2TW | we keep each file's own header |
| text | map changes are not seen until map.rwm is deleted | both | we delete it |

## 3. Campaign map rules (Medieval II, mostly true for Rome)

- Layer sizes: map_regions, map_features, map_trade_routes W x H; map_roughness 2W x 2H; map_heights, map_fog,
  map_ground_types, map_climates 2W+1 x 2H+1. A tile reads the centre pixel (2x+1, 2y+1).
- descr_strat y counts from the bottom: game_y = H - 1 - image_y.
- Sea: the map_heights pixel is not grey, or pure black (TWMapReader; agrees with ground types on 99.9 % of DaC).
  Ours: a map_regions colour no region owns - close enough for placing characters.
- One black settlement pixel and at most one white port pixel per region; a port needs sea beside it. Port owner:
  the four side neighbours decide.
- Rivers (heavengames, Hussarknight - RTW): side-to-side steps only (a staircase for a diagonal); **no 2 x 2
  square of river**; a river may split but **never rejoin itself** (no loop around land); never on the sea; white
  = where it starts and decides the flow; cliffs may go diagonal and form squares. Our river_warnings checks only
  the corner-only joins so far.
- Rivers (M2TW sources): side-to-side steps only (no corner-only joins - our river_warnings), no loops, no four-way crossings,
  a white source pixel where one starts, two pixels past the coast, a ford never in open sea. A bridge under a
  steep tile floats in the battle (the battle map averages the 5 x 5 tiles around it).
- 16 ground colours, 7 feature colours; climate colours come from descr_climates.txt.
- Region numbers are the order of first appearance scanning map_regions row by row.
- New region, RTW (SubRosa): map_regions colour + black town (+ white port on the coast), descr_regions (8 lines,
  names with _; resources must include slaves; triumph value unused), descr_strat settlement,
  descr_regions_and_settlement_name_lookup, <campaign>_regions_and_settlement_names, optional
  rebel_faction_descr + descr_rebel_factions, descr_mercenaries pool, map.rwm deleted - the same list as our
  regionedit (checked).

## 4. Religions (Medieval II) - for the "new religion" feature

A religion is written in several places that must agree (Toolkit `minorfiles.py`, geeko's "How to add a
religion", .Org "Adding a new religion"):
1. `descr_religions.txt`: the name in the `religions { }` list (the set the engine reads) and its own
   `religion <name> { pip_path ui/pips/pip_<name>.tga }` block;
2. `descr_religions_lookup.txt`;
3. `text/english/religions.txt` - missing = silent crash;
4. `ui/pips/pip_<name>.tga` - 24-bit;
5. `world/maps/base/descr_regions.txt`: each region's `religions { ... }` shares, summing to 100;
6. then delete map.rwm.
Optional, for the religion to mean something: `descr_sm_factions.txt` `religion` of factions, temples and
religion requirements in export_descr_buildings, traits / ancillaries naming religions, descr_mercenaries
(religion-gated mercenaries), priests, descr_faction_standing, descr_campaign_ai_db.xml.
Limit: 9 religions. Shipping mods get it wrong: Third Age misses one name, its lookup lists three dead religions.

## 4b. Faction symbols (Rome) - what the files say about our flag slots

- descr_standards.txt lists the banner sheets in two lists: `factions` and `rebels_factions` (heavengames
  "How To Change The Symbols Of A Faction"; mod:switch mods repoint these paths). The user's files (measured):
  RTW data = factions symbols1-5, rebels_factions symbols6-8; **BI = factions symbols9-13, rebels symbols14-15**;
  the pictures agree - sheets 1-5 hold 20 coloured faction symbols, 6-8 black rebel symbols (trident, scarab...).
- vanilla RTW standard_index 0-19 = the 20 factions, slave = 20 (the first rebel symbol, symbols6 top left);
  descr_cultures rebel_standard_index 0-5 per culture.
- **So symbols.py is wrong in two ways** (not yet fixed, to test in game): (1) it takes the sheet as
  symbols<k//4+1>, but the game takes the sheet from descr_standards' list - on BI that is symbols9+, not
  symbols1+; (2) free_slot gives a new faction index 21 = symbols6 top right, a **rebels'** sheet: the new
  faction's symbol is pasted over a rebel culture's flag (or the game shows nothing, if faction slots stop at
  the factions list). The original exes seem to have 20 faction slots (5 sheets; BI shares slots between a
  faction and its shadow). Fix to build: read descr_standards; a new faction takes a free slot inside the
  factions sheets, else (REX) a new sheet appended to the factions list, else shares the template's slot with a
  plain warning; never write into a rebels sheet.
- Other symbol files a faction has (heavengames): loading_screen/symbols/symbol128_<f>.tga (128 x 128),
  menu/symbols/FE_buttons_24 (30 x 30) and _48 (59 x 59) symbol24|48_<f>[_grey|_roll|_select].tga (Roman
  factions by romans_<x> names), ui/captain_banners/captain_card_<f>.tga + captain_portrait_<f>.tga (+ dead/),
  models_strat symbol_<f>.cas + textures/#banner_symbol_<f>.tga.dds (empty-town banner), battle banners
  models/textures/standard_<f>[_ally].tga.dds + standard_routing_<f> (descr_banners), city-wall banners
  models_building/textures/##standard_<f>.tga.dds listed in descr_building_battle; unit cards 48 x 64
  ui/units/<f>/#<dict>.tga and 160 x 210 ui/unit_info/<f>/<dict>_info.tga.

## 5. Tools modders use

| Tool | Game | What |
|---|---|---|
| **Medieval 2 GUI Toolkit** (ProJ-Yeet, GitHub, JS + Python, local web page) | M2TW | unit transfer between mods (models, animations, textures, mounts, voices), unit / model (3D view) / building / trait / guild / faction / strings / minor files editors, campaign map (beta), Health check (45 rules), backups + undo. **The closest thing to us - on Medieval II only.** |
| IWTE (makanyane, GitHub) | RTW, RR, M2TW | battle-map buildings, meshes, textures, skeletons |
| Bare Geomod + Geomod | M2TW | a clean mod folder with bug fixes; map building |
| M2TWEOP (EOP-Labs, GitHub) | M2TW | engine extender, Lua scripting (M2EX is its launcher build) |
| REX (Pannoniae) | RTW | 64-bit engine, limits lifted, Squirrel scripting |
| Medieval 2 Blender Toolkit (WK-313) | M2TW | models, modeldb browser, export checks |
| Return of XIDX, IDX / Pak extractors | RTW | unpacking sounds, animations |
| Rome_Total_War_Modding_Tools (DavidArabuli), Rome-Total-War-Tools-and-Features (Dagovax) | RTW | small editors and scripts |
| FeralInteractive/romeremastered | Rome Remastered | the official modding docs |

## 6. What this means for the tool (gaps, most useful first)

0. **Round 2 finds - BUILT 2026-09-29 (a, b, d, e; c/f as Check mod LIMITS)**: (a) Family tab: a living male record over 16 - refuse or warn, and
   make new sons / records default to <= 16 (else to the map); (b) flag slots: read descr_standards (section 4b);
   (c) map limits 500 x 500 (RTW) / 510 x 510 (M2TW) and 20 landmasses before a rescale or a new map; (d) river
   brush: warn on 2 x 2 squares and loops; (e) Check mod: regions without slaves (RTW), rebel types with units
   slave cannot own, win conditions naming missing regions; (f) limits shown up front: 32 units per town,
   hidden resources 63 / 64, chains 64 / 128, units 500.
1. **Check mod gets the crash rules above** that no screen checks yet: ai_label declared, religions sum 100,
   wasteland last, historic_event text, antitrait cultures, dead ancillaries in triggers, absolute paths,
   a town touching another region, map colour faults. Each with the game's own words and the fix.
2. **descr_regions `legion:` lines** (DaC and other mods): read them as their own field, never as rebels.
3. **Roster Give / new owners get texture lines** in descr_model_battle (RTW crash otherwise), like unit packs.
4. **New religion (M2TW)** - section 4.
5. **Limits shown up front** from section 1 (units 500, chains 64 / 128, levels 9, religions 9): count them on
   Load and warn before a write would cross one, like the faction limit.
6. Later, in line with what modders ask: shadow / emergent factions, heights brush + 3D view, unit transfer
   parity with the Toolkit on M2TW (animations, voices), Rome's equivalents the Toolkit does not cover.

## 7. Measured on the user's files (2026-09-29, round 2)

- River shapes: vanilla RTW base, sons_of_mars, M2TW base, norman_prologue - 0 2 x 2 blocks, 0 rings; HLR
  imperial_campaign - 0 blocks, 6 rings (it runs), so rings are a soft warning.
- HLR has **750 regions** in descr_regions.txt under REX (limits: the original 200 does not hold for REX).
- Limits used by vanilla: RTW 104 regions (with the sea), map 255, 265 units, 39 chains, 5 levels, 3 hidden
  resources; M2TW 113 regions, map 295, 413 units, 64 chains, 7 levels, 16 hidden resources.
- REX descr_ex.txt `max_age_of_child 10` ("age a child character becomes an adult") - yet vanilla living male
  records go up to 15 (RTW, HLR) / 14 (M2TW) and run under REX, so it is not the crash line; no record is 16.
- Names by culture: REX's documentation has FactionCultureType, SettlementName, SettlementTurnStart,
  GeneralCaptureSettlement and rename_settlement (Rome build). M2EX's own documentation is not here yet -
  ask the user to run `dump_docudemon` in M2EX's console and send the documentation folder.
