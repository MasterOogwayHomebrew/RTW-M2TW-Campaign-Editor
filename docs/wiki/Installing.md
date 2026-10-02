# Installing

> ⚠️ **Only download the editor from this repository's [Releases](https://github.com/MasterOogwayHomebrew/RTW-M2TW-Campaign-Editor/releases) page** (or a link the author posted or approved). Never take the exe - or a "fixed" / "patched" copy of it - from another site, a file-sharing link or someone in a chat, and don't pass it on that way: a copy from elsewhere can be changed to harm your PC. Share the link to the Releases page instead.

1. Download `RTW-M2TW-Campaign-Editor.exe` from
   [Releases](https://github.com/MasterOogwayHomebrew/RTW-M2TW-Campaign-Editor/releases). No install needed.
2. Put it into the **game's folder** - beside `RomeTW.exe` / `medieval2.exe` (where REX or M2EX goes too).
3. Start it from there, or make a shortcut to it (on the desktop or anywhere).

It then finds the game and every mod in it by itself (Rome: `<game>\<mod>`, Medieval II: `<game>\mods\<mod>`),
and whether REX / M2EX is installed (the status line says so after Load). Have both games? Load a mod of the
other one once with **Browse...** - from then on the Mod list shows the mods of both.

Beside the exe it keeps two things of its own:

- `CampaignEditor_settings.json` - what it remembers between starts;
- `CampaignEditor_logs` - its log (`CampaignEditor.log`), the logs zips, and `sessions`: on every close the
  session's log and a copy of the game's newest `system.log.txt` (as `game_system.log.txt` - the game's own log, its
  errors are the game's, not the editor's) are saved there by themselves. **Report a bug** sends them.

**An update** is simply the new exe in the same place; the settings stay. An older version's
`RTW-M2TW-Campaign-Editor-files` folder is moved in by itself.

## The browser or Windows warns about the exe

The exe is not signed yet (a free certificate from the SignPath Foundation has been applied for), so the
browser and Windows SmartScreen may warn about it:

- the browser: **Keep**;
- SmartScreen: **More info -> Run anyway**.

The tool sends nothing over the network unless you press **Send** in *Report a bug / Suggest*. It reads and
writes only the game or mod folder you load and its own two files beside the exe.

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
