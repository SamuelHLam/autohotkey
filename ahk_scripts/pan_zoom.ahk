#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Drag left
!+1::
MouseClickDrag, L, 150, 150, 155, 150
Sleep, 500
return

; Drag right
!+2::
MouseClickDrag, L, 150, 150, 145, 150
Sleep, 500
return

; Drag up
!+3::
MouseClickDrag, L, 150, 150, 150, 145
Sleep, 500
return

; Drag down
!+4::
MouseClickDrag, L, % 150, 150, 150, 155
Sleep, 500
return

; Wheel up
!+5::
MouseMove, 150, 150
Send, {WheelUp}
Sleep, 500
return

; Wheel down
!+6::
MouseMove, 150, 150
Send, {WheelDown}
Sleep, 500
return

Esc::ExitApp