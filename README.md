# fefeTray
Systray for visualizing state of blog.fefe.de (or other sites) - via Bash &amp; yad
 
![Tray with fefeTray](/pics/TRAY.png)
 
1. Get **yad** from your distribution.
2. Create a folder for ***fefeTray***.
3. Copy all fefe*.* files to the folder.
4. Run *bash fefeTray.sh > /dev/null &*. If you wanna close the Terminal.
5. DONE.
 
6. Or enable Logging (see remark in script)
7. Run *bash fefeTray.sh*. If you wanna follow the logging on the Terminal too.
 
8. Or enable Logging (see remark in script)
9. Run *bash fefeTray.sh > /dev/null &*. If you wanna log and close the Terminal.
 
 
With right-click on the tray icon you'll get 3 Options.
 
1. "Open Blog" - opens the tracked URL with your web browser. (Resets the NewData flag.)
2. "Stop" - ends the systray icon and the script.
3. "Reset" - resets the NewData flag.
 
Install- and Download Script will follow soon...
 
- **Actually just tested with x11 and IceWM!**
- With **Wayland** we may need the **XWayland** extension.
- With **gnome** you may need the **gnome-shell-extension-appindicator** extension.
 
*I'm on all of this... and I know there are other native tools for Wayland, Gnome and KDE... but fefeTray is just a "too hot to sleep" project of the last night...*
