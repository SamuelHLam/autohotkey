; Assignment #2 assigned by WCC, 7/23/2019
; Goal: enter QuPath, take a screenshot with Snipping Tool, and then exit QuPath
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
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


;
; Main -- how to start the script; change the key assignment here 
;
^k::                                                  ; Can be mapped to any hotkey.
; waitTime := 0                                       ; In milliseconds. Currently, the application will take a screenshot immediately upon opening a window.
Run, "%ProgramFiles%\QuPath\QuPath.exe"               ; The Run command will run the executable specified.
WinWaitActive, ahk_exe QuPath.exe                     ; The script will wait for a window belonging to the QuPath.exe process to appear.
; Sleep, %waitTime%                                   ; Sleep for a predefined amount of time if desired.
Snip()                                                ; Snip function is called.
CloseAllInstances("QuPath.exe")                       ; CloseAllInstances function is called.
ExitApp                                               ; Exit script.

;
; Functions
;
Snip() {
  Run, "%a_windir%\System32\SnippingTool.exe"   ; Runs Snipping Tool
  WinWaitActive, Snipping Tool                  ; Waits for the Snipping Tool to start before running further commands.
  SendInput, !n                                 ; Opens snipping tool menu.
  SendInput, {Up}                               ; Selects full screen shot.
  SendInput, {Enter}
  SendInput, ^s
  ; Random, name                                ; Generates a random name for the screenshot.
  WinWaitActive, Save As                        ; Waits for the save window to appear.
  ; SendInput, %name%                           ; Assigns name to file.
  SendInput, {Enter}
}

CloseAllInstances(exename) {
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
    PostMessage, 0x112, 0xF060,,, % "ahk_id" WindowsList%A_Index% ; Mimics a user closing each window.
    
    ; WinClose, % "ahk_id" Windows%A_Index% ; Optionally, a more "forceful" way of closing windows by sending WM_CLOSE instead of SC_CLOSE
    ; The difference between WM_CLOSE and SC_CLOSE is explained here: https://stackoverflow.com/q/10101742
  }
}
