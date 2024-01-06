;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; TABLE OF CONTENTS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;  A.) AUTOEXEC SECTION
;
;  B.) LABELS SECTION
;
;  C.) FUNCTIONS SECTION
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; A.) THIS IS THE 'AUTOEXEC' SECTION OF THE SCRIPT. WHEN THE SCRIPT LAUNCHES THIS SEGMENT OF THE CODE IS EXECUTED FROM TOP TO BOTTOM ORDER. ;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; 1.) LAUNCH OPTIONS SECTION ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance, Force ; Do not allow the script to open multiple instances, exit current instance (if it exists) and start a new instance when an attempt is made
#Persistent ; Stop the script from exiting itself if it has no hotkeys defined.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; 2.) VARIABLES / STRINGS SECTION ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GLOBAL AppTitleRoot := "SOTF Dedicated Overseer" ; This is the name of our script, stored in a string so it can be displayed easily or
; changed on the fly without editing multiple lines of code. We define it as a 'GLOBAL' string so that way it can be used anywhere in the script,
; even inside functions or labels without having to redefine it again elsewhere. I named it 'AppTitleRoot' just to be descriptive. 
; It could be named anything though, I could've named it 'BitchinJuice' if I felt so arsed to do so.
GLOBAL RootConfigTitle := "settings.cfg" ; This is the name of the config file we will create in section 4 below. 
; We can also use this to point to the config file whenever we need to elsewhere, such as when checking settings.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; 3.) TRAY MENU SECTION ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; The following code block creates a custom tray menu for the script
;;;; by tray menu, I mean the menu you see when you right click the running script
;;;; in the bottom right windows system tray.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Menu, Tray, NoStandard ; Tells the Autohotkey compiler to not use the default tray menu settings that it normally would for all other AHK scripts
Menu, Tray, Add, START WATCHER, StartWatcher  ;  Creates a new tray menu control named 'START WATCHER', which calls the 'StartWatcher' label below when clicked in the tray menu.
Menu, Tray, Add, STOP WATCHER, StopWatcher  ;  Creates a new tray menu control named 'STOP WATCHER', which calls the 'StopWatcher' label below when clicked in the tray menu.
Menu, Tray, Add  ; Creates a separator line.
Menu, Tray, Add, Settings, OpenSettingsFile  ; Creates a new tray menu control named 'Settings', which calls the 'OpenSettingsFile' label below when clicked in the tray menu.
Menu, Tray, Add  ; Creates a separator line.
Menu, Tray, Add, Exit, TrayExitButton   ; Creates a new tray menu control named 'Exit', which calls the 'TrayExitButton' label below when clicked in the tray menu.
Menu, Tray, Tip, %AppTitleRoot%
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; 4.) CONFIG FILE BUILDER SECTION ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Below checks if the config file exists, if it does then it reads each setting's current value and proceeds. If it doesn't, then its created with keys using script defaults.
If FileExist(RootConfigTitle)
{
    ; Yaaay if it reached this part, the config file already exists, we'll now read all of the keys inside of it and pass their values into GLOBAL strings for use on demand.
    ;
    IniRead, OverseerVelocity, %RootConfigTitle%, TIMERS, WatchSOTFdedicated, 23500 ; Reads the value of the 'WatchSOTFdedicated' key under the 'TIMERS' section inside the 'RootConfigTitle'
    ; then pipes that value into a new string named 'OverseerVelocity', if for some reason the script is unable to read the value, it will default to the '23500' given at the very end of this read.
    ; The value of this new string 'OverseerVelocity' will be the speed (in miliseconds) that we execute the Dedicated Server Watcher/Oversee timer at. Now, let's make these results GLOBAL:
    GLOBAL ServerWatcherSpeed := OverseerVelocity ; Now we created a new GLOBAL string named 'ServerWatcherSpeed' and made it point to the 'OverseerVelocity' string's current value as its contents.

    IniRead, AutoSettingsUpdateVelocity, %RootConfigTitle%, TIMER, AutoUpdateSettingsSpeed, 25000 ; Same formatting as above.
    ; The value of this new string 'AutoSettingsUpdateVelocity' controls the speed that the AutoSettingsUpdater ticks at.
    GLOBAL AutoUpdaterSpeed := AutoSettingsUpdateVelocity ; Make the results of the read GLOBAL.

    IniRead, ForceAdmin, %RootConfigTitle%, ENGINE, RunWithAdmin, 0 ; Does the same thing as above
    ; The value of this new string 'ForceAdmin' determines if the script will require admin rights by default on startup.
    GLOBAL RunAsAdmin := ForceAdmin ; Make the results of the read GLOBAL.

    IniRead, DoAutoUpdaterDoAutoUpdateSettings, %RootConfigTitle%, ENGINE, AutoUpdateSettings, 1 ; Same formatting as above.
    ; The value of this new string 'ForceAdmin' determines if the script will require admin rights by default on startup.
    GLOBAL  DoAutoUpdater := DoAutoUpdateSettings ; Make the results of the read GLOBAL.

    IniRead, DedicatedServerPath, %RootConfigTitle%, ENGINE, DedicatedServerDirectory, C:\sons-of-the-forest-server ; Same formatting as above, this defaults to 'C:\sons-of-the-forest-server' just for you Dylan :D
    ; The value of this new string 'DedicatedServerPath' determines if the script will require admin rights by default on startup. This is so you can customize this for things other than a SOTF servers.
    GLOBAL  DediServerPath := DedicatedServerPath ; Make server files' directory string GLOBAL

    IniRead, DedicatedServerEXE, %RootConfigTitle%, ENGINE, DedicatedServerEXE, SonsOfTheForestDS.exe ; Same formatting as above.
    ; The value of the new key 'DedicatedServerEXE' is where the name of your server executable goes. Default is 'SonsOfTheForestDS.exe'. This is so you can customize this for things other than a SOTF servers.
    GLOBAL  DediServerEXE := DedicatedServerEXE ; Make server .exe's name string GLOBAL

    GLOBAL ServerPath := DediServerPath . "\" . DediServerEXE  ; Combine both the 'DediServerPath' and the 'DediServerEXE' GLOBAL strings together into a new GLOBAL string, denoting a '\' inbetween the two of them.
    ; Now if anything refrences, calls, or runs the GLOBAL string 'ServerPath', it will be pointing at the following by default: 
}
Else
{
    ; NOOOO we reached this part instead of the stuff in the first half of the if statement, config file does not exist!
    ;  We'll now create the file, and then define all ini keys using hardcoded defaults here:
    ;
    FileAppend, , %RootConfigTitle% ; Create a file using the 'RootConfigTitle' string from section 2 as the new file's name.
    Sleep, 500 ; Waits 500 miliseconds just to be safe that the config file was created before trying to write to it.
    IniWrite, 23500, %RootConfigTitle%, TIMERS, WatchSOTFdedicated ; Writes the value '23500' to the 'WatchSOTFdedicated' key under the 'TIMERS' section of the new file.
    IniWrite, 25000, %RootConfigTitle%, TIMERS, AutoUpdateSettingsSpeed ; Writes the value '25000' to the 'AutoUpdateSettingsSpeed' key under the 'TIMERS' section of the new file.
    IniWrite, 1, %RootConfigTitle%, ENGINE, AutoUpdateSettings ; Writes the value "1" to the 'AutoUpdateSettings' key under the 'ENGINE' section.
    IniWrite, 0, %RootConfigTitle%, ENGINE, RunWithAdmin ; Writes the value '0' to the 'RunWithAdmin' key under the 'ENGINE' section of the new file.
    IniWrite, C:\sons-of-the-forest-server, %RootConfigTitle%, ENGINE, DedicatedServerDirectory ; Writes "C:\sons-of-the-forest-server" as the default to the 'DedicatedServerDirectory' key under 'ENGINE' section.
    IniWrite, SonsOfTheForestDS.exe, %RootConfigTitle%, ENGINE, DedicatedServerEXE ; Writes "SonsOfTheForestDS.exe" as the default to the 'DedicatedServerEXE' key under 'ENGINE' section.
    ;
    ;
    ; Now that the new file has been created and its keys have been made and their values set to script defaults. 
    ; Now, we'll pipe those values into strings for use on demand, doing the same thing that would've been done above, if the config file had already existed:
    ;
    IniRead, OverseerVelocity, %RootConfigTitle%, TIMERS, WatchSOTFdedicated, 23500  ; Time in miliseconds that the server Overseer ticks at.
    GLOBAL ServerWatcherSpeed := OverseerVelocity

    IniRead, AutoSettingsUpdateVelocity, %RootConfigTitle%, TIMER, AutoUpdateSettingsSpeed, 25000  ; Time in miliseconds that the script Auto Settings Updater/Refresher timer ticks at.
    GLOBAL AutoUpdaterSpeed := AutoSettingsUpdateVelocity

    IniRead, ForceAdmin, %RootConfigTitle%, ENGINE, RunWithAdmin, 0  ; If set to 1 in the config file, the script will automatically request admin on launching up. If 0, disabled.
    GLOBAL RunAsAdmin := ForceAdmin

    IniRead, DoAutoUpdaterDoAutoUpdateSettings, %RootConfigTitle%, ENGINE, AutoUpdateSettings, 1
    GLOBAL  DoAutoUpdater := DoAutoUpdateSettings

    IniRead, DedicatedServerPath, %RootConfigTitle%, ENGINE, DedicatedServerDirectory, C:\sons-of-the-forest-server
    GLOBAL  DediServerPath := DedicatedServerPath

    IniRead, DedicatedServerEXE, %RootConfigTitle%, ENGINE, DedicatedServerEXE, SonsOfTheForestDS.exe
    GLOBAL  DediServerEXE := DedicatedServerEXE

    GLOBAL ServerPath := DediServerPath . "\" . DediServerEXE  ; Combine both the 'DediServerPath' and the 'DediServerEXE' GLOBAL strings together into a new GLOBAL string (same as the above example).
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; 5.) EXTRA LOGIC & SETTINGS IF/THEN STATEMENTS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;
;;
;;             CHECK 'RunWithAdmin' CONFIG FILE SETTING
;;
                        If(RunAsAdmin="1")
                        {
                        ; THE 'RunAsAdmin' GLOBAL STRING FROM ABOVE WAS INDEED SET TO 1 (ENABLED)! 
                        ;  Now we'll do a few things:
                        ;  If the script is not already elevated, it will relaunch as administrator and kill the current instance
            full_command_line := DllCall("GetCommandLine", "str")
 
            if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)"))
            {
                try ; leads to having the script re-launching itself as administrator
                {
                if A_IsCompiled
                    Run *RunAs "%A_ScriptFullPath%" /restart
                else
                    Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%"
                }
            ExitApp
            }
                         }
                         Else
                         {
                         ; THE 'RunAsAdmin' GLOBAL STRING FROM ABOVE WAS NOT SET TO 1 (DISABLED). PROCEEDING WITHOUT ATTEMPTING TO ELEVATE TO ADMIN. 
                         }
