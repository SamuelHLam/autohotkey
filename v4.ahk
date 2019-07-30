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
waitTime      := 2000                           ; In milliseconds. Used to wait for images to fully load.
magnification := 20                             ; Desired magnification.
imgwidth      := 51200, imgheight     := 38144  ; Dimensions of slide image.
imgx          := 39250, imgy          := 6000   ; Area of interest on slide.
qpmapwidth    := 150,   qpmapheight   := 111    ; Dimensions of QuPath slide map.
qpmapx        := 1759,  qpmapy        := 92     ; Position of QuPath slide map (top left corner).
ndpmapwidth   := 481,   ndpmapheight  := 358    ; Dimensions of NDP.view 2 slide map.
ndpmapx       := 1422,  ndpmapy       := 705    ; Position of NDP.view 2 slide map (top left corner).
sdnmapwidth   := 315,   sdnmapheight  := 236    ; Dimensions of Sedeen slide map.
sdnmapx       := 1604,  sdnmapy       := 74     ; Position of Sedeen slide map.

;
; Main -- how to start the script; change the key assignment here 
;
^k::  ; Can be mapped to any hotkey.

Run, %ProgramFiles%\QuPath\QuPath.exe "%A_ScriptDir%\CMU-1.ndpi",, Max ; Opens CMU-1.ndpi with QuPath.
WinWaitActive, ahk_exe QuPath.exe   ; The script will wait for a window belonging to the QuPath.exe process to appear.
Sleep, %waitTime%                   ; Waits for the progam to load fully.
QPSnip()                            ; Moves FOV to location of interest and snips.
CloseAllInstances("QuPath.exe")     ; Exits QuPath.

Run, %ProgramFiles%\Sedeen Viewer\sedeen.exe "%A_ScriptDir%\CMU-1.ndpi",, Max ; Opens CMU-1.ndpi with Sedeen.
WinWaitActive, ahk_exe sedeen.exe
Sleep, %waitTime%
SedeenSnip()
CloseAllInstances("sedeen.exe")

;Run, %ProgramFiles%\Hamamatsu\NDP.view 2\NDPView2.exe "%A_ScriptDir%\CMU-1.ndpi",, Max ; Opens CMU-1.ndpi with NDPView2.
;WinWaitActive, NDP.view 2            ; Waits for NDPView2 to load.
;Sleep, %waitTime%
;NDPSnip()                            ; Moves FOV to location of interest and snips.
;CloseAllInstances("NDPView2.exe")    ; Exits NDP.view 2.

CloseAllInstances("SnippingTool.exe") ; I was having some problems with Snipping Tool not closing, so this is just to make sure.
Esc::ExitApp                          ; Executes normally, but can be used as an emergency escape.

;
; Functions
;
QPSnip()
{
  global                              ; Makes sure this function has access to global variables
  
  Send, +a                            ; Removes side bar.
  MouseMove, 430, 60                  ; Adjusts magnification.
  Click, 2
  WinWaitActive, Set magnification
  Send, +{Tab}
  Send, %magnification%
  Send, {Enter}
  MoveFOV(qpmapwidth, qpmapheight, qpmapx, qpmapy)  ; Moves field of view.
  Send, +{Tab 4}                                    ; Removes unnecessary menu items (slide map, etc.).
  Send, {Space}
  Send, +{Tab}
  Send, {Space}
  Send, +{Tab}
  Send, {Space}
  
  Snip(4, 85, A_ScreenWidth-4, A_ScreenHeight-46, "QuPath")
}

SedeenSnip()
{
  global

  Send, {Alt}vl{Down}{Enter}  ; Removes tabs taking up space.
  Send, {Alt}vt{Down}{Enter}  ; Opens zoom bar.
  Sleep, 100
  Click, 30, 280              ; Zooms to 20x.
  Sleep, 100
  Send, {Alt}vt{Down}{Enter}  ; Closes zoom bar.
  Send, {Alt}vt{Enter}        ; Opens slide map.
  MoveFOV(sdnmapwidth, sdnmapheight, sdnmapx, sdnmapy)  ; Moves field of view.
  Send, {Alt}vt{Enter}                                  ; Closes slide map.

  Snip(0, 73, A_ScreenWidth, A_ScreenHeight-61, "Sedeen")
}

NDPSnip()
{
  global
  
  Click       ; Selects image.
  Send, 5     ; Selects zoom of 20x.
  Sleep, 800  ; Waits for image to stop zooming in.
  Send, m     ; Opens slide map.
  Sleep, 500
  MoveFOV(ndpmapwidth, ndpmapheight, ndpmapx, ndpmapy)  ; Moves field of view.
  Send, m                                               ; Closes slide map.
  Sleep, 500
  
  Snip(0, 0, A_ScreenWidth, A_ScreenHeight, "NDPView2")
}

MoveFOV(mapwidth, mapheight, mapx, mapy)
{
  global 

  xcf := mapwidth/imgwidth, ycf := mapheight/imgheight  ; Conversion factors.
  smallx := Round(imgx*xcf), smally := Round(imgy*ycf)  ; Coordinates to click, relative to the slide map.
  ;MsgBox, Clicking on %smallx% %smally%
  Sleep, 100
  MouseClick, left, mapx+smallx, mapy+smally            ; Clicks absolute coordinates to move FOV.
}

Snip(x1, y1, x2, y2, name)
{
  Run, "%a_windir%\System32\SnippingTool.exe"     ; Runs Snipping Tool
  WinWaitActive, Snipping Tool                    ; Waits for the Snipping Tool to start before running further commands.
  MouseClickDrag, left, %x1%, %y1%, %x2%, %y2%    ; Executes a snip.
  Send, ^s                                        ; Opens save window.
  WinWaitActive, Save As                          ; Waits for the save window to appear.
  Send, %name%                                    ; Assigns name to file.
  Send, {Enter}                                   ; Saves file.
  WinWaitActive, Snipping Tool                    ; Waits for save window to close.
  Sleep, 500
  CloseAllInstances("SnippingTool.exe")           ; Closes Snipping Tool window.
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
