;
; Based on a reference image example.png, this script locates a match of the reference image on the screen
; and takes and saves an identical screenshot.
;
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#SingleInstance, Force		; Forces single instance of script
CoordMode, Pixel, Screen	; Absolute coordinates when using ImageSearch
CoordMode, Mouse, Screen	; Absolute coordinates when using MouseClickDrag

^k:: ; can be mapped to any hotkey
ImageSearch, Loc_X, Loc_Y, 0, 0, A_ScreenWidth, A_ScreenHeight, example.png ; Obtains starting coordinates of the match as x and y.
if (ErrorLevel = 2) {
	MsgBox, Script Error
}
else if (ErrorLevel = 1) {
	MsgBox, Image Not Found
}
else if (ErrorLevel = 0) {
	MsgBox, Image Found!
	
	Run, "%a_windir%\System32\SnippingTool.exe"   ; Runs Snipping Tool
	Gui, Add, picture, vex, example.png           ; The next three lines are a workaround to get the dimensions of an image.
	GuiControlGet, ex, Pos
	Gui, Destroy
  WinWaitActive, Snipping Tool                  ; Waits for the Snipping Tool to start before running further commands.
	x2 := x + exW, y2 := y + exH                  ; Specifies the end coordinates of the snip.
	MouseClickDrag, Left, x, y, x2, y2		        ; Executes a snip.
  Send, ^s                                      ; Opens save window.
  ; Random, name                                ; Generates a random name for the screenshot.
  WinWaitActive, Save As                        ; Waits for the save window to appear.
  ; Send, %name%                                ; Assigns name to file.
  Send, {Enter}                                 ; Saves file.
  WinWaitActive, Snipping Tool                  ; Waits for save window to close.
  CloseAllInstances("SnippingTool.exe")         ; Closes Snipping Tool window.
}

Esc::ExitApp ; Exit script

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
