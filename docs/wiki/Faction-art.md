# Faction art

The **Art** tab lists every picture of the faction - buttons, symbols, the loading-screen logo, banners, the
captain's card, the leader picture, the campaign-select map - each with where the game shows it and what it
needs (size and format).

## Replacing a picture

**Replace...** takes a PNG, JPG, TGA or DDS. The tool makes it the size and format of the picture it replaces
(a 32-bit TGA stays a 32-bit TGA, a DXT5 `.tga.dds` banner stays DXT5 with its mipmaps) and writes it **in the
same place under the same name**, so every file that names it keeps working. Your file's own name does not
matter. **Preview**, then **Apply** writes it with a backup.

- **A new faction's pictures are its own.** The clone gives it copies under its own name, so replacing a
  picture of Epirus never changes Macedon's.
- **Shared pictures**: some pictures are used by several factions (the rebels' and the routing banner). The
  Art tab says who shares one; **Replace...** then makes a copy of the faction's own under its name and points
  only this faction's line at it. The others keep theirs. The same for a battle banner, a town flag or the 3D
  symbol's texture shared with others: **Replace (its own copy)...** (Edit faction) and **Save a copy...**.
- **Keep the current one** drops a replacement not written yet.
- **Back to the original** puts back a picture the tool changed earlier: the version the first backup kept,
  or for a new faction the template's picture it was copied from.

There is no *Remove*: without its pictures the game shows errors and a placeholder instead.

## The campaign-select map

Put away for now: a new faction keeps a copy of its template's `map_<faction>.tga` and every other faction's
map stays the original. Drawing a new one from the faction's towns will come back in a later release.

## Flag symbol and faction logos (Rome)

Three pictures of a Rome faction do not live in files of their own but on sheets shared by every faction:

- **Flag symbol on the campaign map** - the symbol on the flags over its armies, fleets and towns. It is one
  of four symbols on `banners/symbolsN.tga.dds`, picked by `standard_index` in `descr_sm_factions.txt`.
- **Faction logo** (the faction button at the bottom right of the campaign map, diplomacy) and the **small
  faction logo** - sprites named by `logo_index` / `small_logo_index`.

A **new faction gets its own**: a free flag slot and, under REX, logo sprites on a page of their own
(`ui/roman/interface/faction_logo_<faction>.tga`), the template's pictures copied in - so replacing them never
changes the template's. **Replace...** on an existing faction that shares its slot or sprite does the same
first. The logos need REX with `sprite_format xml` in the mod's own `descr_caps_ex.txt` (a mod without one runs
on the engine's default `sd`; Load offers to copy the game's): the original game
reads binary sprite sheets that cannot take new sprites, and the Art tab says so.

## Figures on the campaign map

At the top of the Art tab: every character type of the faction (named character, general, admiral, spy, assassin,
diplomat - and on Medieval II princess, merchant, priest / bishop / cardinal ...) with the figure that shows it on
the campaign map - a strat model of `descr_model_strat.txt`, named per faction in `descr_character.txt`. Pick
another model in the list, **3D** shows it with the faction's texture; Preview, then Apply writes it. A faction
that shares its entry with others (`faction a, b`) gets an entry of its own, the others keep theirs. A model the
faction has no texture in gets a texture line (the model's first picture); after Apply its picture is listed
below to **Replace...** like any other. The figures' textures are Art pictures too ("campaign map figure: ..."),
and a new faction gets copies of its own of the template's (`diplomat_macedon` -> `diplomat_epirus`), so
replacing them never changes the template's. Both games.

## Faction emblem - one picture everywhere

The faction's emblem is shown in many places, each in its own size: the campaign-menu buttons (small and big, each
normal / mouse over / selected / greyed out), the loading screen, the faction screen (Medieval II), the in-game
panels' symbol (Medieval II), the faction logo and small logo (Rome, on the game's sprite sheets). **Faction emblem -
one picture everywhere...** on the Art tab takes one picture (best a square PNG with a clear background). First it
is **fitted by hand**: drag it to move, the mouse wheel makes it bigger or smaller, a slider turns it; the
**shape** cuts it like the old emblem (most are a disc - its outline is drawn as a yellow guide), as a circle, a
square or not at all; the **ground** fills the shape behind it (clear, the faction's primary or secondary colour,
any colour); the **magic wand** clears an area of like colour with one click (a white background), the **paint
bucket** fills one; **Undo**, **Fit again**, **Start over**. **Next** makes all of them from it:

![One emblem made into every place](https://raw.githubusercontent.com/MasterOogwayHomebrew/RTW-M2TW-Campaign-Editor/main/docs/images/emblem.png)

- each picture keeps its size and format, the emblem fitted where the old one sat (the margins stay clear);
- the button states are made the way the mod's own are: mouse over brighter, greyed out grey and darker (by as much
  as the faction's old pictures show), selected brighter with a glow round the new shape in the old glow's colour;
- a picture the faction shares with another (a loading logo) becomes a copy of its own, its line pointed at it;
- **the symbol on the flags and banners (Rome)**: the flag symbol on the campaign map gets the symbol alone (no
  disc, no ground), and the faction's **battle banners** (its own standard texture and its allies') are made new
  from the game's own **blank white banner** (the cloth a routing unit carries - Roman, barbarian or eastern,
  any of the three for any faction, whatever its culture - picked by its picture in **Banner...**; the game turns a fleeing unit's banner into it, and it is only read, never
  changed): its cloth dyed in the faction's colour, the folds kept, the symbol painted on it (faint on the allies'
  banner, as the game's own are); the trim, the experience stars and the pole stay as they are. **Banner...** under
  a banner picks another blank banner, a **pattern** of up to three colours (plain, two or three stripes upright -
  a tricolour - or across, halves or bands slanting, quarters, a cross, a slanting cross, a border, a stripe in the
  middle), the symbol on or off, and the symbol dragged with the left mouse button where it should be;
- a picture with a plain background (a white square round the symbol) has it cleared at once, so no square shows on
  the flags and banners (**Start over** brings it back);
- 'Use it' puts them on the Art tab; Preview and Apply write them with a backup, Restore gives them back.

The campaign map's flags over armies and towns take their colours from the faction's colours (the game paints them);
the symbol on them is the flag symbol above.

## Banner... - battle banners from a white banner (both games)

**Banner...** (on the Art tab, beside Recolour) makes the faction's battle banners new, no emblem needed first:

- **the cloth**: a **pattern** of up to three colours on each banner on its own - plain, two or three stripes upright
  (a tricolour) or across, halves or bands slanting, quarters, a cross, a slanting cross, a border, a stripe in the
  middle; the cloth's folds and stitching are kept;
- **a symbol** if you like: **Symbol picture...** takes any picture (a white or plain square round it is cleared),
  shaded by the folds; **drag it with the left mouse button** where it should go (a click on another banner or
  pennant brings it there), **the mouse wheel** over it makes it bigger or smaller; **Snap** lays a grid on each
  banner - big cells (quarters), medium (eighths) or small (sixteenths) - and the symbol's middle lands on its
  lines, or no grid to move it freely; **Symbol back in the middle** puts it back;
- **your own drawing**: **Save the template...** saves the white banner as a PNG of the game's size with each banner
  outlined in red - paint inside the lines in any program, keep the size, then **Put in my own drawing...** takes it
  in its place (the symbol can still go on top); **Back to the dyed cloth** drops it;
- **Undo** steps back; **Done** puts the pictures on the Art tab; Preview and Apply write them with a backup in
  the game's own format, Restore gives them back.

**Rome**: made from the game's own blank white banner (the cloth a routing unit carries - Roman, barbarian or
eastern, any of the three for any faction), the faction's own banner and the allies' (the symbol faint, as the
game's own are); the trim, the experience stars and the pole stay as they are.

**Medieval II** has no white banner - every one of the game's banner pictures carries heraldry (even the rebels' a
cross, the multiplayer ones numbers). But every faction's picture (`banners/textures/faction_banner_<faction>.texture`,
1024 x 512) holds the same banners in the same places, so the white template is taken from the mod's own pictures:
per pixel, the light of each against its surroundings, and the middle value of them all - each faction's heraldry
sits somewhere else, so it goes; the folds, the tooth edges and the holes they share stay; what is alike in nearly
all of them (the poles, the fittings) keeps its colour. The banners' 3D models (`data/banners/main_*.mesh`, named in
`descr_banners_new.xml`) say where each banner and pennant lies on the picture: each is dyed on its own, and the
window shows the banner in 3D (pick infantry, spear, cavalry, missile or general). Each small pennant has four looks
on the picture (the game shows the others on other units): all four get the design - the saved template outlines the
other three in grey, and your own drawing's first pennant is copied into them. The cavalry banner's slit is dyed with
the cloth round it (no dark seam through the symbol). The translucency picture beside it
(`_trans`) is left as it is. A banner picture shared with other factions becomes the faction's own copy (its line
in `descr_banners_new.xml` pointed at it; when the file carries the faction's name, the others get copies of the old
one instead). Making the template takes a few seconds the first time (kept while the files are unchanged). Royal
banners (`royal_banner_<faction>`) and crusade / order banners are not made here.

