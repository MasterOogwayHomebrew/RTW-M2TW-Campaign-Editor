# Units and buildings

## Unit editor and Building editor

Every line of a unit (`export_descr_unit.txt`) or a building chain (`export_descr_buildings.txt`) as a field,
with its pictures. The lists filter (**Show**: a faction, a culture, a category, mercenaries apart) and sort.

- **Import...** puts a picture in the right size and format in the right place.
- **Copy as new...** makes a new unit or building from an existing one.
- **Add line...** / **x**: add or remove lines (never beyond what the mod already does, never the lines every
  unit or level has).
- **Tied to it** shows who owns and recruits a unit, what requires a building.
- A rename drags along what is tied to it: recruit lines, the armies of every campaign, mercenary pools,
  rebels, requirements.

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
