# Edit a faction

**Edit faction** at the top, then pick the faction. The window fills with what it is now; change what you
want. Untouched fields and towns stay exactly as they are.

**The rebels** (`slave`) are in the list too: their armies, fleets, agents, garrisons, towns, buildings and
units are edited like any faction's. A rebel has a `sub_faction` - the faction whose look and name list it
uses: **+ Army** asks for it (**Rebels of**), a captain for an empty rebel town takes the nearest rebel's.
The rebels are never playable and have no capital, leader or heir.

## Faction tab

- Names, tooltip and campaign-screen text, colours, AI, money (denari), playable.
- **Towns**: add towns to **Chosen** to take them (their rebels leave; another owner's characters go to its
  other towns); take towns out to give them to the faction in **Removed towns go to** (rebels by default).
- **Capital** puts that town first in the faction's block.
- **Leader** and **heir**: new names (from the faction's name list) and ages.
- **Name list...**: the faction's men's names, surnames and women's names, typed in three steps (see
  [[New faction]]). Names its characters and family already carry stay in the list (Preview says which) - the
  game crashes on a name that is in no list.

## Units & armies

- A town's garrison opens as it stands now (marked *unchanged* until you click a card).
- The faction's armies, fleets and agents already on the map: change units, **Remove** an agent, captain or
  admiral (never a family member).
- **+ Army**, **+ Agent**, **+ Fleet** add new characters; **Place on map** puts them on a tile.

## Buildings

Every building chain the faction may build, with the game's picture of each level. The settlement level and
population follow a governor's building (a town with a governor's palace becomes a large town).

**City or castle (Medieval II).** *Settlement is a* (top right of the Buildings tab) turns the town into a castle or
a city. In Medieval II that is the settlement's own line in `descr_strat.txt` (`settlement castle`) together with
its buildings, which are either a city's or a castle's (each level says which in `export_descr_buildings.txt`). The
tool converts the buildings the game's own way: a level becomes the level its `convert_to` names in the matching
chain (a city's `wooden_wall` becomes a castle's `castle`, `town_guard` becomes `drill_square`, a church a chapel),
a level with no such line goes (a castle has no market or town hall), and the governor's building is fitted to the
settlement (a castle's level equals the settlement's, a city's is one below; a village castle has a motte and
bailey, a village city none). Only the kind's own buildings are offered afterwards. Castles go up to a large city
(a citadel); a huge city stays a city. Rome has no castles, so the choice is not shown there.

## Other tabs

- **Map**: drag the faction's characters, see [[Campaign map]].
- **Diplomacy**: per faction the **Status at the start** (neutral, **alliance** or **war** on the first turn, both
  games) and the AI feeling both ways (Rome: a number, lower is better, `600 (enemies)`; Medieval II: -1.0 to 1.0).
  A status pulls the feelings along; hover a column's **?**.
- **Family tree**: the button at the top of the Faction tab opens it in the form's place.
- **Victory** (on the Faction tab, under the leader): regions to hold, how many to take, factions to outlive, Rome's
  goal (be emperor / take Rome) - for the long and the short campaign. Only the player needs them, but a playable
  faction without them, or naming a region that does not exist, can crash the game. The list of regions or
  factions takes many at once: drag over the rows, Shift-click a run, **Tick all shown** (with Find), **tick a whole
  group** (every region a faction holds), or **On the map...** - click towns there, their regions turn yellow.
- **Art**: see [[Faction art]].
- **Roster**: give or take units and building levels - see [[Units and buildings]].
- **Family**: characters, traits, the family tree - see [[Characters and portraits]].

**Preview changes**, then **Apply changes**. One Apply writes every tab at once, with a backup. Picking
another faction with changes not written asks: apply them, drop them, or stay.
