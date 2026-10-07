#!/bin/bash
# Session start (Claude Code on the web): the checks' tools, the private notes beside the editor, and the rule that
# every session reads all of them first. Safe to run again; never fails the session.
set -uo pipefail

if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0
HOME_DIR=/home/user

# the tools CI runs (ruff first, then the tests; Pillow for the picture tests)
python3 -m pip install -q ruff==0.15.20 pillow >/dev/null 2>&1 || true

# the notes ONLY: editor-notes/ of the private RTW-game-data, sparse, no game files (the owner's word). The game
# files and the reports are cloned by hand when the work needs them.
URL=https://github.com/MasterOogwayHomebrew
RTW="$HOME_DIR/rtw-game-data"
if [ -d "$RTW/.git" ]; then
  git -C "$RTW" pull -q --ff-only >/dev/null 2>&1 || true
else
  git clone -q --depth 1 --filter=blob:none --sparse "$URL/RTW-game-data.git" "$RTW" >/dev/null 2>&1 \
    && git -C "$RTW" sparse-checkout set editor-notes >/dev/null 2>&1 || true
fi

NOTES="$HOME_DIR/rtw-game-data/editor-notes"
if [ -f "$NOTES/CLAUDE.md" ]; then
  cp "$NOTES/CLAUDE.md" ./CLAUDE.md 2>/dev/null || true
  STATE="The notes are cloned at $NOTES."
else
  STATE="The notes are NOT here yet: attach MasterOogwayHomebrew/RTW-game-data, M2TW-game-data and
RTW-M2TW-Campaign-Editor-Reports to this session (add_repo, access push), clone them into $HOME_DIR/rtw-game-data,
$HOME_DIR/m2tw-game-data and $HOME_DIR/rtw-m2tw-campaign-editor-reports, then read the notes."
fi

cat <<MSG
RULE NUMBER ONE (the project's owner): before ANY work, read ALL the notes in $NOTES strictly and in full -
CLAUDE.md, START_HERE.md, READ_AFTER_CLEAR.md, limits.md, NEXT_CHAT.md, rules.md, open.md, capabilities.md, tool.md,
ux_heuristics.md, modding_knowledge.md, TESTER.md, rtw_files.md, m2tw_files.md (history.md, HANDOFF.md,
missing_game_files.md: their heads) - and every tester/*/summary.md of the reports repo (the game repos and
the reports are NOT cloned by this hook - clone them by hand when the work needs them). Not only the top blocks.
The rules and decisions in them are binding. Say in the first answer that all notes were read.
$STATE
MSG
exit 0
