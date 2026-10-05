# Terrain editor

The **Terrain** tab of the **Map editor** (beside its Map) paints the campaign map itself, tile by tile.

**Videos:** [editing rivers, fords, cliffs](https://youtu.be/z0T723riXaU) · [editing a height map](https://youtu.be/mTdRAWympuw) (both checked in the game on Rome
and Medieval II).

- **Ground**: low / medium / high fertility, wilderness, sparse and dense forest, hills, mountains, high
  mountains, swamp, and the three kinds of sea; **impassable land** and **impassable sea** (no army walks or sails
  there - Medieval II, whose map is full of them; Rome only with REX, which knows these ground types - not yet
  tried in the game on Rome).
- **Rivers, cliffs, volcanoes...**: rivers, fords (the tiles where armies cross a river), river sources, cliffs,
  volcanoes, land bridges (Medieval II: armies walk across a narrow strait like the Bosporus - a straight strip of 3
  tiles: land, sea, land; Preview names a bent or broken one), or
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

![Land and sea: a new island in the Black Sea](https://raw.githubusercontent.com/MasterOogwayHomebrew/RTW-M2TW-Campaign-Editor/main/docs/images/land_and_sea.png)

## What it keeps safe

- **Land and sea**: turn sea into land (a new island, a longer coast) or land into sea (a bay, a strait). Land and
  sea are written in three places that must agree, so each tile changes all of them: `map_regions.tga` (the
  region's colour or the sea's), `map_ground_types.tga` (a land ground like its neighbours', or shallow sea; new land gets a ring of shallow sea:
  the 8 sea tiles round it that are deeper turn shallow) and
  `map_heights.tga` with `map_heights.hgt` (new land rises from a low shore inland as the games' own coasts do -
  2, 8, 12, 14, then 16 grey steps from the sea - so an island never lies flat on the water; new sea: the sea's
  depth). New land joins the region of the
  nearest land, or the one picked in *new land joins*; move borders later on the Map (Regions). Refused: drowning a
  town, port, character, fort or resource, a region's last land, a river (rub it out first) or a port's last land.
  The Ground brush keeps land as land and sea as sea.
- Nothing the game refuses is put under a town, port or character.
- **Rivers**: the game follows a river side to side from where it joins the sea, a river source or another
  river, and stops where two river tiles touch only by a corner - everything past that point is not drawn.
  The 1-tile brush fills such steps itself; **Preview** names every river piece the game will not draw.

## What it writes

**Apply** writes `map_ground_types.tga`, `map_features.tga`, `map_climates.tga` and `map_heights.tga` with a
backup and deletes `map.rwm`, so the game builds its map again on the next start. A heights change also
changes the same points in `map_heights.hgt`: it is the game's own copy of the heights, read instead of the
picture while it is there and never made again by the game (Medieval II needs it to load), so it is kept and
kept in step. Land never goes down to pure black - the game may take black for sea.

Painting mountains does not raise the land by itself: ground and heights are separate pictures - use the
Heights brush there too.

*Confirmed in the game on Rome (0.10.0): the campaign loads and the painted ground and rivers are drawn.*

**Undo stroke / Redo stroke** (also the bottom Undo / Redo and Ctrl+Z / Ctrl+Y) step through your strokes.
