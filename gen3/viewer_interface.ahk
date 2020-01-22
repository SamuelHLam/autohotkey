; Assignment #2 assigned by WCC, 7/23/2019
; Goal: enter QuPath, take a screenshot with Snipping Tool, and then exit QuPath
; Condition: QuPath is already installed and can be invoked from Windows 
; Requirements: 100% clear comments
; 7/9/2019 code added by Samuel
; 7/10/2019 comments added by WCC
; 9/10/2019

;
; Default parameters
;
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

CoordMode, Pixel, Screen    ; Absolute coordinates when using pixel search functions
CoordMode, Mouse, Screen    ; Absolute coordinates when using mouse functions


;
; Main -- how to start the script; change the key assignment here 
;
; https://www.autohotkey.com/docs/commands/MouseClickDrag.htm
;

;
; ! = alt
; + = shift
;

; Drag left
^a::
MouseClickDrag, L, 150, 150, 200, 150
return

; Drag right
^s::
MouseClickDrag, L, 150, 150, 100, 150
return

; Drag up
^d::
MouseClickDrag, L, 150, 150, 150, 100
return

; Drag down
^f::
MouseClickDrag, L, 150, 150, 150, 200
return

; Wheel up
^g::
MouseMove, 150, 150
Send, {WheelUp}
return

; Wheel down
^h::
MouseMove, 150, 150
Send, {WheelDown}
return

Esc::
ExitApp