;;
;;
;;
;;             CHECK 'AutoUpdateSettings' CONFIG FILE SETTING
;;
                        If(DoAutoUpdater="1")
                        {
                        ; AUTOMATIC CONFIG FILE SETTINGS UPDATER IS ENABLED, WE WILL NOW TURN ON ITS TIMER:
                        SetTimer, AutoUpdateSettings, %AutoUpdaterSpeed% ; Set 'AutoUpdateSettings' label below to run by the time value stored under 'AutoUpdaterSpeed' string. If unchanged its 23500 miliseconds.
                        }
                        Else
                        {
                        ; AUTOMATIC CONFIG FILE SETTINGS UPDATER IS DISABLED. PROCEEDING WITHOUT AUTO SETTINGS UPDATER TIMER.
                        }
    ;;;
    ;;;
    ;;;
    ;;; NOW LASTLY WE'LL SET THE MAIN SOTF DEDICATED SERVER TIMER ROUTINE TO EXECUTE BY THE GIVEN NUMBER OF MILISECOND INSIDE OF THE CONFIG FILE:
    SetTimer, SOTFDedicatedServerWatcher, %ServerWatcherSpeed% ; Set 'SOTFDedicatedServerWatcher' label to run by the time value stored under 'ServerWatcherSpeed' 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Return ;;; Call Return, this denotes the end of the 'AUTOEXEC' section of the script.
