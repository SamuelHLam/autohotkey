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
; https://www.autohotkey.com/docs/commands/MouseClickDrag.htm
;

; pan left
!+1::                                                  
MouseClickDrag, Left, 1, 1, -50, 0, 100, Relative
return

; pan right
!+2::                                                  
MouseClickDrag, Left, 1, 1, +50, 0, 100, Relative
return

; pan up
!+3::                                                  
MouseClickDrag, Left, 1, 1, 0, -50, 100, Relative
return

; pan down
!+4::                                                  
MouseClickDrag, Left, 1, 1, 0, +50, 100, Relative
return

; zoom in
!+5::
Send, {WheelUp}
return

; zoom out
!+6::
Send, {WheelDown}
return
