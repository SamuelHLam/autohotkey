; Assignment #3 assigned by WCC, 7/24/2019
; Goal: enter QuPath, take a screenshot with Snipping Tool, and then exit QuPath; repeat the same process for NDP.view 
;   now you have two images to compare using the Matlab code; report the registration result and dE with Matlab
; Condition: QuPath and NDP.view are already installed and can be invoked from Windows 
; Requirements: 100% clear comments

;
; Default parameters
;
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

;
; Machine-dependent parameters -- need to change when running on a different computer
;
SetWorkingDir C:\Program Files\QuPath                 ; The directory is set based on where the QuPath executable is on my machine.


;
; Main -- how to start the script; change the key assignment here 
;
^k::                                                  ; Can be mapped to any hotkey.
 Run, QuPath.exe                                       ; The Run command will run the executable specified.


;
; Screenshot -- take a screenshot of the whole screen and save it as a PNG file
;


return


;
; Samuel: the goal says "enter and exit QuPath automatically" without pressing the 2nd key; please modify to combine ^k and ESC
;
Esc::
CloseAllInstances("QuPath.exe")                       ; The CloseAllInstances function (lines 25-33) is called.
ExitApp                                               ; Exit script

;
; Repeat the same process for NDP.view
;


CloseAllInstances(exename)
{
  WinGet WindowsList, List, % "ahk_exe" exename           ; Puts all window names belonging to the parameter process into a list "WindowsList".
  Loop, %WindowsList%                                     ; Loops through all window names.
  {
    ;
    ; Samuel: please elaborate this line
    ;
    ; usage of PostMessage: 
    ; PostMessage, Msg , wParam, lParam, Control, WinTitle, WinText, ExcludeTitle, ExcludeText
    ;   see https://www.autohotkey.com/docs/commands/PostMessage.htm
    ;
    ; Msg = 0x112 (WM_SYSCOMMAND), see https://www.autohotkey.com/docs/commands/PostMessage.htm
    ; wParam = 0xF060 (what is this?)
    ; lParam = ""
    ; Control = ""
    ; WinTitle = % "ahk_id" WindowsList%A_Index%
    ;
    PostMessage, 0x112, 0xF060,,, % "ahk_id" WindowsList%A_Index%               ; Mimics a user closing each window.
    ; WinClose, % "ahk_id" Windows%A_Index%         ; Optionally, a more "forceful" way of closing windows.
  }
}
