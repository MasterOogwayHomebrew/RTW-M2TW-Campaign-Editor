# Campaign rules and Add-ons

## Campaign rules (Tools > Campaign rules...)

![Campaign rules](https://raw.githubusercontent.com/MasterOogwayHomebrew/RTW-M2TW-Campaign-Editor/main/docs/images/campaign_rules.png)

Every value of the campaign's settings files, by group, each with a plain explanation:

- **Both games** - the top of the loaded campaign's `descr_strat.txt` (group "The campaign ..."): the start and end
  date (year and season, a minus = BC), `timescale` (years a turn - Medieval II and REX), how seldom brigands and
  pirates appear, REX / M2EX's `random_persona_weights`, and the switches as on / off: night battles, the date shown
  as turns (Medieval II), Marian reforms off or already done, rebelling generals, gladiator uprisings. A switch
  turned off loses its line, one turned on gets a line; the faction lists and everything below stay as they are.
- **Medieval II** - `descr_campaign_db.xml`: recruitment, religion (witches, heretics, inquisitors), bribery, ages and
  the family tree (coming of age, marriage, children, old age), ransom, autoresolve, sacking and siege gear, revolts,
  hordes, merchants, agents' chances, crusades and jihads. `descr_settlement_mechanics.xml`: each line of the town
  scrolls - population growth, public order, income - with its weight, min and max (cities and castles apart).
  `descr_diplomacy.xml`: what each offer costs and how it moves standing. `descr_recruitment.xml`.
- **Rome under REX** - `descr_settlement_mechanics.xml`: the people each settlement level starts with, needs to grow,
  and holds at most; the weights of the town scroll lines.
- **REX / M2EX** - `descr_unit_sizes.txt`: the Unit size choices in the options (soldiers x this number).
- **REX / M2EX engine settings** - `descr_ex.txt` (sound, camera, max factions, bribery, hordes, ages and the family,
  the battle range disc and colours...) and `descr_caps_ex.txt` (feature switches: recruitment slots per town, sprite
  format, trade fleets, portrait pools, building downgrade / conversion of culture...), grouped by the file's own
  headings, each value explained by the comment the engine writes above it. The engines read these two from the mod
  alone: a mod without them runs on the engine's defaults, and a change puts a copy in the mod.

**Find** looks through every file. A value that differs from the game's own shows the game's beside it, with
**Reset**. Change values, **Preview**, then **Write it in**: only the value itself changes in the file (the rest
stays byte for byte), with a backup - Tools > Restore a backup undoes it. A mod without its own copy of a file gets
the game's copy with your changes. The game reads the rules on the next start.

## Add-ons

![Add-ons](https://raw.githubusercontent.com/MasterOogwayHomebrew/RTW-M2TW-Campaign-Editor/main/docs/images/addons_sack_settlement.png)

The **Add-ons** button beside the editors lists ready-made scripts that add something new to the game. Pick the
settings, **Preview**, **Put it in** - a backup is made first. **Update it** changes the settings later, **Take it
out** removes it.

### Anyone's add-on (Add an add-on...)

**Add an add-on...** takes a Squirrel script (`.nut`) or a zip with one - REX (Rome) and M2EX (Medieval II) both
load every `.nut` in `script/modules` by themselves. The script is kept in the editor's own folder
(`CampaignEditor_addons` beside the exe) and shown in the list; its settings are found by themselves: the
UPPER_CASE `local NAME = value` lines at the top (true / false = a tick, a whole number, a number like 3.0, "text", a list
`["a", "b"]`, a set `{ a = true }`), with the `//` comment beside or above each as its help. Put it in, Update, Take
it out work as for the built-in ones (a backup each time). **Share...** saves it as a zip (with your settings or as
it came) plus a README - give it to others. **Remove from the list** forgets an added one. Only add scripts from
people you trust: a script runs inside the game.

For authors, optional header lines make it nicer: `// @title Border Tolls`, `// @game rome|medieval2|both`,
`// @summary ...`, `// @needs ...`, `// @settings A, B` (only these), `// @label VAR Words shown`,
`// @pick VAR chains|units|factions` (a picker filled from the loaded mod's own buildings, units or factions).

### Sack Settlement (Rome + REX)

A 4th choice on the capture scroll, under Occupy / Enslave / Exterminate. The town is exterminated the game's own
way, every building except the chains you keep is torn down, you get a reward per building and per inhabitant, and
the ruins go to the rebels with a garrison the game raises itself (from the region's rebel type). Land you do not
want to hold is burned and left to regrow.

- **Who may sack:** only the player (default), everyone, only factions without a town of their own (hordes), the
  player and hordes, only the computer, or the factions you pick. A computer faction allowed to sack does it
  whenever it exterminates a town.
- **Building chains never torn down:** walls and roads by default (take them out if you like) - **Pick...** lists
  the mod's own chains. The governor's building (the core chain) always stays, listed or not: without it the town
  could never be built up again. Every building standing in the town is read in the game, so one added in the
  editor or brought from another mod (Barbarian Invasion, say) is torn down like the rest.
- **People left in the ruins:** 600 by default and at least - a town cannot be wiped off the map (the games' own
  floor is 400 a level).
- **Rebel units if the game raises none:** **Pick...** lists the mod's own units.
- **The 4th button** off: Exterminate asks Yes / No to sack instead. Button text and tooltip are yours to change.

It is a REX module: it goes into the **game's** `script/modules` (`Rome Total War Gold\script\modules`) - REX's
own `script/main.nut` loads every `.nut` there when the campaign starts, whatever mod runs. A mod with a script
plugin of its own (its own `script/manifest.nut` and `main.nut`, like HLR's) does not load modules from its own
folder, so the editor never puts add-ons there. If the add-on's code is already pasted into the mod's own scripts,
**Put it in** refuses (it would run twice - two buttons). The game's log (`system.log.txt`) then says `[SACK] Sack
Settlement module loaded`. Plain Rome has no scripts - the add-on does nothing there.

### Player Diplomacy (Rome + REX)

The computer's factions stop attacking you when it makes no sense - only how they treat **you** changes, their wars
with each other stay as they are:

- **Truce:** after a ceasefire (whoever asked) a faction plans no invasion of you for the turns you set; a war it
  declares on you in that time is undone at once.
- **Client kingdoms** never plan to invade you while they are your protectorates.
- **Deterrence:** a faction far weaker than you (you **this many times stronger**, 3.0 by default: units in all
  armies and garrisons plus a number per settlement) does not plan one either; its allies already at war with you
  count on its side, so a big alliance still comes.

It works through REX's campaign AI hook (calculateLtgd). In the game's console: `sq ::truce_status()`,
`sq ::truce_set("egypt", 10)`, `sq ::power("egypt")`; its log lines start with `[DIPLO]`.

### Sack Settlement (Medieval II + M2EX)

The Medieval II brother of Rome's Sack Settlement - the same script, as M2EX runs the same scripts as REX.
Medieval II already has Occupy / Sack / Exterminate on the capture scroll, so its 4th button under them says
**Raze Settlement** (the words are a setting). It is drawn from the scroll's own text-button pieces, as wide and as
far apart as the game's three, in the game's font. It presses the game's own Exterminate, then tears down every
building except the chains you keep (the roads of cities and castles by default; the core chains - walls are their
levels in Medieval II - always stay), leaves as many people as you pick (600 at least), pays
a reward per building and per inhabitant, and gives the ruins to the rebels with a fresh rebel garrison
(`give_settlement slave`: M2EX turns the town rebel and raises the garrison itself).

- **Who may raze:** only the player (default), everyone, only factions without a town of their own (hordes), the
  player and hordes, only the computer, or the factions you pick. A computer faction allowed to raze does it
  whenever it exterminates a town.
- **The 4th button** off: Exterminate asks Yes / No to raze instead.

It goes into the game's `script/modules`, where M2EX's own scripts load it for every mod. The game's log says
`[RAZE] Raze Settlement module loaded`; in the console `sq ::raze_loot_probe()` lists what the capture scroll
reports and `sq ::raze_ui_fonts()` the game's fonts. An older version's Lua copy
(`eopData/eopScripts/raze_settlement.lua` and its line in `luaPluginScript.lua`) is taken out when this one is put
in. Vanilla Medieval II runs no scripts - the add-on does nothing there.
