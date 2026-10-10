# Terrain editor

The **Terrain** and **Coast & heights** tabs of the **Maps** (beside its Map) paint the campaign map itself:
**Terrain** has Ground, Rivers / cliffs / volcanoes and Climates, **Coast & heights** everything of `map_heights` -
Land and sea (the coast) and Heights. They are one editor shown in two tabs: one Undo / Redo, one Apply. The Map
tab's own switches (Layers, Edit regions, Select, Merge regions, Signs and tools, Find) are not shown here.

**Videos:** [editing rivers, fords, cliffs](https://youtu.be/z0T723riXaU) · [editing a height map](https://youtu.be/mTdRAWympuw) (both checked in the game on Rome
and Medieval II).

- **Ground**: low / medium / high fertility, wilderness, sparse and dense forest, hills, mountains, high
  mountains, swamp, beach (land: both games lay it on the land tiles along the coast), and the three kinds of sea; **impassable land** and **impassable sea** (no army walks or sails
  there - Medieval II, whose map is full of them; Rome only with REX, which knows these ground types - not yet
  tried in the game on Rome); **impassable land, always black** (never walked and never seen - for the land of a
  wasteland you want hidden for good; Rome with REX and Medieval II with M2EX, whose ground type
  impassable_shrouded it is - not yet tried in the game).
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
  beside it (a right click is an eyedropper: it picks the height of the point under the mouse). The
  **strength** slider sets how fast. The heights picture has 2 x 2 points a tile (it is 2 x the map + 1 wide)
  and the map shows them as they are; **brush size n is n points across**, round and snapped to the points like a pixel-art pencil (1 = one point,
  2 = a square of 2 x 2, 3 = 3 x 3, 4 = a round 4 x 4...; up to 24); the outline shows exactly the points it takes. The line under
  the map gives the point under the mouse exactly: land - its grey (0 = the lowest land, still above the
  water) and about how many metres; water - its blue and the sea floor's depth (the water's surface is 0); and
  what `map_heights.hgt` holds there. While this mode is on the map shows the heights as the file has them:
  land grey - black low, white high (brightened a little so the low land is not all black) - and the sea blue.
  Only land is changed; the coast stays.

**Find** above the map finds a town, port or character by name. Left drag paints (brush 1-12), right click picks the ground of a tile, right drag moves the map, **Grid** on
or off.

![Land and sea: a new island in the Black Sea](https://raw.githubusercontent.com/MasterOogwayHomebrew/RTW-M2TW-Campaign-Editor/main/docs/images/land_and_sea.png)

## What it keeps safe

- **How the game draws a coast** (why a coast painted by tiles looks like stairs): a tile is one pixel of
  `map_regions.tga`; the heights (`map_heights.tga`, and `map_heights.hgt`, which the game reads) have a point at every
  tile's middle, side and corner. The game cuts every square of four points into two triangles and lays the water at
  height 0, so the shore runs where the height crosses 0 between a land and a water point - where exactly, the two
  numbers decide. The same numbers everywhere let the shore run only along the points' grid and its diagonals (steps
  at 90 and 45 degrees); the games' own coasts are smooth because their heights change smoothly near the water.
- **The shape brush** (Land and sea, *shape brush: land / water* - the first pick): draw the coast where you want
  it, round like a paint brush and not tied to the tiles - at every size, size 1 too, its circle is centred on
  the mouse. The brush keeps the coast as a shape and sets the heights
  near the water by their distance from its edge, on one slope on both sides - so the game's shore falls exactly
  on the edge you drew. The exact heights go into `map_heights.hgt`. The tiles follow by their middles (new land
  joins the region picked in *new land joins* - see below), the ground follows point by point (shallow
  water along the new shore), and a town, port, character, fort, resource or river keeps a little land round it.
  **Smooth the coast** rounds the coast under the brush the same way - the longer you hold, the smoother (a stepped
  coast becomes a curve; small capes and bays ease out). While these brushes are picked the map is shown **by
  points** (land grey, water blue, each point centred on its place), and close up a light **Shore line** shows the
  shore exactly as the game will draw it (in every mode of the tab; the tick is beside *Find ground...*).
- **Pull** and **Push** (beside the shape brush): *pull* grabs the coast under the brush and drags it with the mouse,
  like a painter's liquify - the coast goes most in the brush's middle and softly less to its edge - so a cape or a
  bay is drawn in one move; *push*, pressed on the land beside the coast, grows the land into the water (pressed on
  the water: the water eats into the land), the longer you hold the further. The heights, the tiles and the ground
  follow as with the shape brush.
- **Land and sea** (*Land* / *Sea*, by tile): turn sea into land (a new island, a longer coast) or land into sea (a bay, a strait). Land and
  sea are written in three places that must agree, so each tile changes all of them: `map_regions.tga` (the
  region's colour or the sea's), `map_ground_types.tga` (a land ground like its neighbours', or shallow sea; new land gets a ring of shallow sea:
  the 8 sea tiles round it that are deeper turn shallow) and
  `map_heights.tga` with `map_heights.hgt` (new land rises from a low shore inland as the games' own coasts do -
  2, 8, 12, 14, then 16 grey steps from the sea - so an island never lies flat on the water; new sea: the sea's
  depth). The coast round the painted tiles is drawn the way the games' own maps are: on a smooth curve between
  the tiles (half a tile fine), not in tile-sized steps - a one-tile islet stays a small oval, a one-tile strait
  stays open, and every tile stays what you painted. The minimap (radar_map1 / radar_map2.tga) is drawn again on the
  changed tiles from the nearest tile of the same ground. **The coast pen** (land point / water point) draws the coast by hand on
  the heights' points - a tile is 3 x 3 of them, its middle its own, the sides and corners shared with its
  neighbours; the map is shown point by point while the pen is picked, and touching a tile's middle turns the whole
  tile. **New land joins** (beside the brushes): **(nobody - the wasteland)** - with REX (Rome) or M2EX (Medieval
  II), the default - keeps the land you paint nobody's: no town, no owner, no faction grows; all of it goes into ONE
  wasteland region, `Wasteland`, made on Apply when the map has none (three lines in `descr_regions.txt`: its name,
  `wasteland`, its colour; its name in the names text), and the next painting joins the same one (a map cut's
  leftover land too). **(the nearest region)**: the region of the nearest land grows; or pick a region. The
  original games know no wasteland, so there the choice is not offered. Move borders later on the Map (Regions).
  Refused: drowning a
  town, port, character, fort or resource, a region's last land, a river (rub it out first) or a port's last land.
  The Ground brush keeps land as land and sea as sea, and on the coast it paints only the points on its own side of
  the waterline (a tile's 3 x 3 block reaches over the coast, which runs between the tiles) - no land texture on the
  water, no holes of sea in the land.
- **Find ground on the wrong side of the coast** (under the Land and sea brushes): rings every point where the
  ground (`map_ground_types.tga`) and the heights (`map_heights.tga`) disagree - a land ground on the water or a sea
  ground in the land - and says how many of each; on a yes each point takes the ground round it on its own side.
  The heights lead and are not changed; kept until Apply, **Undo stroke** takes it back. The games' own maps have
  next to none (Rome 0, Medieval II 18 by lakes in the hills), so what it finds is most likely a mod's own painting
  or an older editor's.
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
