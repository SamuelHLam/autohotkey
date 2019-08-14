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
wait_time     := 2000                           ; In milliseconds. Used to wait for images to fully load.
magnification := 20                             ; Desired magnification.

img_width      := 51200,  img_height     := 38144   ; Dimensions of slide image.
img_x          := 4900,   img_y          := 30000   ; Region of interest on slide.

asap_map_width   := 249,              asap_map_height := 185                  ; Dimensions of ASAP slide map.
asap_map_x       := A_ScreenWidth-33, asap_map_y      := A_ScreenHeight-93    ; Position of ASAP slide map (bottom right corner).

is_map_width    := 420,               is_map_height   := 312                  ; Dimensions of ImageScope slide map.
is_map_x        := A_ScreenWidth-8,   is_map_y        := 32                   ; Position of ImageScope slide map (top right corner).

ndp_map_width   := 480,               ndp_map_height  := 357                  ; Dimensions of NDP.view 2 slide map.
ndp_map_x       := A_ScreenWidth-18,  ndp_map_y       := A_ScreenHeight-18    ; Position of NDP.view 2 slide map (bottom right corner).

qp_map_width    := 149,               qp_map_height   := 110                  ; Dimensions of QuPath slide map.
qp_map_x        := A_ScreenWidth-12,  qp_map_y        := 92                   ; Position of QuPath slide map (top right corner).

sdn_map_width   := 323,              sdn_map_height   := 242                  ; Dimensions of Sedeen slide map.
sdn_map_x       := A_ScreenWidth-2,  sdn_map_y        := 44                   ; Position of Sedeen slide map (top right corner).

;
; Main -- how to start the script; change the key assignment here 
;
^k::  ; Can be mapped to any hotkey.

FileDelete, asap.png
FileDelete, ndpview2.png
FileDelete, qupath.png
FileDelete, sedeen.png

ASAPSnip()
CloseAllInstances("SnippingTool.exe") ; I was having some problems with Snipping Tool not closing, so this is just to make sure.
;ISSnip()
NDPSnip()
CloseAllInstances("SnippingTool.exe")
QPSnip()
CloseAllInstances("SnippingTool.exe")
SedeenSnip()
CloseAllInstances("SnippingTool.exe")

Esc::ExitApp                          ; Executes normally, but can be used as an emergency escape.

;
; Functions
;
ASAPSnip()
{
  global  ; Makes sure this function has access to all global variables.
  
  Run, %ProgramFiles%\ASAP 1.9\bin\ASAP.exe "%A_ScriptDir%\CMU-1.ndpi",, Max ; Opens CMU-1.ndpi with ASAP with the window maximized.
  WinWaitActive, ahk_exe ASAP.exe                 ; The script will wait for a window belonging to the ASAP.exe process to appear.
  Sleep, %wait_time%                              ; Waits for the application to fullly load.
  Send, {Alt}{Right}{Up 2}{Right}{Enter}          ; Remove all sidebars.
  Send, {Alt}{Right}{Up 2}{Right}{Down}{Enter}
  Send, {Alt}{Right}{Up 2}{Right}{Down 2}{Enter}
  Click, right, 120, 30                           ; Remove toolbar.
  Send, {Up}{Enter}
  
  MouseMove, 3, 50
  
  Loop 72
  {
    Send, {WheelUp}
    Sleep, 500
  }
  Send, {Alt}{Right}{Up 3}{R}{Enter}  ; Opens slide map.
  Sleep, 100
  LowerMoveFOV(asap_map_width, asap_map_height, asap_map_x, asap_map_y) ; Moves field of view.
  Send, {Alt}{Right}{Up 3}{R}{Enter}  ; Closes slide map.
  
  Snip(2, 44, A_ScreenWidth-3, A_ScreenHeight-63, "asap") ; Takes screenshot of only the image in the viewer.
  CloseAllInstances("ASAP.exe")                           ; Exits ASAP.
}

ISSnip()
{
  global
  
  Run, C:\Program Files (x86)\Aperio\ImageScope\ImageScope.exe "%A_ScriptDir%\CMU-1.ndpi",, Max
  WinWaitActive, ahk_exe ImageScope.exe
  Sleep, %wait_time%
  Send, {Alt}vz     ; Opens zoom bar.
  Click, 25, 210    ; Zooms to 20x.
  Send, {Alt}vz     ; Closes zoom bar.
  Send, {F11}       ; Enters fullscreen mode.
  Send, ^t          ; Opens slide map.
  MoveFOV(is_map_width, is_map_height, is_map_x, is_map_y)
  Send, ^t          ; Closes slide map.
  
  Snip(5, 27, A_ScreenWidth-3, A_ScreenHeight-3, "imagescope")  ; Takes screenshot of only the image in the viewer.
  CloseAllInstances("ImageScope.exe")                           ; Exits ImageScope.
}

