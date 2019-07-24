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
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;
; Main -- how to start the script; change the key assignment here 
;
^k::                                                                  ; Can be mapped to any hotkey.
waitTime := 2000                                                      ; In milliseconds. Used to wait for images to fully load.
Run, %ProgramFiles%\QuPath\QuPath.exe "%A_ScriptDir%\CMU-1.ndpi",, Max ; Opens CMU-1.svs with QuPath.
WinWaitActive, ahk_exe QuPath.exe                                     ; The script will wait for a window belonging to the QuPath.exe process to appear.
Sleep, %waitTime%                                                     ; Sleep for a predefined amount of time if desired.
Send, +a                                                              ; Closes a sidebar in QuPath to allow more space for the image.
Snip("QuPath")                                                        ; Snip function is called.
CloseAllInstances("QuPath.exe")                                       ; CloseAllInstances function is called.
Run, %ProgramFiles%\Hamamatsu\NDP.view 2\NDPView2.exe "%A_ScriptDir%\CMU-1.ndpi",, Max ; Opens CMU-1.ndpi with NDPView2.
WinWaitActive, NDP.view 2                                             ; Waits for NDPView2 to load.
Sleep, %waitTime%
Snip("NDPView2")
CloseAllInstances("NDPView2.exe")
CloseAllInstances("SnippingTool.exe")      ; I was having some problems with Snipping Tool not closing, so this is just to make sure.
Esc::ExitApp                               ; Executes normally, but can be used as an emergency escape.

;
; Functions
;
Snip(name) {
  Run, "%a_windir%\System32\SnippingTool.exe"   ; Runs Snipping Tool
  WinWaitActive, Snipping Tool                  ; Waits for the Snipping Tool to start before running further commands.
  Send, !n                                      ; Opens snipping tool menu.
  Send, {Up}                                    ; Selects full screen shot.
  Send, {Enter}                                 ; Takes screen shot.
  Send, ^s                                      ; Opens save window.
  WinWaitActive, Save As                        ; Waits for the save window to appear.
  Send, %name%                                  ; Assigns name to file.
  Send, {Enter}                                 ; Saves file.
  WinWaitActive, Snipping Tool                  ; Waits for save window to close.
  CloseAllInstances("SnippingTool.exe")         ; Closes Snipping Tool window.
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
