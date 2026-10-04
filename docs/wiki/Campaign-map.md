# Campaign map

The **Map** tab draws the campaign map tile by tile from the game's own map files: one square = one tile.
Big maps load too - a tester's mod with a map of 5456 x 2464 tiles (map_regions.tga pixels; vanilla Rome is 255 x 156) opened fine.

## Looking around

- **Wonders (Rome)**: a double click on one opens its window as the game shows it (picture, title, what it does,
  descriptions) with **View it in 3D**; **Put a wonder here** (right click on land) places one of the game's seven
  - Rome's exe and REX know no other types ("dont recognise this wonder type"), so a new wonder is one of them,
  its model, picture and texts changed if you like.
- **Delete from the map** (right click): a resource, a fort, a watchtower or a wonder goes with its line; a
  character of any faction goes with everything under him (his army or fleet); one placed but not written yet is
  simply taken out. Refused, in plain words: a faction's leader or heir, and a member of the family tree (take him
  off the tree in the Character editor first). A town is not deleted alone - every region of the map needs its
  town; give it to another faction instead (**Give this town to**).
- A town or character sign grows as the mouse comes near it - softly, the nearer the bigger, and from further away
  when the map is zoomed far out (the signs are small then), so the mouse need not hit the sign itself.
- Wheel zooms (to the point under the mouse), left drag moves the map - past its edges too: the map is a free canvas with an empty field around it, and zooms out smaller than the window; **Fit** puts it back in the middle.
- **Find**: type part of a name - a town (also the name shown for its owner), a port, a general, agent or
  fleet, a unit in an army (e.g. "hastati"), a fort, a resource. Pick a hit (click, or Down then Enter) and
  the map zooms in close on it and a ring blinks round it for a few seconds ([video](https://youtu.be/6WAdnGovGzA)).
- **The legend is a palette**: the signs on a button (+) are tools - click one (it turns yellow), then click
  the map to make one there: a **town** (first its region's names; then the click puts the town and the land
  around it becomes the new region's - paint more with a left drag), a **port** (click a coastal land tile: the
  port of the region there moves to it, a region without a port gets one), a **fort** or **watchtower**, any
  **resource**, an **army**, **fleet** or **agent** for **any faction**: click the tile and a window asks for the
  name - the faction is the one holding that land (a fleet: the owner of the nearest land), and another can be
  picked there. No faction has to be picked first. The faction you make or edit gets it in its list on Units &
  armies (give it its units there); any other faction's army or fleet starts with the first unit of its nearest
  army or fleet (its general's bodyguard) and is written with the next Apply.
  While a sign is picked it rides under the mouse (framed green where it may go, red where not - the reason beside
  it). Click the button again to stop; hiding the legend puts the picked sign down too. The legend is open on the
  first start (**Legend** on the bar hides it).
  Every named character shows as a general's flag, as in the game (family members too); an army in a town stands as a flag on the town's roof (no army, no flag). Towns, ports and characters grow under the mouse.
- **A double click on a town** (or the right click's **This town...**) opens the town's own window, both games, any
  owner (the Map editor too): its **owner** (hand it to another faction), **city or castle** (Medieval II), **level**,
  **population**, and two buttons that switch the same window: **Buildings** - the Buildings tab's own editor (the
  game's pictures, a level picked per chain, checked the way the game checks it: too small a town, a castle-only
  building in a city, one temple per town) - and **Garrison** - the Units & armies tab's card picker (click a card to
  add it, a garrison card to take it out; **Suggest** picks units the owner trains there; a named character keeps
  his bodyguard; a town nobody holds gets a captain). **Preview**, **Write it in** (a backup first). Another town
  opens in the same window. The right click's *Edit this town in Edit faction* still opens its owner in Edit faction.
- **Right click on the map**: on a town - **Give this town to** any faction (written with the next Apply; its
  characters go to the old owner's other towns, a captain's garrison goes with it); on a free tile - **New army /
  agent / fleet here** with the land's owner already picked; on a new character not written yet - **Take it out**.
- **Colours** (on the map's bar, also in Layers): one colour mode at a time - **Political** (the owners), **Diplomacy** (how the faction stands towards each owner), **Religion** (Medieval II: each region in its main religion's colour, paler where the majority is small; the legend counts the regions), **None** (the ground only).
- **Layers**: borders, town names, ports, characters, resources, relief, rivers, a tile grid when zoomed in.
- The line under the map describes the tile under the mouse: region, owner, ground, and whether an army may
  stand there.

## Map editor

**Map editor** (the first button of the top row) shows the map alone - no faction to pick, every faction alike:
drag any faction's towns, ports, armies, agents and fleets with the right button; right click a town to give it to
any faction, an army or a fleet for **Its units...** (the card picker in a window of its own - a general keeps his
bodyguard), a character to delete him, an empty tile for a new army, agent or fleet of any faction. Resources, forts,
wonders and regions work as on the Map tab. **Preview**, then **Apply changes** (a backup first; Restore puts every
byte back). New faction / Edit faction show all the tabs again; the map's changes stay until written.

**Delete a town with its region**: right click the town > **Delete this town with its region...**. Its land (and
its port) becomes the neighbour's it shares the longest border with - or pick another neighbour - and every file
that ties them follows: its block of `descr_regions.txt`, its settlement in `descr_strat.txt` (the owner's next
town becomes its capital; the rebels in the town go with it, a faction's characters there stay in the field), the
mercenary pools, the win conditions and Medieval II's music lists, in every campaign that uses the same map;
`map.rwm` is removed. Written at once after **Preview**, with a backup. Refused in plain words: a faction's last
town (it would die as the campaign loads), a region a faction rises in by an event, a town a campaign script names
(the lines are listed - change them first), an island with no land neighbour. The names lookup and the names
texts keep the old names (an unused name harms nothing).

## Towns and characters

- A click on a town adds it to **Chosen** or takes it out.
- A right drag (or Ctrl + left drag) moves characters, towns and ports. The target turns green or red: an
  army needs land it may stand on (no sea, mountains, dense forest, river, ford or cliff) or a town no other
  army holds; a fleet needs sea; an agent any land.
- **Moving a town or port** repaints its pixel in `map_regions.tga`, moves the characters in it, and deletes
  `map.rwm` - the game builds it again on the next start (the first start takes a little longer).

## Select: a box round many things at once

Tick **Select** on the Map's bar and choose in **what...** the kinds it takes: towns, armies, agents, fleets (ticked at
first), resources, forts. Then, as in a strategy game, **drag a box with the left button**: everything of those
kinds inside it is selected (hold **Shift** to add to what is selected). A click selects or unselects one thing. The
political colours and borders go meanwhile; selected towns and their regions turn **yellow**, selected characters,
resources and forts get a yellow frame; the **right button drags the map**. A **right click** offers:

- **Give the N selected town(s) to** any faction (written with the next Apply);
- **Delete the N selected character(s) from the map** (their armies too) - a faction's leader, heir or a man on its
  family tree stays (the line under the map names them); **Delete the N selected resource(s) / fort(s)**;
- **Add a building to the N picked town(s)...**, **Garrisons for the N picked town(s)...** and **City / castle and
  level for the N picked town(s)...** - all open the window *Buildings and garrisons for many towns* with the picked
  towns already chosen (the third tab makes them city or castle - Medieval II - and / or of another level: the
  buildings converted the game's way, the governor's building and the population follow);
- **Pick every town of <owner>** (on a town), **Unselect all**. One Undo takes a whole job back.

Untick **Select** and nothing stays selected (the same everywhere: switching **Edit resources** or **Edit regions** off drops what was picked or waiting for a click, hiding the legend puts its picked tool down).

The same window is in **Tools** and on the Buildings tab (**Many towns at once...**). All towns of the campaign on the
left - filter them by owner, level, city / castle (Medieval II) or name, **Add all shown** - the chosen ones on the
right, with **What happens** in each:

![Garrisons for many towns](https://raw.githubusercontent.com/MasterOogwayHomebrew/RTW-M2TW-Campaign-Editor/main/docs/images/many_towns.png)

- **A building**: pick the chain and level. A town that has the chain gets it raised (never lowered, unless you pick
  *set it to this level*). Left out, with the reason: a town too small for the level (`settlement_min`), a castle's
  building in a city or a city's in a castle (Medieval II), a level the owner's `requires factions { }` does not
  allow (tick the box to put it in anyway - the game loads such a building, the owner just cannot build it again),
  a port building where the town has no port on the map. **Take a building out** removes a chain. The governor's
  building (walls / castle) follows the town's level and is not offered.
- **Garrisons**: units per town *from 2 to 6* (any range up to 20) and the upkeep they may cost together per town
  (500, 1000... - empty for no limit). **Draw the garrisons** picks them at random from the units each owner may
  recruit (its `ownership` and a recruit line of some building; generals' bodyguards and - unless ticked - siege
  engines left out); a rebel town draws from its region's rebel type (`descr_rebel_factions.txt` - the units the game
  itself raises there in a revolt; without one, from the rebel armies nearest to it), so a Gallic town gets Gallic
  rebels. **As many units as the game gives such a town** sets the number by the town's level, the way the mod's own
  towns of that owner have them at the start (vanilla's rebel towns: Medieval II village 5, town 4, large town 7,
  city 6; Rome 3, 3, 4, 4).
  With **only units the town's own buildings recruit** (on by default) a town gets only what its own buildings
  recruit for its owner - no catapult in a village without a siege workshop, no heavy infantry without barracks; a
  town that recruits none of them gets the two cheapest unit types (peasants, levy spearmen).
  Draw again for others. They join the army that holds the town, or replace its units (a general keeps his
  bodyguard); a town nobody holds gets a captain.

**Preview** shows every line, **Write it** writes `descr_strat.txt` with a backup - Restore gives it back.

## Forts

Forts and watchtowers of `descr_strat.txt` (Medieval II, REX: `fort x y ... permanent name ...`) are drawn as small
towers, the top in the owner's colour; the mouse over one shows its name and whether it is permanent. No army or
agent is placed on a fort's tile. Barbarian Invasion's watchtowers (listed after the diplomacy) are drawn too.

Forts, watchtowers and wonders need no mode of their own - everything is in the legend and on the right click.
**New**: click *a fort* or *a watchtower* in the legend, then a land tile on the map. **Move**: drag one with the
right mouse button to another tile (land, no town, port or other fort there). **Remove**: right click it -
**Delete from the map**. A new one copies the line of the nearest one the campaign already has (only the tile
changes); a campaign with none (vanilla Rome and Medieval II) gets it written in the regions section. Written with
Preview / Apply, backed up like every change.

## New regions

Tick **Regions**: every region in its own colour.

1. **New region...**: names, builder, rebels, region tags (hidden resources), triumph, farming, owner,
   settlement level. The tool picks an unused colour.
2. Paint its land with a left drag (brush 1-6 tiles). Right click a region to paint with that one - the same
   brush moves the border between two existing regions.
3. **Place its town** (and **Place its port** on the coast).
4. **Preview** lists everything written: `map_regions.tga`, `descr_regions.txt`, the name lookup, the region
   labels, the settlement, `map.rwm` removed.

A new region is in the towns list at once: a new faction can start there, and an edited one can take it, all
in one Apply. **Edit region...** opens a region's data again. For a region of the map it holds both names of the region and its town: the names players see (written to the campaign's `<campaign>_regions_and_settlement_names.txt` with the next Apply) and the names in the files (changed at once in every file that names them, with a backup - asked first). **Rename...** beside the towns list on the Faction tab (or a right click on a town there) opens the same window.

**Settlements tab:** every region and its town, both names. **Rename in the files...** (also on the Map: Edit regions, right click the region, then **Edit region...**) changes the system names (`Latium`, `Rome`) everywhere the mod uses them - descr_regions, descr_strat, the names lookup and texts of every language, mercenaries, win conditions, campaign scripts, trait and ancillary conditions - as whole words; comments, descriptions, lines naming a faction of the same name and people's names (descr_names, names.txt, a character named like the town) stay. Preview first, a backup, `map.rwm` removed. Tip: keep the name players see and the name in the files alike.

## Events and factions that appear later

**Events...** (top row) (both games): the campaign's `descr_events.txt` - historic messages, and
plagues, volcanoes, earthquakes at a place. Each event's date (Rome: years from the start and optionally summer or
winter, `14 winter`; Medieval II: years from the start, or two the game picks one between, `210 220` - a date
the game would not read is refused; beside it the turn and the year it means, from the campaign's `start_date` and
`timescale`; a new event goes in date order - the games read the events as a queue, one put after a later event
never fires), its place (x, y; empty = a message only; **Show on the map**), the title and text
players see (`historic_events.txt`), the **picture players see** on the scroll (a historic event its own
`ui/<culture>/eventpics/<event>.tga` - **Picture...** puts yours in for every culture, sized like the game's; a
plague, volcano... shows its kind's `disaster_<kind>.tga`) and **what it does in the game** in plain words.
**New event...**, **Remove**, Preview, Write it in with a backup. Below the
list: **the factions that appear later** - they start dead (`dead_until_resurrected` in descr_strat.txt, no towns,
no characters) and come in *by an event* (`emergent_faction` with a date and a region the rebels hold, as Barbarian Invasion's
slavs - only those are offered), *as the shadow of a faction*
(the side that splits off it in a civil war, Barbarian Invasion's rebels of the empires) or *splitting off a faction
in a revolt* (Barbarian Invasion's Ostrogoths); the campaign script lines that wake one are shown too (Medieval II:
the Mongols and Timurids). **Change...** (or a double click) changes how a faction comes in - its date and region,
its partner, *may come back after it dies* (`re_emergent`); **Another faction...** makes a faction without towns
and characters appear later. Written with Write it in, every file in step (descr_sm_factions, descr_strat,
descr_events).

## Resources

Trade goods on the map can be placed, moved and removed; one per tile. Tick **Edit resources**: a bar opens under
the map's buttons. **New**: pick the resource, press **Place new**, then click a land tile on the map. **Move**: drag
one with the right mouse button. **Remove**: click it (it gets a yellow frame), then **Delete picked**. A region's
resources are the ones on its land; **Region tags (hidden resources)...** edits the region's tag line.

## Medieval II

Religions per region (**Religions...**); castles; agents such as merchants, priests and princesses.

**A faction's religion** (the Religion field of the Faction form) pulls what hangs on it along: the faction leaves
the old faith's buildings (temples and that faith's guilds - the `religion X` chains of export_descr_buildings.txt,
their levels and the priest lines in them) and gets the new faith's wherever a faction of that faith has them (one
of its own culture first, as a model), and its priest, bishop and cardinal on the campaign map take that
faction's figures. Preview lists every line; units and traits of the old faith (crusaders, jihad, the Pope's
favour) stay as they are - Preview says so.

