#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

CoordMode, Pixel, Screen
CoordMode, Mouse, Screen

#SingleInstance, Force ; Forces single instance of script

^k::

MouseGetPos, x, y

MsgBox, Mouse at %x% %y%

return

Esc::ExitApp
