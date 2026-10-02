# Characters and portraits

## Family tab (Edit faction) and Character editor

Everyone of the faction: the characters on the map (with traits and ancillaries) and family members off the
map. The family tree is drawn the way the game shows it: husband and wife side by side, their children below,
the leader and heir marked; people tied to no one stand under "Not on the tree", and a faction with several
families shows each as its own tree. The list and the person are on the left, the tree on the right (on the
Faction tab too). The **Character editor** at the top does the same for any faction, rebels too.

- Click a person to edit: name (from the faction's name lists - the game crashes on a name without a text),
  age, sex (off the map), traits with their level, ancillaries.
- **Give a wife...**, **Add a child...**: someone already in the faction (a new faction's heir becomes its
  leader's son this way) or a new person from the name lists. **New person...**: someone new tied to no one yet -
  then pick a married man and **Add a child...** (or a man and **Give a wife...**) and choose them there; Preview
  warns while a new person is still on no tree. **Take off the tree**, **Leave out**.
- A renamed person is renamed on every line of the family tree.
- The tree is checked before writing (a husband is a man, nobody is their own ancestor...).

**The character panel** (Character editor, both games): on the right the picked person is shown the way the
game's character panel shows him - the portrait in a frame, name, who he is, age; the attributes as ten pips
(Medieval II: Command, Chivalry or Dread, Loyalty - Authority for the leader and heir - and Piety; agents their
own skill: Subterfuge, Influence, Charm, Finance, Piety; Rome: Command, Influence, Management), added up from the
effects of his traits and his retinue as the files give them; the traits by the names players see
(`export_VnVs.txt`, or Medieval II's compiled `.strings.bin`) with what each gives; the retinue as picture cards
(`ui/ancillaries`). **A click on the pips sets the attribute** (a person on the map): the traits are fitted to it -
a trait he has that gives it moves to the level that fits (or comes off), else a trait giving that attribute alone
is added (GoodCommander for Command, say); the status line says what changed, Undo takes it back, Apply writes it.
A click on the last filled pip takes one off. The switch above it, **Character** / **Family tree**, shows the whole
family instead; the form on the left edits the rest (traits, retinue, portraits, name, age).

## Traits and retinue themselves

**Traits and retinue...** (Character editor, top right; also Tools) edits the traits and ancillaries themselves,
both games: `export_descr_character_traits.txt` and `export_descr_ancillaries.txt`.

- **Traits**: pick one on the left (its name and the name players see; Find filters). Who can have it
  (`Characters`), and per level the name and description players see, the points it needs (`Threshold`) and what
  it gives (`Effects`, typed like `Command 1, Loyalty -2`). **A right click on an Effects field** lists every
  bonus the game knows (read from its own exe), in groups - generals and battle, governing towns, character,
  agents, against a faction / culture / religion, and any other this mod's files use - each with what it does in
  plain words; a pick is added after a comma with the value 1, ready to type the number over (negative = a
  penalty).
- **Retinue**: the name and description players see, the picture (**Replace picture...** - a picture shared with
  other ancillaries is not changed: this one gets a picture of its own), the cultures it is barred to, its effects.
- **New trait / New ancillary (a copy of the picked one)...**: written at once as a copy under the new name - a
  trait's levels and text keys renamed after it, the texts copied - then edited like the others. No trigger gives
  a new trait yet: give it to characters in the Character editor.
- Preview, then **Write it in** (a backup first). The texts go into `text/english/export_VnVs.txt` /
  `export_ancillaries.txt`; where Medieval II keeps a table only compiled (`.strings.bin`), a `.txt` is made from
  it. Preview says when a `.strings.bin` lies beside it: if the game shows the old text, remove that file so the
  game builds it again (not removed by the editor on its own - not checked in the game yet).

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
