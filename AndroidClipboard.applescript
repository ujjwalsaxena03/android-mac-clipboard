-- Stay-open applet: runs every second.
-- 1) copies any new .txt in ~/Downloads to the clipboard
-- 2) auto-accepts an incoming AirDrop prompt from a non-Apple device
on idle
	try
		do shell script "/bin/bash ~/bin/android_clipboard.sh"
	end try
	try
		tell application "System Events" to tell process "NotificationCenter"
			set g to group 1 of scroll area 1 of group 1 of group 1 of window 1
			if ((value of every static text of g) as text) contains "would like to share" then
				if exists menu button "Accept" of g then
					-- files: Accept is a dropdown (Photos / Downloads). Items are not
					-- scriptable, so use the keyboard: down x2, Return = Save to Downloads.
					perform action "AXShowMenu" of menu button "Accept" of g
					delay 0.6
					repeat 2 times
						key code 125
						delay 0.2
					end repeat
					key code 36
				else
					-- text: plain buttons with no labels; button 2 is Accept
					click button 2 of g
				end if
			end if
		end tell
	on error m
		if m does not contain "Invalid index" then do shell script "echo " & quoted form of m & " >> ~/Library/Logs/android_click.log"
	end try
	return 1
end idle
