# Installing

> ⚠️ **Only download the editor from this repository's [Releases](https://github.com/MasterOogwayHomebrew/RTW-M2TW-Campaign-Editor/releases) page** (or a link the author posted or approved). Never take the exe - or a "fixed" / "patched" copy of it - from another site, a file-sharing link or someone in a chat, and don't pass it on that way: a copy from elsewhere can be changed to harm your PC. Share the link to the Releases page instead.

1. Download `RTW-M2TW-Campaign-Editor.exe` from
   [Releases](https://github.com/MasterOogwayHomebrew/RTW-M2TW-Campaign-Editor/releases). No install needed.
2. Make a **new, empty folder** for it, for example `Documents\RTW & M2TW Campaign Editor` - not the game
   folder, not straight into Downloads or onto the desktop - and put the exe there.
3. Start it from there.

Next to the exe it makes the folder `RTW-M2TW-Campaign-Editor-files` with its settings, and inside it the
folder `logs` with the tool's log (`faction_tool.log`) and the logs zips you send with a bug report. **An update** is simply the new exe in the same folder; the settings stay.

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

**Linux** (Mint, Ubuntu, Debian...): the window needs tkinter and Pillow's Tk part, which the distribution
ships apart from Python. Install them once, then start the tool with `python3`:

```
sudo apt install python3-tk python3-pil python3-pil.imagetk
python3 rtw_faction_tool.py
```

Fedora: `sudo dnf install python3-tkinter python3-pillow-tk`; Arch: `sudo pacman -S tk python-pillow`.
Without tkinter the tool says what to install instead of a Python error.
