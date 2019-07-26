;
; Known Bugs:
;   - NDP.view 2 will somtimes display black artifacts over the image when loaded.
;     These artifacts seem to be random and may appear or disappear when reloaded.
;

;
; Default parameters
;
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

CoordMode, Pixel, Screen	; Absolute coordinates when using pixel search functions
CoordMode, Mouse, Screen	; Absolute coordinates when using mouse functions

; Global variables
waitTime := 2000                  ; In milliseconds. Used to wait for images to fully load.
magnification := 20
xcoord := 30000, ycoord := 10000  ; Area of interest on slide.

;
; Main -- how to start the script; change the key assignment here 
;
^k::                                                                  ; Can be mapped to any hotkey.


Run, %ProgramFiles%\QuPath\QuPath.exe "%A_ScriptDir%\CMU-1.ndpi",, Max ; Opens CMU-1.ndpi with QuPath.
WinWaitActive, ahk_exe QuPath.exe                                     ; The script will wait for a window belonging to the QuPath.exe process to appear.
Sleep, %waitTime%                                                     ; Waits for the progam to load fully.
QPSnip()                                                              ; Moves FOV to location of interest and snips.
CloseAllInstances("QuPath.exe")                                       ; Exits QuPath.

Run, %ProgramFiles%\Hamamatsu\NDP.view 2\NDPView2.exe "%A_ScriptDir%\CMU-1.ndpi",, Max ; Opens CMU-1.ndpi with NDPView2.
WinWaitActive, NDP.view 2                                             ; Waits for NDPView2 to load.
Sleep, %waitTime%
NDPSnip()                                                             ; Moves FOV to location of interest and snips.
CloseAllInstances("NDPView2.exe")                                     ; Exits NDP.view 2.

CloseAllInstances("SnippingTool.exe")      ; I was having some problems with Snipping Tool not closing, so this is just to make sure.
Esc::ExitApp                               ; Executes normally, but can be used as an emergency escape.

;
; Functions
;
QPSnip()
{
  ; Makes sure this function has access to global variables
  global
  
  Send, +a                                ; Removes side bar.
  MouseMove, 430, 60                      ; Adjusts magnification.
  Click, 2
  WinWaitActive, Set magnification
  Send, +{Tab}
  Send, %magnification%
  Send, {Enter}
  QPMoveFOV(xcoord, ycoord)               ; Moves field of view.
  Send, +{Tab 4}                          ; Removes unnecessary menu items (slide map, etc.).
  Send, {Space}
  Send, +{Tab}
  Send, {Space}
  Send, +{Tab}
  Send, {Space}

  Run, "%a_windir%\System32\SnippingTool.exe"     ; Runs Snipping Tool
  WinWaitActive, Snipping Tool                    ; Waits for the Snipping Tool to start before running further commands.
  upper := 85, lower := 1034, left := 4, right := A_ScreenWidth-4 ; Present window boundaries in QuPath.
  MouseClickDrag, Left, left, upper, right, lower ; Executes a snip.
  Send, ^s                                        ; Opens save window.
  WinWaitActive, Save As                          ; Waits for the save window to appear.
  Send, QuPath                                    ; Assigns name to file.
  Send, {Enter}                                   ; Saves file.
  WinWaitActive, Snipping Tool                    ; Waits for save window to close.
  Sleep, 500
  CloseAllInstances("SnippingTool.exe")           ; Closes Snipping Tool window.
}

NDPSnip()
{
  Click                       ; Selects image.
  Send, 5                     ; Selects zoom of 20x.
  Sleep, 800                  ; Waits for image to stop zooming in.
  Send, m                     ; Opens slide map.
  NDPMoveFOV(xcoord,ycoord)   ; Moves field of view.
  Send, m                     ; Closes slide map.
  Sleep, 500
  Run, "%a_windir%\System32\SnippingTool.exe"   ; Runs Snipping Tool.
  WinWaitActive, Snipping Tool                  ; Waits for the Snipping Tool to start before running further commands.
  Send, !n                                      ; Opens snipping tool menu.
  Send, {Up}                                    ; Selects full screen shot.
  Send, {Enter}                                 ; Takes screen shot.
  Send, ^s                                      ; Opens save window.
  WinWaitActive, Save As                        ; Waits for the save window to appear.
  Send, NDPView2                                ; Assigns name to file.
  Send, {Enter}                                 ; Saves file.
  WinWaitActive, Snipping Tool                  ; Waits for save window to close.
  CloseAllInstances("SnippingTool.exe")         ; Closes Snipping Tool window.
}

QPMoveFOV(x,y)
{
  xcf := 150/51200, ycf := 111/38144
  smallx := Round(x*xcf), smally := Round(y*ycf)
  MouseClick, left, 1760+smallx, 92+smally
}

NDPMoveFOV(x,y)
{
  xcf := 480/51200, ycf := 357/38144
  smallx := Round(x*xcf), smally := Round(y*ycf)
  MouseMove, 1422+smallx, 705+smally
  Sleep, 500
  Click
}

CloseAllInstances(exename)
{
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
