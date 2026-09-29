# Terrain editor

**Terrain editor** at the top paints the campaign map itself, tile by tile.

- **Ground**: low / medium / high fertility, wilderness, sparse and dense forest, hills, mountains, high
  mountains, swamp, and the three kinds of sea.
- **Rivers, fords, cliffs**: rivers, fords (the tiles where armies cross a river), river sources, cliffs, or
  nothing to rub one out.

Left drag paints (brush 1-6), right click picks the ground of a tile, right drag moves the map, **Grid** on
or off.

## What it keeps safe

- Land stays land and sea stays sea (the coast is also the regions and the heights - a later step).
- Nothing the game refuses is put under a town, port or character.
- **Rivers**: the game follows a river side to side from where it joins the sea, a river source or another
  river, and stops where two river tiles touch only by a corner - everything past that point is not drawn.
  The 1-tile brush fills such steps itself; **Preview** names every river piece the game will not draw.

## What it writes

**Apply** writes `map_ground_types.tga` and `map_features.tga` with a backup and deletes `map.rwm`, so the game
builds its map again on the next start.

The heights are their own picture (`map_heights.tga`): painting mountains does not raise the land yet - a
heights brush comes next.

*Confirmed in the game on Rome (0.10.0): the campaign loads and the painted ground and rivers are drawn.*

**Undo stroke / Redo stroke** (also the bottom Undo / Redo and Ctrl+Z / Ctrl+Y) step through your strokes.
