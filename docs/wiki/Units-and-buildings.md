# Units and buildings

## Unit editor and Building editor

Every line of a unit (`export_descr_unit.txt`) or a building chain (`export_descr_buildings.txt`) as a field,
with its pictures. The lists filter (**Show**: a faction, a culture, a category, mercenaries apart) and sort.

- **Import...** puts a picture in the right size and format in the right place.
- **New unit / New building step by step...** makes a new one from an existing one that surely works in the game,
  in steps you can go back and forth between: names and the texts players read, who owns the unit (or may build
  the chain), its main numbers (men, attack, armour, cost...), pictures of your own, and last everything it will
  change, file by file, before it is added. Written on Apply with a backup.
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
  on or off.

  ![View in 3D](https://raw.githubusercontent.com/MasterOogwayHomebrew/RTW-M2TW-Campaign-Editor/main/docs/images/view_in_3d.png)
  ![View in 3D, Rome](https://raw.githubusercontent.com/MasterOogwayHomebrew/RTW-M2TW-Campaign-Editor/main/docs/images/view_in_3d_rome.png)
- **Voice in battle** (units, both games): what the unit says, for each accent (Medieval II,
  `descr_sounds_accents.txt`) or culture (Rome) of its owners. **Play** plays its own name call ("Khan's Guard!")
  or any of its orders, straight from the game's sound packs (`data/sounds/*.idx` / `.dat`; a loose file of the same
  name wins, as in the game). **Put in my own...** makes your `.wav` files its name call: they are copied in under
  new names, `export_descr_sounds_units_voice.txt` gets the unit its own block (taken out of a line it shares with
  other units; a new unit gets one), and `data/sounds/events.dat` / `events.idx` are removed with a backup - the game
  builds them again from the texts on the next start. The voice class is the `voice_type` line.

## Roster (Edit faction)

Every unit and building level of the mod and whether the faction has it. **Give** / **Take away**. A unit is
the faction's only when three places agree, and Apply keeps them in step: its `ownership`, the recruit lines
that let the faction train it, and its cards.

## Unit packs

**Export pack...** in the Unit editor puts a unit (or every unit the list shows) into one `.zip` with
everything it needs: models, textures, mount, engine or animal, cards, names and descriptions, recruit places.
**Import pack...** in another mod **of the same game** shows the units with their names there (taken names get
a free one), asks who owns them, and writes them with a backup. Nothing of the target mod is overwritten.

In Medieval II a unit's battle models live in two places kept in step: `descr_model_battle.txt` (the text the
game reads under M2EX's `model_battle_source text`) and `unit_models/battle_models.modeldb` (what the game reads
otherwise). A pack carries both, with every mesh, texture and sprite the model names. On import, a model the
target mod has with other content is added under a free name in both files, and the unit follows it; every
faction the units go to gets a texture entry in both (copied from the model's mercenary texture, else its first),
so no owner sees an untextured unit. Rome packs get the same texture lines for new owners.
