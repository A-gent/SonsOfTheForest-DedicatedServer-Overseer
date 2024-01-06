# SonsOfTheForest-DedicatedServer-Overseer
Very simple example of an options-based binary to oversee the SOTF dedicated server process, and if it closes, re-open it
  
  <br />
  <br />
  <br />
  
-INSTALLATION-

1.) Navigate to the [Releases](https://github.com/A-gent/SonsOfTheForest-DedicatedServer-Overseer/releases) page and download <b>either</b> A.) the raw source AHK script itself, B.) the compiled AHK .exe binary, or C.) the 7zip package that includes both. Which you choose is your choice. Overseer_NoComments.ahk is a carbon copy of Overseer.ahk, it simple does not have any comments to exlain anything. Likewise, Overseer.ahk has full commenting to explain everything that's going on. <br /><br />
2.) Create a folder that you wish to be the home of the Overseer, its recommended you create a folder for it and put it in a folder of its own.<br /><br />
3.) If you downloaded just the raw source AHK script itself, then install [Autohotkey v1.1](https://www.autohotkey.com/download/ahk-install.exe).<br />If you just downloaded the compiled .exe, you don't even need Autohotkey installed for this to run.<br /><br />
4.) Run the .exe or .ahk file, it will build the settings.cfg inside the same folder. To run at startup, make a Windows Task Scheduler task that runs at Windows logon. <br /> <br /> <br />

-USAGE-<br /> <br />
-When script is active, it will have an icon in the bottom right system tray on the taskbar. If you right click this icon, there are a few buttons here to have more direct / easy control of the script system's functions. <br /> <br />
-The 'settings.cfg' that is generated when you run the script the first time holds a few useful options that can help you customize this script's function. <br /> <br />
-If you want to use this for anything other than the SOTF dedicated server, all you have to do is <b>either</b> right click the script's icon in the system tray and click 'Settings' or manually navigate to the script's folder and open settings.cfg yourself. Once open, you can change the current value of 'DedicatedServerDirectory' to the directory of any application you choose; then change the value of 'DedicatedServerEXE' to the .exe that's inside the new directory you've just set. These keys are under the 'ENGINE' section of the config file. <br /> <br />
-You can set the speed of the re-launching Watcher timer using the 'WatchSOTFdedicated' option in the config file under the 'TIMERS' section, the value is in miliseconds and its default value is 23.5 seconds (23500 MS).
