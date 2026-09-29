# Roadmap

Where RTW & M2TW Campaign Editor stands, what comes next and what each step needs.
Ticked = built and released; **(in-game ✓)** = also confirmed in the game. Updated with every release
(see [CHANGELOG.md](CHANGELOG.md) for the details).

Found a bug or a crash? Send the logs (**Tools → Save logs (zip)**) and a screenshot or a short video -
that is the fastest way to a fix.

## Where it started

Version 0.1: a small script for one mod (Barbarian Empires REX on Rome: Total War) that cloned a faction
from a template - texts, units, buildings, start towns, leader. Rome only, command line first.

## What it does now (0.11.0)

### Factions
- [x] New faction from a template: names, texts, colours, units, buildings, cards, name lists, traits, art **(in-game ✓)**
- [x] Faction limit known and raised with a yes (REX / M2EX `max_factions`) **(in-game ✓ on Rome + REX)**
- [x] Edit an existing faction: names, texts, colours, AI, money, playable, towns taken or given, capital, leader and heir **(in-game ✓)**
- [x] Garrisons and buildings per town, with the game's own cards and pictures **(in-game ✓)**
- [x] Settlement level and population (the governor's building follows the size)
- [x] Diplomacy: attitudes and starting relations with every other faction
- [x] Roster: give or take units and building levels (ownership, recruit lines and cards kept in step)
- [x] A separate mod folder in one click (the base mod stays untouched) **(in-game ✓)**

### Campaign map
- [x] The map drawn tile by tile from the game's own map files; political, diplomacy and region colours **(in-game ✓)**
- [x] Characters on the map: drag to move, new armies, agents and fleets placed by clicking
- [x] Move towns and ports (roads and sea routes follow) **(in-game ✓)**
- [x] Paint new regions and move borders **(in-game ✓ on HLR)**
- [x] Edit a region's data (builder, rebels, tags, triumph, farming), new or existing
- [x] Map changes, new regions and faction changes written together by one Apply
- [x] Resources placed, moved and removed; religions per region (Medieval II)
- [x] Terrain editor: paint ground types, rivers, fords, river sources and cliffs tile by tile **(in-game ✓ on Rome)**
- [ ] Terrain editor: paint climates (`map_climates.tga`, the mod's own climates) - built, next release
- [x] Rivers kept joined side to side (the game stops a river at a corner-only step); Preview names a river the game will not draw

### Characters
- [x] Character editor for any faction: names, ages, traits with levels, ancillaries
- [x] Family tree drawn like the game's (couples, children, leader and heir); give a wife, add a child, rename (followed on the tree)
- [x] Portraits on the tree as the game shows them; Medieval II characters get portraits of their own
- [x] Portrait library: every portrait of a culture, add new ones (sized and numbered for the game)

### Units, buildings, art
- [x] Unit and building editors: every line as a field, add / remove lines, copy as new, renames followed everywhere
- [x] Pictures imported into the right place in the right size and format (cards, building pictures, faction art)
- [x] Unit packs: export units with models, textures, mounts, cards and texts into a .zip and import them into another mod
- [x] Faction art: every picture of a faction listed with where the game shows it, Replace... **(in-game ✓)**; a new faction's banners and logo are its own files; Back to the original
- [x] Campaign-select map drawn from the faction's towns (optional; the original stays by default)

### Both games
- [x] Rome: Total War, Barbarian Invasion, Alexander - plain or on REX **(in-game ✓)**
- [x] Medieval II and Kingdoms - plain or on M2EX: unpacking offered, set-up fixes, castles, `mods/<name>` with its .cfg

### Safety
- [x] Preview of every file and line before writing; only the lines meant change, the rest stays byte for byte
- [x] A backup of every write; Restore gives the original back byte for byte; Undo / Redo in the window
- [x] Check mod (consistency report), Scan mod (every mention of a faction; game, REX and mod files told apart)
- [x] Log, Save logs (zip) for bug reports; Light / Dark look

## Being tested in the game now

- [ ] Family tab and Character editor, own portraits (Medieval II), portrait library
- [ ] Edit region; a new faction starting in a new region in one Apply
- [ ] Medieval II castle fix (0.7.5), unit packs, new armies / agents / fleets on the map
- [ ] Barbarian Invasion campaign loading (0.9.4 fix); BI's shared name lists and building pictures (next release)
- [ ] Restore any backup together with every later one in one go (next release)

## Next

| Step | What it needs |
|---|---|
| Signed exe (no browser / SmartScreen warnings) | SignPath Foundation's answer (applied) |
| Terrain: heights brush (raise, lower, smooth), mountains and hills kept in step with the heights | Time; an in-game test |
| Terrain: a tilted 3D-like preview from the heights and ground | Time |
| Terrain: the coast (land and sea swapped, with regions and heights); a new climate of one's own | Time; in-game tests |
| A new campaign map from scratch (one region, one faction, loads in the game), then grown in the editor | Time; in-game tests |
| Medieval II: new factions' units in `battle_models.modeldb` | The game's `data/unit_models/battle_models.modeldb` to build and test on |
| Faction packs and building packs (like unit packs) | Time; then an in-game test |
| Mods made on the plain game (slimmed folders) loaded with the game's data behind them | Time |

## Later

| Step | What it needs |
|---|---|
| A culture of its own (buildings, settlements, sounds that follow it) | Whether REX / M2EX limit the number of cultures |
| Rescale the whole campaign map (e.g. 2x, with towns, armies and resources moved along) | The map size limits of REX and M2EX; in-game tests |
| Strat-map flags and banners of a new faction | Writing DXT textures |
| Unit texture recolour to a faction's colours; a model viewer | Texture and model files to work on |
| Rome characters with portraits of their own | Whether REX reads a `portrait` line |
