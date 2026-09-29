# Characters and portraits

## Family tab (Edit faction) and Character editor

Everyone of the faction: the characters on the map (with traits and ancillaries) and family members off the
map. The family tree is drawn the way the game shows it: husband and wife side by side, their children below,
the leader and heir marked. The **Character editor** at the top does the same for any faction, rebels too.

- Click a person to edit: name (from the faction's name lists - the game crashes on a name without a text),
  age, sex (off the map), traits with their level, ancillaries.
- **Give a wife...**, **Add a child...**: someone already in the faction (a new faction's heir becomes its
  leader's son this way) or a new person from the name lists. **Take off the tree**, **Leave out**.
- A renamed person is renamed on every line of the family tree.
- The tree is checked before writing (a husband is a man, nobody is their own ancestor...).

## Portraits

- **Rome**: the tool shows the same man young, old and dead; to see your own pictures in the game, add them to
  the pool (**Portrait library...**). The game gives every character a random picture of its culture's pool when the campaign starts
  (`ui/<culture>/portraits/portraits/young|old|dead/generals|civilians|rogues/NNN.tga`); family members off the
  map get the family picture.
- **Medieval II**: a character on the map can have a portrait of his own. **Replace...** under young, old or
  dead writes it to `ui/custom_portraits/<folder>/` and adds `, portrait <folder>` to his line - the game's own
  way (vanilla's Norman prologue does it for William and Rufus).

## Portrait library

**Portrait library...** in the Character editor shows every portrait of a culture as the game keeps them.
**Add portraits...** puts new ones into the pool: any PNG, JPG or TGA is made the size of the culture's own,
under the next free number in every folder of the group (the same number is the same man young, old and
dead; the dead one greyed unless you give one).

- Rome also gets the small 44 x 63 cards.
- Medieval II has no cards; only generals have *old* portraits; princesses have their own *dead* folder.
  The tool writes what the game has, nothing more.
