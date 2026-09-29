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

The optional part at the top draws a new `map_<faction>.tga` from the faction's towns, in a colour you pick
(off by default - the original stays). The maps of factions whose land changes follow.

## Not yet

3D models, strat-map flags (the banner symbol atlases) and new sprite logos are not handled yet.
