; Assignment #1, by WCC, 7/8/2019
; Goal: enter and exit QuPath automatically
; Condition: QuPath is already installed and can be invoked from Windows 
; Requirements: 100% clear comments
; 7/9/2019 code added by Samuel
; 7/10/2019 comments added by WCC

;
; Default parameters
;
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

;
; Machine-dependent parameters -- need to change when running on a different computer
;
SetWorkingDir C:\Program Files\QuPath                 ; The directory is set based on where the QuPath executable is located.


;
; Main -- how to start the script; change the key assignment here 
;
^k::                                                  ; Can be mapped to any hotkey.
Run, QuPath.exe                                       ; The Run command will run the executable specified.
Sleep, 10000                                          ; Sleep for 10 seconds, enough for the application to fully launch.
CloseAllInstances("QuPath.exe")                       ; The CloseAllInstances function (lines 30-51) is called.
ExitApp                                               ; Exit script

CloseAllInstances(exename)
{
  WinGet WindowsList, List, % "ahk_exe" exename           ; Puts all window names belonging to the parameter process into a list "WindowsList".
  Loop, %WindowsList%                                     ; Loops through all window names.
  {
    ;
    ; usage of PostMessage: 
    ; PostMessage, Msg , wParam, lParam, Control, WinTitle, WinText, ExcludeTitle, ExcludeText
    ;   see https://www.autohotkey.com/docs/commands/PostMessage.htm
    ;
    ; Msg = 0x112 (WM_SYSCOMMAND)   Message is sent as a system command.
    ; wParam = 0xF060 (SC_CLOSE)    The message comprises SC_CLOSE, sent as a parameter of WM_SYSCOMMAND.
    ; lParam = 0                    Default value of 0 is sent.
    ; Control = ""                  Message directly sent to target window.
    ; WinTitle = % "ahk_id" WindowsList%A_Index%
    ;
    PostMessage, 0x112, 0xF060,,, % "ahk_id" WindowsList%A_Index%               ; Mimics a user closing each window.
    
    ; WinClose, % "ahk_id" Windows%A_Index%         ; Optionally, a more "forceful" way of closing windows by sending WM_CLOSE instead of SC_CLOSE
    ; The difference between WM_CLOSE and SC_CLOSE is explained here: https://stackoverflow.com/q/10101742
  }
}