NDPSnip()
{
  global
  
  Run, %ProgramFiles%\Hamamatsu\NDP.view 2\NDPView2.exe "%A_ScriptDir%\CMU-1.ndpi",, Max
  WinWaitActive, NDP.view 2
  Sleep, %wait_time%
  Click             ; Selects image.
  Send, 5           ; Zooms to 20x.
  Sleep, 800        ; Waits for image to stop zooming in.
  Send, m           ; Opens slide map.
  Sleep, 500
  LowerMoveFOV(ndp_map_width, ndp_map_height, ndp_map_x, ndp_map_y) ; Moves field of view.
  Send, m           ; Closes slide map.
  Sleep, 500
  
  Snip(0, 0, A_ScreenWidth, A_ScreenHeight, "ndpview2")
  CloseAllInstances("NDPView2.exe")
}

QPSnip()
{
  global
  
  Run, %ProgramFiles%\QuPath\QuPath.exe "%A_ScriptDir%\CMU-1.ndpi",, Max
  WinWaitActive, ahk_exe QuPath.exe
  Sleep, %wait_time% 
  Send, +a              ; Removes side bar.
  MouseMove, 430, 60    ; Adjusts magnification.
  Click, 2
  WinWaitActive, Set magnification
  Send, +{Tab}
  Send, %magnification%
  Send, {Enter}
  MoveFOV(qp_map_width, qp_map_height, qp_map_x, qp_map_y)
  Send, +{Tab 4}{Space} ; Removes unnecessary menu items (slide map, etc.).
  Send, +{Tab}{Space}
  Send, +{Tab}{Space}
  
  Snip(4, 85, A_ScreenWidth-5, A_ScreenHeight-46, "qupath")
  CloseAllInstances("QuPath.exe")
}

SedeenSnip()
{
  global
  
  Run, %ProgramFiles%\Sedeen Viewer\sedeen.exe "%A_ScriptDir%\CMU-1.ndpi",, Max
  WinWaitActive, ahk_exe sedeen.exe
  Sleep, %wait_time%
  Send, {Alt}vl{Down}{Enter}  ; Removes tabs taking up space.
  Send, {Alt}vt{Down}{Enter}  ; Opens zoom bar.
  Sleep, 100
  Click, 30, 250              ; Zooms to 20x.
  Sleep, 100
  Send, {Alt}vt{Down}{Enter}  ; Closes zoom bar.
  Send, {Alt}vt{Enter}        ; Opens slide map.
  MoveFOV(sdn_map_width, sdn_map_height, sdn_map_x, sdn_map_y)
  Send, {Alt}vt{Enter}        ; Closes slide map.

  Snip(0, 43, A_ScreenWidth, A_ScreenHeight-61, "sedeen")
  CloseAllInstances("sedeen.exe")
}

MoveFOV(mapwidth, mapheight, mapx, mapy)
{
  global 
  
  xcf := mapwidth/img_width, ycf := mapheight/img_height  ; Conversion factors.
  smallx := Round(img_x*xcf), smally := Round(img_y*ycf)  ; Coordinates to click, relative to the slide map.
  ;MouseMove, mapx-mapwidth+smallx, mapy+smally
  ;MsgBox, Clicking on %smallx% %smally%
  Sleep, 100
  MouseClick, left, mapx-mapwidth+smallx, mapy+smally            ; Clicks absolute coordinates to move FOV.
}

LowerMoveFOV(mapwidth, mapheight, mapx, mapy)
{
  global 
  
  xcf := mapwidth/img_width, ycf := mapheight/img_height  ; Conversion factors.
  smallx := Round(img_x*xcf), smally := Round(img_y*ycf)  ; Coordinates to click, relative to the slide map.
  ;MouseMove, mapx-mapwidth+smallx, mapy-mapheight+smally
  ;MsgBox, Clicking on %smallx% %smally%
  Sleep, 100
  MouseClick, left, mapx-mapwidth+smallx, mapy-mapheight+smally            ; Clicks absolute coordinates to move FOV.
}

Snip(x1, y1, x2, y2, name)
{
  Sleep, 500
  Run, "%a_windir%\System32\SnippingTool.exe"     ; Runs Snipping Tool
  WinWaitActive, Snipping Tool                    ; Waits for the Snipping Tool to start before running further commands.
  MouseClickDrag, left, %x1%, %y1%, %x2%, %y2%    ; Executes a snip.
  Send, ^s                                        ; Opens save window.
  WinWaitActive, Save As                          ; Waits for the save window to appear.
  Send, %name%                                    ; Assigns name to file.
  Send, {Enter}                                   ; Saves file.
  WinWaitActive, Snipping Tool                    ; Waits for save window to close.
  Sleep, 200
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
