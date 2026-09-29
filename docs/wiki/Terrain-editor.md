# Terrain editor

**Terrain editor** at the top paints the campaign map itself, tile by tile.

- **Ground**: low / medium / high fertility, wilderness, sparse and dense forest, hills, mountains, high
  mountains, swamp, and the three kinds of sea.
- **Rivers, fords, cliffs**: rivers, fords (the tiles where armies cross a river), river sources, cliffs, or
  nothing to rub one out.
- **Climates**: the mod's own climates (`descr_climates.txt`, in its colours) - what grows on the campaign
  and battle maps, the snow in winter, the heat that tires men in battle. While this mode is on the map shows
  each land tile in its climate's colour. The sea keeps its climate. A new climate of your own is not in yet.
- **Heights** (`map_heights.tga`): a spray brush. Hold the left button: the land under the brush rises
  (**Raise**) or sinks (**Lower**) the more the longer you hold; the middle of the brush does the most, the
  edge fades out. **Smooth** evens out bumps, **Level to height** brings the land towards the height set
  beside it (a right click picks a tile's own height). The **strength** slider sets how fast. While this mode
  is on the map shows the heights as the file has them: land grey - black low, white high (brightened a
  little so the low land is not all black) - and the sea blue. Only land is changed; the coast stays.

**Find** above the map finds a town, port or character by name. Left drag paints (brush 1-12), right click picks the ground of a tile, right drag moves the map, **Grid** on
or off.

## What it keeps safe

- Land stays land and sea stays sea (the coast is also the regions and the heights - a later step).
- Nothing the game refuses is put under a town, port or character.
- **Rivers**: the game follows a river side to side from where it joins the sea, a river source or another
  river, and stops where two river tiles touch only by a corner - everything past that point is not drawn.
  The 1-tile brush fills such steps itself; **Preview** names every river piece the game will not draw.

## What it writes

**Apply** writes `map_ground_types.tga`, `map_features.tga`, `map_climates.tga` and `map_heights.tga` with a
backup and deletes `map.rwm`, so the game builds its map again on the next start. A heights change also
deletes `map_heights.hgt`: it is the game's own copy of the heights, read instead of the picture while it is
there and never made again by the game - without it the game takes `map_heights.tga`. Restore puts it back.

Painting mountains does not raise the land by itself: ground and heights are separate pictures - use the
Heights brush there too.

*Confirmed in the game on Rome (0.10.0): the campaign loads and the painted ground and rivers are drawn.*

**Undo stroke / Redo stroke** (also the bottom Undo / Redo and Ctrl+Z / Ctrl+Y) step through your strokes.
