# Installing

1. Download `RTW-M2TW-Campaign-Editor.exe` from
   [Releases](https://github.com/MasterOogwayHomebrew/RTW-M2TW-Campaign-Editor/releases). No install needed.
2. Make a **new, empty folder** for it, for example `Documents\RTW & M2TW Campaign Editor` - not the game
   folder, not straight into Downloads or onto the desktop - and put the exe there.
3. Start it from there.

Next to the exe it makes the folder `RTW-M2TW-Campaign-Editor-files` with its log, its settings and the logs
zips you send with a bug report. **An update** is simply the new exe in the same folder; the settings stay.

## The browser or Windows warns about the exe

The exe is not signed yet (a free certificate from the SignPath Foundation has been applied for), so the
browser and Windows SmartScreen may warn about it:

- the browser: **Keep**;
- SmartScreen: **More info -> Run anyway**.

The tool never sends anything over the network. It reads and writes only the game or mod folder you load and
its own `RTW-M2TW-Campaign-Editor-files` folder.

## Without the exe (any OS)

With Python 3.8 or newer: `python rtw_faction_tool.py` from the repository (standard library; Pillow for the
pictures: `pip install pillow`).
