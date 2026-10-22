#!/bin/bash
set -e
HERE="$(cd "$(dirname "$0")" && pwd)"
mkdir -p ~/bin ~/Applications ~/Library/Logs
cp "$HERE/android_clipboard.sh" ~/bin/android_clipboard.sh
chmod +x ~/bin/android_clipboard.sh
pkill -f AndroidClipboard 2>/dev/null || true
rm -rf ~/Applications/AndroidClipboard.app
osacompile -s -o ~/Applications/AndroidClipboard.app "$HERE/AndroidClipboard.applescript"
cat <<MSG

Built ~/Applications/AndroidClipboard.app

NEXT (one-time):
1. In the pane that opens, click +, press Cmd+Shift+G, add
   ~/Applications/AndroidClipboard.app and turn it ON.
   Also turn ON any entry named "applet" - that is the one that really matters.
2. Click Allow if macOS asks for access to Downloads.
3. Add the app under System Settings > General > Login Items.
4. Relaunch:  pkill -f AndroidClipboard; open ~/Applications/AndroidClipboard.app

MSG
open "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility" || true
open ~/Applications/AndroidClipboard.app
