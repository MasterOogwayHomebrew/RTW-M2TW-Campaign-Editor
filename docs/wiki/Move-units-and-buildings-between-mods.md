# Move units and buildings between mods

You like a unit or a building in another mod and want it in yours. The editor copies it over **with everything it
needs** and tells you what you still have to finish by hand. The other mod is only read - nothing in it changes.

Both games work the same way: Rome to Rome (with REX, Barbarian Invasion, HLR...) and Medieval II to Medieval II.
Between the two games it is not possible - their models and files differ.

## Units - step by step

1. Load **your** mod (the one that gets the units). Open **Unit editor** (top bar).
2. Press **Bring from another mod...** (top right of the editor).
3. **From which mod**: pick it in the list of mods in your game folder, or **Browse...** to its `data` folder.
4. **Which units**: tick them (Ctrl / Shift for more). **Find** and *only those this mod has not* help on a long list.
   The unit clicked shows on the right as the game shows it: its card, name, description and numbers.
5. **Names here**: the name each unit gets in your mod. A name your mod already has gets a free one (`... 2`).
   *Card / text name* is the unit's `dictionary`: it names its card pictures and its texts (letters, digits, `_`).
6. **Who has them**: the factions - or whole cultures - of your mod that may recruit them. The other mod's owners
   your mod has too are picked already.
7. **Where they are recruited**: only the units come over, never a building. One line per unit: *the same buildings
   as in the other mod* (the levels your mod has under the same names - listed under it), any building level of
   **your** mod (e.g. your own barracks), or *not recruited there*.
8. **Check and write**: every file and line it will write. Read the **WARNINGS** at the end - they say what to
   finish by hand. **Write it into this mod** makes one backup first; **Tools > Restore a backup...** undoes it.

What comes along: the unit's lines, its battle models (Medieval II: in `descr_model_battle.txt` *and*
`battle_models.modeldb`), mount, engine or animal, every mesh / texture / sprite they name, its cards and info
pictures for each new owner, its name and descriptions, and the recruit lines.

![Step 5: where the brought units are recruited in your mod](https://raw.githubusercontent.com/MasterOogwayHomebrew/RTW-M2TW-Campaign-Editor/main/docs/images/bring_units.png)

## Buildings - step by step

The same window from the **Building editor**: **Bring from another mod...**

1. **From which mod**, then **Which buildings**: tick the building chains. The chain clicked shows on the right:
   pick a level and a culture to see its pictures (in the town, when built), the name and description players
   read, who may build it, what it needs and what it does in plain words.
2. **Names here**: the chain and each of its levels. The game needs every chain and level name once, so a taken
   name gets a free one (`barracks_2`, `town_watch_2`...).
3. **Who may build them**: factions or whole cultures. Every level and every recruit line in them gets this list.
4. **The units they recruit**: each unit the building recruits goes to a unit of **your** mod - the same one when
   your mod has it; otherwise pick one, or *leave the line out*. To keep a unit your mod lacks, bring it first
   (Units, above), then the building.
5. **Check and write**, as for units.

Conditions the other mod has and yours does not are taken out and said in the WARNINGS: a hidden resource
(Barbarian Invasion's `britain`), a resource, a religion (`religious_belief` lines where your game has no religions).
Left in, the game stops at start ("unrecognised hidden resource"); **Check mod files** finds such lines too.

What comes along: the whole chain (levels, upgrades, capabilities, recruit lines), the names and descriptions of
its levels for every culture, and the level pictures (`ui/<culture>/buildings/#<culture>_<level>.tga` and the
`_constructed` ones). The warnings name a `requires` line or a city / castle partner (`convert_to`, Medieval II)
that points at a building your mod has not - change those lines in the Building editor.

## Good to know

- **Not tested in the game for every mod**: a building or unit that depends on scripts, traits or resources of
  its own mod needs those too - the warnings name what the editor can see.
- **To share units with other people**, use the Unit editor's **Export pack...** (one `.zip`) and **Import
  pack...** on their side. **Tools > Check and install a pack** is something else: it checks a mod that says
  "copy this data folder over the game" before anything is copied.
- A mistake? **Tools > Restore a backup...** gives every file back, byte for byte.
