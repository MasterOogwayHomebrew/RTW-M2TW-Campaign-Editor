# REX unit attributes (export_descr_unit.txt)

From REX's own notes, pasted by the project owner (2026-09-29). Where a key goes is given per group.
Used by the Unit editor to offer keys the engine knows even when no unit of the mod has them yet.

## Morale (`stat_mental` line)
| Key | Effect |
|---|---|
| `expendable` | does not give non-expendable units the "friendlies routing" morale penalty |
| `elitist` | ignores the "friendlies routing" penalty from non-elitist units |
| `steadfast` | smaller "friendlies routing" penalty |
| `intimidate` | lower-scale fear effect |
| `immune_to_psychology` | ignores fear effects |

## Fatigue (`attributes` line)
For scale: `hardy` = -2 fatigue rate, `very_hardy` = -4.
| Key | Effect |
|---|---|
| `relentless` | fatigue rate -2 |
| `disciplined_missile` | fatigue -1 while shooting |
| `inexhaustible` | never tires |

## Combat (`attributes` line)
| Key | Effect |
|---|---|
| `brace_for_charge` | stronger bracing: halves the incoming charge bonus when ready |
| `aggressive_push` | charge bonus +1 |
| `disciplined_charge` | slower charge decay (like power_charge: -2 per hit instead of -3) |
| `ai_cannot_skirmish` | the AI never puts the unit in skirmish mode |
| `ai_cannot_toggle_formation` | the AI never switches the unit to loose formation |

## Terrain (`stat_ground` line)
| Key | Effect |
|---|---|
| `desert_raider` | +2 in desert |
| `forest_ambusher` | +2 in forest |

## Management / unit size (`attributes` line)
| Key | Effect |
|---|---|
| `troublemaker` | garrisoned: public order -5 % per 80 soldiers, income - soldiers x 2 |
| `police` | garrisoned: public order +5 % per 80 soldiers |
| `client_kingdom_only_units` | recruitable only as a protectorate |
| `infinite_ammo` | never runs out of ammunition |
| `no_scale` | unit size ignores the unit-scale setting (soldier count as written) |
| `single_entity` | one figure, does not scale (like a general) |

## Other EDU keys
- `stat_pri_attr ... sp` - shield piercing: halves the target's shield value.
- `recruit_priority_offset` - AI recruitment weight (M2TW already has it; REX adds it to RTW).
- Formation: row spacing may be smaller than column spacing.
