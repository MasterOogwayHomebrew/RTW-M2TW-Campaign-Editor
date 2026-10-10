# Units and buildings

## Units and Buildings

Every line of a unit (`export_descr_unit.txt`) or a building chain (`export_descr_buildings.txt`) as a field,
with its pictures. The pictures, the battle model and the voice stay in view; the lines fold away behind
**Every line of the block** (open it to change them; it stays open or closed as you left it). On a unit, the
**?** beside a line's name says what each of its values means - stat_pri's attack, charge bonus, missile, range,
ammunition..., stat_cost's turns, price, upkeep..., every word of attributes - from the game's own notes. The lists filter (**Show**: a faction, a culture, a category, mercenaries apart) and sort; drag the line between the list and the rest (its grip drawn in the text's colour) to make the list wider - the width is kept.

- **Texts players read** (Buildings, under the pictures): a level's name, short description and
  description for a culture or a faction (**Texts for**; * = it has texts of its own). The game shows the
  faction's texts first, else its culture's, else the plain ones; a change is written to `export_buildings.txt`
  on Apply, with a backup. Both games.
- **Pictures as the game shows them**: a unit's card and its description picture come from a faction that owns it
  (or the mercenaries' folder) - when there is none, the box says so; a building level opens on a **Culture** that
  builds it, and a culture that never builds it is marked *(never builds it)* (the game has only stand-in texts for
  it). The hover cards in every list show the same pictures.
- **Import...** puts a picture in the right size and format in the right place.
- **New unit / New building step by step...** makes a new one from an existing one that surely works in the game,
  in steps you can go back and forth between: names and the texts players read, who owns the unit (or may build
  the chain), its main numbers (men, attack, armour, cost...), pictures of your own, and last everything it will
  change, file by file, before it is added. Written on Apply with a backup.
- A unit can also start from **nothing** (New unit step by step > Start from: *Nothing*): say what it is - foot
  soldiers who fight hand to hand, with spears, or who shoot / throw; horsemen who charge or who shoot - and the
  editor writes every line itself, in the form this mod's units of that kind have. Each number starts at what is
  usual for such a unit in this mod (the middle of them all) and is shown with the mod's lowest and highest;
  pick its battle model (and what it rides), its owners, the building levels that train it (the first guess:
  where this mod trains such units most) and its pictures - without pictures the editor draws plain cards with the
  unit's initials. A siege crew, a ship, an elephant or a chariot is still made as a copy.
- A building chain can start from **nothing** too (New building step by step > Start from: *Nothing*): say what
  it is for - soldiers, money or food, order and learning, a temple, something else - and how many levels
  (Medieval II: for cities or castles). Each level's town size, cost and turns start at what is usual for such
  buildings in this mod, with the effects most of them have. The Levels step shows every level side by side:
  change any number, add any effect this mod's buildings use (named in plain words), right click an effect's
  name to take it out. Then the units it trains (from the level you pick, at every level after it - only units
  someone who builds it may own), its names and texts, and its pictures: yours, or plain ones the editor draws
  with the level's initials for every culture that builds it (Medieval II also the small picture of the
  construction queue).
- **Bring from another mod...** copies units or building chains from another mod of the same game, step by
  step, with everything they need - see [[Move units and buildings between mods]].
- **Where it can be built...** (a building) / **Where it is recruited...** (a unit): a window of its own - the
  regions whose land lets each level be built (from the goods and region tags its requirement asks for; NOWHERE in
  red), and every building level that recruits the unit, its pool in plain words, its requirement and a button that
  opens that building.
- **Add line...** / **x**: add or remove lines (never beyond what the mod already does, never the lines every
  unit or level has).
- **Tied to it** shows who owns and recruits a unit, what requires a building.
- **REX...** (next to a unit's attributes, stat_mental, stat_ground and weapon lines): tick the abilities REX adds,
  each with its effect in plain words - morale (expendable, steadfast, immune_to_psychology...), fatigue
  (relentless, inexhaustible...), charge (brace_for_charge, aggressive_push...), terrain (desert_raider,
  forest_ambusher), garrison (troublemaker, police), unit size (no_scale, single_entity), `sp` shield piercing.
  They work only under REX. `recruit_priority_offset` (how much the AI recruits the unit) may be added too.
- **Recruit a unit** writes the file's own form: Rome `recruit "unit" 0`, Medieval II `recruit_pool "unit" 1 0.5
  4 0` (units at the start, new units a turn, most units waiting, experience); tick "only retraining" for REX's
  `retrain` / `retrain_pool`.
- REX's bracket requirements - several `factions { }` groups on one line, each with its own conditions - are
  read in full; Give joins the first group (Preview says so), Take removes the faction from every group.
- A rename drags along what is tied to it: recruit lines, the armies of every campaign, mercenary pools,
  rebels, requirements.
- **Battle model** (units): each soldier and officer model with an owner's texture and how it sits (foot, horse,
  camel, elephant, chariot); **Replace model...** takes another model of this mod or of another mod of the same game
  (with every file it names; the unit's factions get textures on it), **View in 3D...** turns the model with the
  mouse - Medieval II's `.mesh` and Rome's `.cas` - with each faction's texture, the game's detail levels and weapons
  on or off. Rome: in the T pose (arms out) or as the file stands (**Pose**); a chariot unit on its chariot with its
  horses and crew in the places `descr_mount.txt` gives; a siege engine unit's engine (`descr_engines.txt`) whole,
  with its own texture. **Animation**: any move of the model's skeleton (stand, walk, run, attacks, shooting,
  dying... - the list `descr_skeleton.txt` gives it), read from the game's own animation packs
  (`data/animations/pack.idx` + `pack.dat` - Rome, Barbarian Invasion, Medieval II): **Play** / **Pause**, or drag
  the frame; a unit with two skeletons (a spear and a sword) picks one first. It plays at the game's speed and
  smoothly - the moments between two frames are drawn between them (while it plays the man is drawn in his
  texture's colours, quicker; paused, in the whole texture). Medieval II's horsemen: with no animation the rider
  stands in the T pose beside his horse (the horse in its standing pose); pick any animation and he sits in the
  saddle (where `descr_mount.txt`'s `rider_offset` puts him) and the horse plays the same move, as in the game -
  a horse's own View in 3D plays its moves on its own bones. The weapons and the shield take their own moves in
  the hand (a javelin turns point first for the throw). Rome's horsemen still stand beside their mounts.
  **Make a card...** / **Make a picture...** (the unit's soldier model): the view as it stands - turned, zoomed, in
  the frame picked - made into the unit's card or description picture, framed as the game's own (the card from the
  head to the thighs, the picture the whole man; to the knees / waist; nearer, up / down, right / left), on a
  see-through ground as the game's cards, a colour or a picture of your own. **Use it** waits for Preview / Apply
  like **Import...** (every faction folder of the unit's card, a backup first); **Save a copy...** keeps a PNG.
- **Your own files...** (beside Replace model) puts files you made in another program in place of the model's: a
  texture for every faction or one faction (PNG, TGA, DDS, JPG - converted to the game's form, Rome `.tga.dds`,
  Medieval II `.texture`; sides of 64, 128, 256...), Medieval II's weapons and shields texture, and the model file
  itself (Rome `.cas`, Medieval II `.mesh` - several files are its detail levels, closest first; it keeps the old
  model's skeleton). Every file gets a name of its own beside the old ones and the lines are written; when other
  units use the same model, this unit gets a model of its own (a copy), so they keep their look. Far away the game
  still draws the old model's sprites. Preview, a backup, Undo this write.

  ![View in 3D](https://raw.githubusercontent.com/MasterOogwayHomebrew/RTW-M2TW-Campaign-Editor/main/docs/images/view_in_3d.png)
  ![View in 3D, Rome](https://raw.githubusercontent.com/MasterOogwayHomebrew/RTW-M2TW-Campaign-Editor/main/docs/images/view_in_3d_rome.png)
- **Voice in battle** (units, both games): what the unit says, for each accent (Medieval II,
  `descr_sounds_accents.txt`) or culture (Rome) of its owners. **Play** plays its own name call ("Khan's Guard!")
  or any of its orders, straight from the game's sound packs (`data/sounds/*.idx` / `.dat`; a loose file of the same
  name wins, as in the game). **Put in my own...** makes your `.wav` files its name call: they are copied in under
  new names, `export_descr_sounds_units_voice.txt` gets the unit its own block (taken out of a line it shares with
  other units; a new unit gets one), and `data/sounds/events.dat` / `events.idx` are removed with a backup - the game
  builds them again from the texts on the next start. The voice class is the `voice_type` line.

## Many towns at once

A building level for many towns of any owner, or random garrisons under an upkeep limit: the Map's **Select**, a box, then a right
click (or **Many towns at once...** on Edit faction's Buildings tab) - see [Campaign map: Select](Campaign-map#select-a-box-round-many-things-at-once).

**One temple per town**: the games take one temple chain (a name starting with `temple_`) per town - two in
`descr_strat.txt` stop the game ("Settlement specified with multiple temple buildings"). The Buildings tab swaps the
old temple for the one you pick, the many-towns window skips a town that has another temple, Check mod files names a
town holding two. A mod that wants more temples names the extra chains without "temple".

## Roster (Edit faction)

Every unit and building level of the mod and whether the faction has it. **Give** / **Take away**. A unit is
the faction's only when three places agree, and Apply keeps them in step: its `ownership`, the recruit lines
that let the faction train it, and its cards.

## Unit packs

**Export pack...** in Units puts a unit (or every unit the list shows) into one `.zip` with
everything it needs: models, textures, mount, engine or animal, cards, names and descriptions, recruit places.
**Import pack...** in another mod **of the same game** shows the units with their names there (taken names get
a free one), asks who owns them, and writes them with a backup. Nothing of the target mod is overwritten.

In Medieval II a unit's battle models live in two places kept in step: `descr_model_battle.txt` (the text the
game reads under M2EX's `model_battle_source text`) and `unit_models/battle_models.modeldb` (what the game reads
otherwise). A pack carries both, with every mesh, texture and sprite the model names. On import, a model the
target mod has with other content is added under a free name in both files, and the unit follows it; every
faction the units go to gets a texture entry in both (copied from the model's mercenary texture, else its first),
so no owner sees an untextured unit. Rome packs get the same texture lines for new owners.
