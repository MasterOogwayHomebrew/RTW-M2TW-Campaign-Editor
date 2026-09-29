# Rome: Total War and Medieval II modding knowledge

What twenty years of modders found out about the two games' files: limits, what crashes, map rules, the tools
people use. Collected 2026-09-29 for RTW & M2TW Campaign Editor, to decide what the tool must check and build.

**How it was collected.** The forums themselves (twcenter.net, its wiki, forums.totalwar.org, heavengames,
moddb, steamcommunity) are not reachable from the work container, so the facts come from:
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
| map_regions.tga size | - | vanilla 295 x 189, 510 x 510 said to be the limit *(said)* | ? |
| Units in export_descr_unit | 500 | 500 (a table in the exe) | M2EX lifts the unit count *(Toolkit)* |
| Units a faction may own | 100 *(said, RTW)* | not checked | |
| Units recruitable per town | 32 *(said, RTW)* | | |
| Building chains (trees) | 64 | 128 | |
| Levels per chain | 9 | 9 | |
| Levels per trait | 9 | | |
| Antitraits per trait | 10 (1.2) / 20 (1.6) *(said)* | | |
| ExcludedAncillaries | 3, more = crash *(said)* | | |
| Religions | none in vanilla | **9** (5 in vanilla: catholic, orthodox, islam, pagan, heretic) *(said, confirmed in game by a modder)* | REX's README: religions unlimited |
| Cultures | 7 vanilla, HLR 11 | not limited as far as known | |
| Men per unit | RTW table says 60 - **not true for M2TW** (300 DaC units exceed it) | 4 to 100 | |
| Attack / charge / armour | 63 (field width) | attack 63 | |
| stat_health | | 0 to 15 | |
| Officers per unit | 2 in vanilla files | 3 | |
| Mount effects | | 3 | |
| Formations | | 2: one of square / horde, one of shield_wall / phalanx / schiltrom / wedge | |
| Memory | | 2 GB unless the exe is Large Address Aware (the common cure of mod crashes) | |

Sources: TWC "Hardcoded Limits - RTW/M2TW" wiki pages, heavengames "A List of Known Hardcodes", TWC "The
Hardcoded List", Toolkit `educeil.py` (sourced to "A Beginner's Guide to the Export_Descr_Unit (M2TW)" and "M2TW
Ultimate Docudemons 5.3"), .Org "Adding a new religion", TWC "Crashes and how to fix them".

## 2. What crashes the game (by file)

| Where | What | Game | Our tool |
|---|---|---|---|
| descr_strat | a name not in the name list | both | refused (Hard-won rules) |
| descr_strat | two characters of a faction with one name (skipped) | both | refused |
| descr_strat | a character on sea / mountains / river / ford / cliff | both | refused |
| descr_strat | a character after the family tree | both | refused |
| descr_strat | a faction's `ai_label` that descr_campaign_ai_db.xml does not declare (`papal_faction` is built in) - crash in that faction's turn | M2TW | **not checked** |
| descr_regions | religion shares not summing to 100 | M2TW | **not refused everywhere** (new regions: see CLAUDE.md item 22) |
| descr_regions | triumph value other than 5 "may crash" (Geomod manual); farming 4 average, 6-7 fertile | M2TW | not checked |
| descr_regions | a region with no settlement (wasteland short form) must be the LAST entry | M2TW | not checked |
| descr_regions | DaC writes a `legion:` line: ten lines, not nine | M2TW mods | **our reader would take it as the rebels line** |
| religions | a religion with no text in text/religions.txt: crash with no message | M2TW | - |
| religions | a pip picture in 16 or 32 bit fails; 24-bit works *(said)* | M2TW | - |
| EDU | a mercenary_unit with no `merc` texture line in descr_model_battle, or an owner with no texture line | RTW | clone copies texture lines; **Roster Give adds no texture line** |
| EDU | a second weapon without its skeleton: crash when the mouse reaches the unit | RTW | not checked |
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
- Rivers: side-to-side steps only (no corner-only joins - our river_warnings), no loops, no four-way crossings,
  a white source pixel where one starts, two pixels past the coast, a ford never in open sea. A bridge under a
  steep tile floats in the battle (the battle map averages the 5 x 5 tiles around it).
- 16 ground colours, 7 feature colours; climate colours come from descr_climates.txt.
- Region numbers are the order of first appearance scanning map_regions row by row.

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