## Recolour all its pictures

**Recolour all its pictures...** (on the Art tab, also **Recolour...** in the top row - a list at the window's top picks the faction) moves every picture of the faction that
carries its colours to new ones: unit cards and info pictures, the units' battle textures, weapons and shields and the faction's own siege engine (Medieval II's carroccio) and far-away sprites,
the campaign-map figures (generals, agents, admirals), the faction symbol's texture, the menu buttons and symbols,
banners (Rome's standards, Medieval II's battle banners), the flag on its towns in battle (Rome), captain cards and
the loading-screen symbol. Both games. The campaign map's flags over armies and towns are painted by the game itself
from the faction's colours.

![Recolour: England's red and yellow to green and gold](https://raw.githubusercontent.com/MasterOogwayHomebrew/RTW-M2TW-Campaign-Editor/main/docs/images/recolour.png)

- **From the colours of**: the colours the pictures carry now. For a faction cloned from a template it finds the
  template by itself (its cards are copies of the template's); otherwise the faction's own. Click a colour to pick
  another.
- **to**: the faction's own primary and secondary colour from `descr_sm_factions.txt` (the Faction tab sets them),
  or any picked here.
- A part counts as the faction's colour when it is coloured and its hue is near the old colour. Where the same
  picture exists for other factions (a unit card, a battle texture), only what differs between them changes - faces,
  horses, metal and leather stay. Light and shade are kept. A cloak painted duller or darker than the faction's
  colour is taken whole (its shaded half too). White, grey or black 'from' colours (the Holy Roman Empire's black,
  France's white) have no hue: they change only on unit cards and battle textures, where the other factions'
  copies show which parts are the faction's; on symbols (each faction's is another drawing) they stay. Faces and
  hands are never taken for a red or yellow coat.
- **Touch up by hand**: paint on the 'after' picture what the test missed (a red line, a rim) with *new primary
  colour* / *new secondary colour*, or give pixels back with *keep as it was*; brush size in the picture's pixels,
  wheel to zoom, right drag to move. **Area of like colour** (beside the brush): a click takes the whole patch of the
  picture's own colour joined to that point - a hood, a shield's field - and paints it at once; *alike* says how far a
  colour may differ and still belong; *keep as it was* + a click gives an area back. The touch-ups go with Keep for
  Apply.
- Every picture with before / after; untick the ones to keep. A picture other factions use too: when a line of
  the game's files names it (a campaign-map figure, a loading logo), the faction gets a copy of its own, recoloured,
  and its line points at it. A unit's battle texture (and Medieval II's weapons and shields) is NEVER recoloured
  over the original: the original is copied, the copy recoloured and put in the mod beside it, and the model's line
  for the faction points at it (`descr_model_battle.txt` and the modeldb) - whether the faction wears it with others
  (a new faction wears its template's), only the game's data holds it (a mod in `mods/`), or it is the game's own
  file of that faction (named `..._own` then); the others and the game's files stay as they are. Only a copy made
  for the faction before is recoloured where it is. A faction that has a unit's texture but no weapons texture gets
  that line too (without it Medieval II shows its men like bare skeletons in battle). A battle banner, the 3D symbol's texture or a town flag several factions name: the
  faction it is named after keeps the file and the others get copies of their own first (Medieval II's Normans keep
  England's old banners); crusade and military order banners stay as they are.
- What most factions that do not wear the colour have the same (a bronze star, a wooden pole, a face) is never
  recoloured.
- **Keep for Apply** puts them in the session's list; **Apply changes** in the main window writes each file in its own format (TGA of the same depth, DDS with its compression and mipmaps,
  Medieval II's `.texture`) with one backup; Restore gives every file back.

## Not yet

The strat-map symbol model; a new strat model from files of your own (the list offers the mod's own).
