# android-mac-clipboard

Quick and native text copy-paste from **Android** to **Mac**. (Inspired by Apple ecosystem's copy-paste feature)

Share text via Quick Share, press **Cmd+V** on the Mac. No taps on the Mac, nothing to install on the phone, works natively. <br>
Bonus: No need to manually click "Accept" even when receiving files from an Android phone.

Built and tested with a **Pixel 11** on **macOS 27**. Google's [Quick Share ↔ AirDrop page](https://www.android.com/quick-share/with-iphone/) lists the Android phones that can AirDrop (Pixel, Samsung Galaxy, OnePlus, OPPO, HONOR, vivo, Xiaomi and more). The Mac side only reacts to the AirDrop prompt, so it should work with those too.

## The problem
- Apple's Universal Clipboard only works between Apple devices.
- Android phones with Quick Share can AirDrop texts and files to a Mac, but text arrives as a `.txt` file which is incovenient.
- Android phones don't have an Apple ID logged in, so macOS always shows an **Accept** prompt which requires additional clicks (1 for text, 2 for files). There's no setting to turn that off.

## How it works
A small stay-open AppleScript app runs in the background and checks once a second:

1. **Auto-accept.** It watches Notification Center for the AirDrop banner and clicks Accept through the Accessibility API.
   - Text: the banner's buttons have no labels, so it clicks button 2 (Accept).
   - Files: Accept is now a dropdown with 2 options (Save to Photos, Save to Downloads) and no scriptable items, so it automatically presses `↓ ↓ Return` and picks *Save to Downloads*.
2. **Clipboard.** A shell script takes any new `.txt` in `~/Downloads`, pipes it into `pbcopy` (Mac Clipboard), and deletes the file.

## Install
```bash
git clone <this repo> && cd android-mac-clipboard
./install.sh
```
Then grant the permission (see below), add the app to Login Items, and relaunch it.

### Permission
On **macOS 27** the pane is *Privacy & Security → Device Control and Data Access* (*Accessibility* on older versions).
Turn on both `AndroidClipboard` and the entry named **`applet`**. The permission attaches to the inner `applet` binary, and it must be re-granted (remove with −, re-add with +) after every rebuild.

On the first text transfer, macOS also asks to let the app access your Downloads folder. Click Allow.

### Sending from the phone
Set the Mac's AirDrop to *Everyone for 10 Minutes*, then Quick Share to the Mac. On Samsung, turn on *Share with Apple devices* in Quick Share settings.

## Caveats
- **It auto-accepts every AirDrop while running.** Keep AirDrop on *Contacts Only* or quit the app in places where you don't want this to happen.
- Any `.txt` landing in `~/Downloads` within a minute is copied and then deleted with `rm`, so it skips the Trash and can't be recovered.
- Keystrokes go to the focused app, so avoid typing while a file is arriving.

## Debugging
- `cat ~/Library/Logs/android_click.log`: "not allowed assistive access" means the `applet` permission needs re-granting.
- `tail ~/Library/Logs/android_clipboard.log`: shows copy/delete results.

## Uninstall
```bash
pkill -f AndroidClipboard
rm -rf ~/Applications/AndroidClipboard.app ~/bin/android_clipboard.sh
```
Then remove it from Login Items and the permission list.

## License
MIT
