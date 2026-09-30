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
first. The logos need REX with `sprite_format xml` in `descr_caps_ex.txt` (REX's default): the original game
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

## Not yet

The strat-map symbol model; a new strat model from files of your own (the list offers the mod's own).
