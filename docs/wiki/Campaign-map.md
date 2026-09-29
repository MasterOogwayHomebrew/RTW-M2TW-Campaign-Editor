# Campaign map

The **Map** tab draws the campaign map tile by tile from the game's own map files: one square = one tile.
Big maps load too - a tester's mod with a map of 5456 x 2464 tiles (map_regions.tga pixels; vanilla Rome is 255 x 156) opened fine.

## Looking around

- Wheel zooms, left drag moves the map.
- **Find**: type part of a name - a town (also the name shown for its owner), a port, a general, agent or
  fleet, a unit in an army (e.g. "hastati"), a fort, a resource. Pick a hit (click, or Down then Enter) and
  the map zooms in close on it and a ring blinks round it for a few seconds.
- **Layers**: political colours, borders, diplomacy colours, relief, rivers, a tile grid when zoomed in.
- The line under the map describes the tile under the mouse: region, owner, ground, and whether an army may
  stand there.

## Towns and characters

- A click on a town adds it to **Chosen** or takes it out.
- A right drag (or Ctrl + left drag) moves characters, towns and ports. The target turns green or red: an
  army needs land it may stand on (no sea, mountains, dense forest, river, ford or cliff) or a town no other
  army holds; a fleet needs sea; an agent any land.
- **Moving a town or port** repaints its pixel in `map_regions.tga`, moves the characters in it, and deletes
  `map.rwm` - the game builds it again on the next start (the first start takes a little longer).

## Forts

Forts and watchtowers of `descr_strat.txt` (Medieval II, REX: `fort x y ... permanent name ...`) are drawn as small
towers, the top in the owner's colour; the mouse over one shows its name and whether it is permanent. No army or
agent is placed on a fort's tile.

## New regions

Tick **Regions**: every region in its own colour.

1. **New region...**: names, builder, rebels, region tags (hidden resources), triumph, farming, owner,
   settlement level. The tool picks an unused colour.
2. Paint its land with a left drag (brush 1-6 tiles). Right click a region to paint with that one - the same
   brush moves the border between two existing regions.
3. **Place its town** (and **Place its port** on the coast).
4. **Preview** lists everything written: `map_regions.tga`, `descr_regions.txt`, the name lookup, the region
   labels, the settlement, `map.rwm` removed.

A new region is in the towns list at once: a new faction can start there, and an edited one can take it, all
in one Apply. **Edit region...** opens a region's data again.

## Resources

Trade goods on the map can be placed, moved and removed; one per tile.

## Medieval II

Religions per region (**Religions...**); castles; agents such as merchants, priests and princesses.

**New religion...** (Map tab, Regions) adds a religion of your own - e.g. Judaism - everywhere the game needs
it: descr_religions.txt (its name and symbol), descr_religions_lookup.txt, text/religions.txt (without its
text the game crashes silently), its symbol in ui/pips (your picture as a 24-bit TGA, or a copy of another
religion's), and every region's religions line at 0 %. Then give it its share per region with **Religions...**
(each region adds up to 100) and, if you like, the factions that follow it. The game takes at most 9 religions
(vanilla has 5). Temples, priests and traits of its own are not made - Preview says which files still name
only the old religions.

## Settlement names by culture (REX / M2EX)

**Names by culture...** (next to *Edit region...* on the Faction tab, and on the Map's region bar) gives a town a
name for each culture of its owner, plus a name for every other culture. The engine (REX on Rome, M2EX on
Medieval II) renames the town when it changes
hands - as soon as a general takes it, and at each of its owner's turns. The tool writes it into the campaign's
`campaign_script.txt` (it makes one when the campaign has none; a script of the mod's own stays as it is around the
tool's block), with a backup like every write. Needs REX (Rome) or M2EX (Medieval II; written the same way, not
yet checked in that game).

The window shows it at once: take a town for a faction (on the Faction tab or by clicking it on the Map) and its
label on the map changes to the name for that faction's culture; the towns list shows the name a town has now.

**All towns' names...** (on the Faction tab, in the per-town dialog and under **Tools**) shows every town in one
table: one column per culture plus *every other*, the owner, its culture and the name shown now. Sort by any
column, filter by a culture (towns with or without a name for it), by the owner's culture, by what waits for Apply,
or search. Double click a culture's cell to type a name in place (Enter keeps it, Esc drops it, an empty cell
removes it). Towns the mod's own campaign script renames are shown grey and are not edited here.
