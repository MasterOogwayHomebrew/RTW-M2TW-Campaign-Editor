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
  only this faction's line at it. The others keep theirs.
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
  disc, no ground), and the faction's **battle banners** (its own standard texture and its allies') get it painted on
  their cloth: the old symbol is found, filled over with the cloth round it (from its edges inwards, the folds kept),
  and the new one put in its place, shaded by the cloth's folds. The allies' banner carries the symbol faintly at the
  same place, so it takes the own banner's places. Where the cloth fools the finder (two colours, a symbol touching
  the trim) **Put it right...** under the banner opens it large: a brush marks more of the old symbol to fill over
  (or keeps a part), a box drawn on a banner is where the new symbol goes;
- 'Use it' puts them on the Art tab; Preview and Apply write them with a backup, Restore gives them back.

The campaign map's flags over armies and towns take their colours from the faction's colours (the game paints them);
the symbol on them is the flag symbol above. Medieval II's battle banners are heraldic sheets of many pieces - the
emblem does not paint them yet (Recolour changes their colours).

## Recolour all its pictures

**Recolour all its pictures...** (on the Art tab, also in **Tools**) moves every picture of the faction that
carries its colours to new ones: unit cards and info pictures, the units' battle textures and far-away sprites,
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
  horses, metal and leather stay. Light and shade are kept. White, grey or black 'from' colours have no hue and stay.
- **Touch up by hand**: paint on the 'after' picture what the test missed (a red line, a rim) with *new primary
  colour* / *new secondary colour*, or give pixels back with *keep as it was*; brush size in the picture's pixels,
  wheel to zoom, right drag to move. The touch-ups go with Write it.
- Every picture with before / after; untick the ones to keep. A picture other factions use too: when a line of
  the game's files names it (a campaign-map figure, a loading logo), the faction gets a copy of its own, recoloured,
  and its line points at it. A battle banner, the 3D symbol's texture or a town flag several factions name: the
  faction it is named after keeps the file and the others get copies of their own first (Medieval II's Normans keep
  England's old banners); crusade and military order banners stay as they are.
- What most factions that do not wear the colour have the same (a bronze star, a wooden pole, a face) is never
  recoloured.
- **Write it** writes each file in its own format (TGA of the same depth, DDS with its compression and mipmaps,
  Medieval II's `.texture`) with one backup; Restore gives every file back.

## Not yet

The strat-map symbol model; a new strat model from files of your own (the list offers the mod's own).
