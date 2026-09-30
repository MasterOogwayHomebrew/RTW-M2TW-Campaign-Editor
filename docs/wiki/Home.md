# RTW & M2TW Campaign Editor

A campaign editor for **Rome: Total War** (with Barbarian Invasion and Alexander, plain or modded, on REX or
the original exe) and **Medieval II: Total War** (with Kingdoms, on M2EX or the original exe). It edits the
game's or a mod's own data files, shows every change before writing it, keeps a backup and can undo it byte
for byte.

**Download:** the latest `RTW-M2TW-Campaign-Editor.exe` from
[Releases](https://github.com/MasterOogwayHomebrew/RTW-M2TW-Campaign-Editor/releases) (only from there - see [[Installing]]) ·
**▶ Video:** [what the editor does, in a few minutes](https://www.youtube.com/watch?v=m1sCPg-Lzsw)


## 🎬 More videos

All on my YouTube channel **[Pfadfinder](https://www.youtube.com/channel/UC8j5rv6mTmtvRR8u7NmaCvQ)** - each one checked in the game:

<table>
<tr>
<td align="center" width="25%"><a href="https://youtu.be/z0T723riXaU"><img src="https://img.youtube.com/vi/z0T723riXaU/mqdefault.jpg" width="200" alt="Editing rivers, fords, cliffs"><br><b>▶ Editing rivers, fords, cliffs</b></a></td>
<td align="center" width="25%"><a href="https://youtu.be/mTdRAWympuw"><img src="https://img.youtube.com/vi/mTdRAWympuw/mqdefault.jpg" width="200" alt="Editing a height map"><br><b>▶ Editing a height map</b></a></td>
<td align="center" width="25%"><a href="https://youtu.be/6WAdnGovGzA"><img src="https://img.youtube.com/vi/6WAdnGovGzA/mqdefault.jpg" width="200" alt="Searching the map for settlements and units"><br><b>▶ Searching the map for settlements and units</b></a></td>
<td align="center" width="25%"><a href="https://youtu.be/umwRyWkHoDE"><img src="https://img.youtube.com/vi/umwRyWkHoDE/mqdefault.jpg" width="200" alt="Settlement names by culture"><br><b>▶ Settlement names by culture</b></a></td>
</tr>
</table>

## A look inside

| | |
|---|---|
| ![Edit a faction](https://raw.githubusercontent.com/MasterOogwayHomebrew/RTW-M2TW-Campaign-Editor/main/docs/images/edit_faction.png) | ![The campaign map](https://raw.githubusercontent.com/MasterOogwayHomebrew/RTW-M2TW-Campaign-Editor/main/docs/images/map.png) |
| **Edit a faction** | **The campaign map** |
| ![Terrain editor](https://raw.githubusercontent.com/MasterOogwayHomebrew/RTW-M2TW-Campaign-Editor/main/docs/images/terrain_editor.png) | ![Unit editor](https://raw.githubusercontent.com/MasterOogwayHomebrew/RTW-M2TW-Campaign-Editor/main/docs/images/unit_editor.png) |
| **Terrain editor** | **Unit editor: model and voice** |

## Made to be easy

The aim of this tool is to make modding friendly for everyone, not only for people who know every file of
the game by heart. You work with factions, towns, armies and the map - the tool finds the files, the lines
and the formats for you:

- **No digging in files.** Pictures are made the right size and format and put in the right place; names,
  texts, units, cards and buildings that belong together are kept in step for you.
- **See it before it happens.** Preview shows every file and line before anything is written.
- **Nothing is lost.** Every write has a backup, and Restore gives the files back exactly as they were;
  Undo / Redo work in the window.
- **Mistakes are caught early.** Things the game would crash on (a name it has no text for, an army on a
  tile it refuses, a town with two settlements...) are refused or warned about, with the reason in plain
  words.
- **Set-up problems fixed with a yes.** Things that stop the game from starting are found when you load it
  and fixed only when you agree.

Something confusing or hard to find? That counts as a bug too - tell us ([[Reporting a bug]]).

## Start here

1. [[Installing]] - where to put the exe, what it makes next to it.
2. [[First steps]] - load a mod, pick a campaign, a separate mod folder.
3. [[New faction]] - a new faction cloned from a template.
4. [[Edit a faction]] - change a faction that is already in the game.

## Guides

- [[Campaign map]] - the map, towns and ports, characters, new armies, new regions.
- [[Terrain editor]] - ground, rivers, fords and cliffs.
- [[Faction art]] - every picture of a faction, banners, the campaign-select map.
- [[Characters and portraits]] - family tree, traits, portraits and the portrait library.
- [[Units and buildings]] - the unit and building editors, battle models in 3D, unit voices, the roster, unit packs.
- [[Campaign rules and Add-ons]] - every campaign setting in plain words; Sack Settlement and other add-ons.
- [[Backups and Restore]] - how nothing gets lost.
- [[Reporting a bug]] - what to send when something goes wrong.

## Why a clone?

A new faction starts as a **copy of a faction that already works**. It starts in the game at once, so every
change after that can be checked in the game straight away, instead of building a faction from nothing
before the first test. The clone **adds** a faction and never touches the template: files the new faction
needs are copied under its own name (Epirus cloned from Macedon gets `standard_epirus`, `symbol128_epirus`,
`map_epirus`...), and its lines point at them.

## What is where

- [ROADMAP](https://github.com/MasterOogwayHomebrew/RTW-M2TW-Campaign-Editor/blob/main/ROADMAP.md) - what it
  does, what is being tested, what comes next.
- [CHANGELOG](https://github.com/MasterOogwayHomebrew/RTW-M2TW-Campaign-Editor/blob/main/CHANGELOG.md) - what
  changed in each version and what was tested in the game.
- [README](https://github.com/MasterOogwayHomebrew/RTW-M2TW-Campaign-Editor#readme) - the full reference.

The editor is free. If it saves you time, a coffee on [Ko-fi](https://ko-fi.com/pfadfinder) keeps new
features coming.