; Normally, if there was no hotkeys defined, the script would treat this "return" as an "ExitApp" and close the script entirely, but because we 
; defined #Persistent at the launch options section at the very top, now it will simply stay open and the Set Timer(s) we defined will loop by given times.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;; END OF 'AUTOEXEC' SECTION REACHED. SCRIPT WOULD NORMALLY NOW BE SITTING IDLE BUT SINCE WE DEFINED TIMERS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;; B.) LABELS SECTION ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; The following code block contains Labels, which are segments of code that can be set to execute on a timer, or be called by GUI or tray menu controls.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 1.) TIMER LABELS
; These lables can (if turned on during autoexec) execute on a given scheduled timer value, defined above at the end of the 'AUTOEXEC' section.
;
;
SOTFDedicatedServerWatcher: ; The MAIN label of this entire script, this is the logic that loops every given interval to ensure the SOTF Server is running.
If(ProcessExist(DediServerEXE)) ; IF 'DediServerEXE' (which is the GLOBAL string whose value is equal to the 'DedicatedServerEXE' key under the 'ENGINE' section in the config file) exists:
{
    ; DEDICATED SERVER IS CURRENTLY RUNNING! NOW THIS LABEL WILL SIMPLY SLEEP UNTIL THE TIMER EXECUTES AGAIN!
}
    Else
    {
        ; NOPE, DEDICATED SERVER IS NOT RUNNING SO LET'S RUN IT!
        ;
        ;   Ordinarily, we would do something like this, with a hardcoded path:
        ; Run, C:\sons-of-the-forest-server\SonsOfTheForestDS.exe
        ;
        ;   But because we have two keys in the config file to set our set up custom launch directory and executable, we don't have to hardcore anything,
        ;      and defaults will only be used when the script has no other choice.
        ;   So, now we just call the GLOBAL string we made above that combines the 'DediServerPath' and 'DediServerEXE' strings whose values were already read from the config file:
        Run, %ServerPath% ; Because the directory and the executable targets are customizable, this script can be used for ANY PROCESS, it doesn't have to be SOTF, doesn't even have to be a server.
    }
