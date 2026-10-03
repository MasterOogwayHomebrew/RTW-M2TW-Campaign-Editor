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

### Module builder (your own add-on, no code)

![Module builder](https://raw.githubusercontent.com/MasterOogwayHomebrew/RTW-M2TW-Campaign-Editor/main/docs/images/module_builder.png)

**Tools > Module builder...** or **Add-ons > New module (no code)...** puts an add-on together from blocks. REX (Rome)
and M2EX (Medieval II) run the same script, so one module works in both games; the original exes run no scripts.

- **WHEN** - what happens in the game: a faction's turn starts, a town's turn starts (each town), a general takes a
  town, a building is finished, a unit is trained, a battle ends (for each general in it), a town riots, rebels or
  grows to its next level, a faction is destroyed, a faction gets a new leader, a son comes of age. Under it the
  window says what the event brings along (a faction, a town, a general, the town's old owner, a unit).
- **IF** - only when all of these hold: the faction is the player / a computer faction / one of the factions you pick;
  its money; its number of towns; the turn (or every N turns); a chance in percent; the town's people; the town is
  one of those you pick; the town is the faction's capital; the town has a building of a chain; the town's old owner.
- **DO** - in this order: give money (below 0 takes it) to the faction, the old owner, the player, the rebels or a
  faction you name; add people to the town, take a share of them, or keep at most a number (a ceiling); build a
  building level; tear down a chain (the governor's `core_` buildings never); new units in the town; give the town to
  someone; set war, peace or alliance between two factions; give the general a trait or a retinue member; show the
  game's own message scroll (title and text); write a line in the game's log; run a console command (for experts).
  In the log line and the console command `{town}`, `{faction}`, `{owner}`, `{general}`, `{turn}` and `{people}` are
  filled in.

**The engines' own lists** - for those who know them: **a game condition (any of the engine's)** takes any line of
the engines' condition list (`FactionType england`, `Trait GoodCommander > 0`, `not I_TurnNumber < 3`...), checked
against what just happened; **run a console command** and **run a campaign-script command** take any line of those
lists (`kill_character "{general}" Battle`, `set_event_counter my_counter 1`...). **Pick...** beside the line lists
every one with a search - its form, a sample, where it works, what a condition needs from the event - and **its
parameters as fields**: factions, towns, regions, units, characters, traits, retinue members and buildings picked
from the mod (the event's own `{faction}`, `{town}`, `{general}` first - filled in when the module acts), comparisons
and choices from a list, with the line put together under them (a line already there is read back into the fields).
Under the line the builder shows the form of the one typed. A module for both games offers what both engines have (299 conditions,
142 console and 198 campaign-script commands); for one game, that engine's whole list. The engine's own description
shows when the game has its `documentation` folder: start the game with REX / M2EX, open the console and type
`dump_docudemon` once. What an event brings comes from the engines' lists too (REX's 'a general takes a town' has no
old owner; REX has no 'a town grows' event - make such a module for Medieval II only).

**Any event and numbers kept between turns**: **More events...** beside WHEN picks any event of the engines' own
list (`SettlementTurnEnd`, `CharacterTurnEnd`, `AddedToBuildingQueue` on Medieval II ...), with what it brings. IF
**a remembered number** and DO **remember a number** / **add to a remembered number** keep numbers between turns and
in the saved game (the engines' own event counters - campaign_script's `I_EventCounter` reads them too); a name like
`seen_{town}` keeps one number per town.

`+ another condition...` / `+ another action...` add a line (one that needs what the event does not bring is greyed
out, with the reason), `x` takes it out. Names come from the loaded mod: its factions, towns, units, building chains
and levels, traits and retinue members. **In plain words** below says what the module will do, and the line under it
what is still missing.

**What the player may change later**: tick any number or text and it becomes a setting on the Add-ons page (the words
beside it are what the page shows); **Module on** and **Only once in a campaign** are always there.

Nine examples start it, made for the loaded mod: Help when broke, Loot for taking a town, Plague in big cities,
A free unit when a barracks is built, Gold for holding the capital, A message on turn 10, Rebellion punished,
A trait for the conqueror, Avoid Growth for chosen towns. **Show the script** shows what it writes; **Check it** checks
the names against the mod; **Save to my add-ons** keeps it in the Add-ons list; **Put it in the game** writes it into
the game's `script/modules` and its messages into the mod's `text/custom_messages.txt` (a backup first - Restore
undoes it); **Share...** saves it as a zip. A saved module opens in the builder again: **Add-ons > Change it in the
Module builder...**. Each time it acts, the game's log (`system.log.txt`) gets a line starting with its name, like
`[HELP_WHEN_BROKE]`.

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

### Avoid Growth (Rome + REX, Medieval II + M2EX)

A tick box **Avoid Growth** on the settlement scroll of each of your towns, drawn with the game's own box and tick
(the same pieces as its other ticks), under the population figures. Tick it and the people the town has right
now become its **ceiling**: it never grows past it, it still loses people the usual way (recruiting, battles,
plague, hunger) and then grows back - but only up to the ceiling again. A border town stays the village, town or
city it is: put it on auto-manage and forget it. Untick it to let the town grow freely again.

- The ceiling is kept in the saved game; a town taken by another faction drops its tick.
- **Words beside the tick**, **Tooltip**, **Show the ceiling** ("(at most 5000)") are yours to change;
  **Move the tick right / down** shifts it on the scroll (in the game's 1024 x 768 units, below 0 = left / up).
- One script for both games (REX and M2EX run the same scripts), in the game's `script/modules`. The game's log says
  `[GROWTH] Avoid Growth module loaded`; in the console `sq ::avoid_growth_list()` lists the ticked towns and
  `sq ::avoid_growth_probe()` what the settlement scroll reports.

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