**New religion...** (Map tab, Regions) adds a religion of your own - e.g. Judaism - everywhere the game needs
it: descr_religions.txt (its name and symbol), descr_religions_lookup.txt, text/religions.txt (without its
text the game crashes silently), its symbol in ui/pips (your picture as a 24-bit TGA, or a copy of another
religion's), and every region's religions line at 0 %. Then give it its share per region with **Religions...**
(each region adds up to 100) and, if you like, the factions that follow it. The game takes at most 9 religions
(vanilla has 5). Temples, priests and traits of its own are not made - Preview says which files still name
only the old religions.

## Settlement names by culture (REX / M2EX)

**Names by culture...** (next to *Edit region...* on the Faction tab, and on the Map's region bar) gives a town a
name for each culture of its owner, plus a name for every other culture. The engine (REX on Rome, M2EX on
Medieval II) renames the town when it changes
hands - as soon as a general takes it, and at each of its owner's turns. The tool writes it into the campaign's
`campaign_script.txt` (it makes one when the campaign has none; a script of the mod's own stays as it is around the
tool's block), with a backup like every write. Needs REX (Rome) or M2EX (Medieval II). Checked in the game on Medieval II with M2EX
([video](https://youtu.be/umwRyWkHoDE)).

The window shows it at once: take a town for a faction (on the Faction tab or by clicking it on the Map) and its
label on the map changes to the name for that faction's culture; the towns list shows the name a town has now.

**All towns' names...** (on the Faction tab, in the per-town dialog and under **Tools**) shows every town in one
table: one column per culture plus *every other*, the owner, its culture and the name shown now. Sort by any
column, filter by a culture (towns with or without a name for it), by the owner's culture, by what waits for Apply,
or search. Double click a culture's cell to type a name in place (Enter keeps it, Esc drops it, an empty cell
removes it). Towns the mod's own campaign script renames are shown grey and are not edited here.

## Make the map 3 x bigger (Tools)

**Bigger map (x3)...** (top row) turns every tile into a 3 x 3 block (both games). Towns, ports, armies,
agents, fleets, resources, forts, watchtowers, wonders and event positions keep their places; every town keeps its
own region all round it, every port stands on the shore touching the sea and its region; the coast is drawn smooth,
not in squares, and the heights follow the same coast; every tile keeps the ground type and climate of the old tile
it lies in (a forest stays a forest); land bridges stay unbroken; the relief is blended smooth, and `map_heights.hgt` (the game's own
copy of the heights, read instead of the picture) is written at the new size; the hills, mountains and sea floor are
made 3 x higher so the slopes stay as steep (**Write it - hills 3 x higher**; or keep the old heights, a flatter world: **Write it - heights as they are**); rivers stay
1 pixel wide and run on to the new coast (stopping there); the beach stays one tile wide along the new coast; every picture of the map and `descr_terrain.txt` follow, `map.rwm` is
removed. The window lists every file first; one backup, Restore gives it all back.

![The coast of Italy made 3 x bigger: before (squares), after (smooth)](https://raw.githubusercontent.com/MasterOogwayHomebrew/RTW-M2TW-Campaign-Editor/main/docs/images/bigger_map_coast.png)
The campaign's scripts follow too: every place on the campaign map in `campaign_script.txt` (spawned armies and characters, `reposition_character`, `move`, the camera, `reveal_tile`, forts and resources made by `console_command`, 'near a tile' distances, 'in a rectangle' sizes) goes to its block; battle positions in the same script stay. Lines the editor cannot read for sure, and Lua / Squirrel scripts that place things by tile (not the engines' own interface scripts), are listed to check by hand.
Past 510 tiles the original exes need REX / M2EX.
The map's real size is shown under the map, bottom left.

## Wonders (Rome)

The wonders (`landmark` lines of `descr_strat.txt`) show as golden pyramids - drag one with the right mouse button;
a double click (or the right click's *about it*) opens its window as the game shows it, with **View it in 3D**; the
right click on free land has **Put a wonder here**, on a wonder **Delete from the map**.