Return
;;;
;;;
;;;
AutoUpdateSettings: ; The label containing the logic for the automatic settings updater, which keeps any config file changes up to date without needing to restart the app for them to reflect
AutoUpdateSettingsFunction() ; this points to a FUNCTION at the very bottom of the entire script, it is explained there.
Return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 2.) TRAY MENU BUTTON LABELS
; These labels will ONLY execute when their respective tray menu buttons are clicked.
;
;
OpenSettingsFile:  ; The label with the actual code to be executed when the 'Settings' button in the tray menu is clicked.
Run, %A_ScriptDir%\%RootConfigTitle% ; Runs the config file name whose value is stored in the 'RootConfigTitle' string, inside of whichever folder the script is inside of at the moment
Return
;;;
;;;
;;;
StartWatcher:   ; The label with the actual code to be executed when the 'START WATCHER' button in the tray menu is clicked.
AutoUpdateSettingsFunction() ; Double-check for any settings changes in case its inbetween ticks of the auto-updater (if you even have that enabled in the settings at all)
SetTimer, SOTFDedicatedServerWatcher, %ServerWatcherSpeed% ; Turns the watcher back ON.
Return
;;;
;;;
;;;
StopWatcher:   ; The label with the actual code to be executed when the 'STOP WATCHER' button in the tray menu is clicked.
SetTimer, SOTFDedicatedServerWatcher, Off ; Turns the watcher OFF until turned back ON.
Return
;;;
;;;
;;;
TrayExitButton:   ; The label with the actual code to be executed when the 'Exit' button in the tray menu is clicked.
ExitApp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Return ; ENSURES that this section can absolutely never be executed accidentally.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;; C.) FUNCTIONS SECTION. ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; THIS SECTION IS NEVER EXECUTED AS A WHOLE, INSTEAD IF A SPECIFIC FUNCTION HERE IS CALLED, THE SCRIPT SKIPS DOWN HERE TO EXECUTE IT AND THEN PROCEEDS WHEREVER IT WAS BEFOREHAND.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
;  Below is just a simple and easy function that does the exact same thing as what we did in section 4 'CONFIG FILE BUILDER SECTION' when we checked if the config file existed and it did so,
;  we read values into strings. It just does the reading part only This function can be called anywhere in the script and the script will execute this function to update the strings and 
;  GLOBAL strings that point to the value of each key in the config file.
;  This function is called by the TIMER label 'AutoUpdateSettings' every given interval, if it passed the check in section 5 the 'EXTRA LOGIC & SETTINGS IF/THEN STATEMENTS' section. If not, this logic does not run.
AutoUpdateSettingsFunction()
{
    IniRead, OverseerVelocity, %RootConfigTitle%, TIMERS, WatchSOTFdedicated, 23500
    GLOBAL ServerWatcherSpeed := OverseerVelocity

    IniRead, AutoSettingsUpdateVelocity, %RootConfigTitle%, TIMER, AutoUpdateSettingsSpeed, 25000
    GLOBAL AutoUpdaterSpeed := AutoSettingsUpdateVelocity

    IniRead, ForceAdmin, %RootConfigTitle%, ENGINE, RunWithAdmin, 0
    GLOBAL RunAsAdmin := ForceAdmin

    IniRead, DoAutoUpdaterDoAutoUpdateSettings, %RootConfigTitle%, ENGINE, AutoUpdateSettings, 1
    GLOBAL  DoAutoUpdater := DoAutoUpdateSettings

    IniRead, DedicatedServerPath, %RootConfigTitle%, ENGINE, DedicatedServerDirectory, C:\sons-of-the-forest-server
    GLOBAL  DediServerPath := DedicatedServerPath

    IniRead, DedicatedServerEXE, %RootConfigTitle%, ENGINE, DedicatedServerEXE, SonsOfTheForestDS.exe
    GLOBAL  DediServerEXE := DedicatedServerEXE

    GLOBAL ServerPath := DediServerPath . "\" . DediServerEXE  ; Combine both the 'DediServerPath' and the 'DediServerEXE' GLOBAL strings together into a new GLOBAL string (same as the above example).
    Return
}
;
;
; Below is a very simple function that checks if a given process exists, and then returns the 'ErrorLevel' which if the process did not exist then an 'Error' occured so its value 
;   would be '1', meaning the process was not found. Likewise, if it did find the process, no errors occured so the value would be '0' meaning the process was indeed found.
; This function is used exclusively in the SOTF Dedicated Server Overseer/Watcher TIMER LABEL only.
ProcessExist(PIDorName:="")
{
    Process Exist, %PIDorName%
    return ErrorLevel
}