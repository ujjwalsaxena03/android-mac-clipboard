#!/bin/bash
# Copies the contents of any freshly received .txt in ~/Downloads to the
# clipboard, then deletes the file (rm: no Trash, not recoverable).
export LANG=en_US.UTF-8
exec >>"$HOME/Library/Logs/android_clipboard.log" 2>&1
DIR="$HOME/Downloads"
find "$DIR" -maxdepth 1 -type f -name '*.txt' -mmin -1 | while IFS= read -r f; do
  # wait until the file has finished being written
  s1=-1; s2=$(stat -f%z "$f" 2>/dev/null || echo 0)
  while [ "$s1" != "$s2" ]; do s1=$s2; sleep 0.5; s2=$(stat -f%z "$f" 2>/dev/null || echo 0); done
  if [ -s "$f" ] && /usr/bin/pbcopy < "$f"; then
    rm -f "$f" && echo "$(date) copied+deleted: $f"
  else
    echo "$(date) FAILED (read/copy): $f"
  fi
done
