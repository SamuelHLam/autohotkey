#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#SingleInstance, Force ; Forces single instance of script

^k:: ; can be mapped to any hotkey
ImageSearch, Loc_X, Loc_Y, 0, 0, A_ScreenWidth, A_ScreenHeight, example.png
if (ErrorLevel = 2) {
	MsgBox, Script Error
}
else if (ErrorLevel = 1) {
	MsgBox, Image Not Found
}
else if (ErrorLevel = 0) {
	MsgBox, Image Found!
	MouseMove, Loc_X, Loc_Y ; just to confirm the location of the image match
}

Esc::ExitApp ; Exit script