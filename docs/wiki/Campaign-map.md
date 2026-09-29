# Campaign map

The **Map** tab draws the campaign map tile by tile from the game's own map files: one square = one tile.

## Looking around

- Wheel zooms, left drag moves the map.
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
