; Assignment #1, by WCC, 7/8/2019
; Goal: enter and exit QuPath automatically
; Condition: QuPath is already installed and can be invoked from Windows 
; Requirements: 100% clear comments



; please add your code here:

; Lines 11-13 are default parameters.
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

SetWorkingDir C:\Program Files\QuPath ; The directory is set based on where the QuPath executable is on my machine.

^k:: ; Can be mapped to any hotkey.
Run, QuPath.exe ; The Run command will run the executable specified.
return

Esc::
CloseAllInstances("QuPath.exe") ; The CloseAllInstances function (lines 25-33) is called.
ExitApp ; Exit script

CloseAllInstances(exename)
{
  WinGet Windows, List, % "ahk_exe" exename ; Puts all window names belonging to the parameter process into a list "Windows".
  Loop, %Windows% ; Loops through all window names.
  {
    PostMessage, 0x112, 0xF060,,, % "ahk_id" Windows%A_Index% ; Mimics a user closing each window.
	  ; WinClose, % "ahk_id" Windows%A_Index% ; Optionally, a more "forceful" way of closing windows.
	}
}
