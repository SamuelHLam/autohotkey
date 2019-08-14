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

; In milliseconds. Used to wait for images to fully load
wait_time := 2000

; Desired magnification
magnification := 20

; This determines where the screenshots are saved
out_loc := "C:\Users\Qi Gong\Documents\GitHub\autohotkey\matlab scripts\" 

; Dimensions of slide image.
img_width       := 51200,             img_height      := 38144
; Region of interest on slide.
img_x           := 4900,              img_y           := 30000

; Dimensions of ASAP slide map
asap_map_width  := 249,               asap_map_height := 185
; Position of ASAP slide map (bottom right corner)
asap_map_x      := A_ScreenWidth-33,  asap_map_y      := A_ScreenHeight-93

; Dimensions of ImageScope slide map
is_map_width    := 420,               is_map_height   := 312
; Position of ImageScope slide map (top right corner)
is_map_x        := A_ScreenWidth-8,   is_map_y        := 32

; Dimensions of NDP.view 2 slide map
ndp_map_width   := 480,               ndp_map_height  := 357
; Position of NDP.view 2 slide map (bottom right corner)
ndp_map_x       := A_ScreenWidth-18,  ndp_map_y       := A_ScreenHeight-18

; Dimensions of QuPath slide map
qp_map_width    := 149,               qp_map_height   := 110
; Position of QuPath slide map (top right corner)
qp_map_x        := A_ScreenWidth-12,  qp_map_y        := 92

; Dimensions of Sedeen slide map
sdn_map_width   := 323,              sdn_map_height   := 242
; Position of Sedeen slide map (top right corner)
sdn_map_x       := A_ScreenWidth-2,  sdn_map_y        := 44

;
; Main -- how to start the script; change the key assignment here 
;
^k::  ; Can be mapped to any hotkey.

; Cleans out previous screenshots
FileDelete, % out_loc . "asap.png"
FileDelete, % out_loc . "ndpview2.png"
FileDelete, % out_loc . "qupath.png"
FileDelete, % out_loc . "sedeen.png"

ASAPSnip()
; I was having some problems with Snipping Tool not closing, so this is just to make sure.
CloseAllInstances("SnippingTool.exe")
NDPSnip()
CloseAllInstances("SnippingTool.exe")
QPSnip()
CloseAllInstances("SnippingTool.exe")
SedeenSnip()
CloseAllInstances("SnippingTool.exe")

; Executes normally, but can be used as an emergency escape.
Esc::ExitApp

;
; Functions
;
ASAPSnip()
{
  ; Makes sure this function has access to all global variables.
  global
  
  ; Opens CMU-1.ndpi with ASAP with the window maximized; waits for ASAP to load fully
  Run, %ProgramFiles%\ASAP 1.9\bin\ASAP.exe "%A_ScriptDir%\CMU-1.ndpi",, Max
  WinWaitActive, ahk_exe ASAP.exe
  Sleep, %wait_time%
  
  ; Remove all sidebars
  Send, {Alt}{Right}{Up 2}{Right}{Enter}
  Send, {Alt}{Right}{Up 2}{Right}{Down}{Enter}
  Send, {Alt}{Right}{Up 2}{Right}{Down 2}{Enter}
  ; Remove toolbar.
  Click, right, 120, 30
  Send, {Up}{Enter}
  
  ; Zoom in to approximately 20x
  MouseMove, 3, 50
  Loop 72
  {
    Send, {WheelUp}
    Sleep, 500
  }
  
  ; Open slide map
  Send, {Alt}{Right}{Up 3}{R}{Enter}
  Sleep, 100
  
  ; Move field of view
  LowerMoveFOV(asap_map_width, asap_map_height, asap_map_x, asap_map_y)
  
  ; Close slide map
  Send, {Alt}{Right}{Up 3}{R}{Enter}
  
  ; Take screen shot
  Snip(out_loc . "asap.png")
  
  ; Exit ASAP
  CloseAllInstances("ASAP.exe")
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
  
  Snip(out_loc . "imagescope.png")
  CloseAllInstances("ImageScope.exe")
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
  
  Snip(out_loc . "ndpview2.png")
  CloseAllInstances("NDPView2.exe")
}

QPSnip()
{
  global
  
  Run, %ProgramFiles%\QuPath\QuPath.exe "%A_ScriptDir%\CMU-1.ndpi",, Max
  WinWaitActive, ahk_exe QuPath.exe
  Sleep, %wait_time%
  
  Send, +a                          ; Removes side bar
  MouseMove, 430, 60                ; Moves mouse over magnification button
  Click, 2                          ; Double clicks to open up magnification menu
  WinWaitActive, Set magnification  ; Waits for magnification menu to open
  Send, +{Tab}                      ; Navigates to the navigation input box
  Send, %magnification%             ; Sets desired magnification
  Send, {Enter}
  
  MoveFOV(qp_map_width, qp_map_height, qp_map_x, qp_map_y)
  
  ; Removes unnecessary menu items (slide map, etc.)
  Send, +{Tab 4}{Space} 
  Send, +{Tab}{Space}
  Send, +{Tab}{Space}
  
  Snip(out_loc . "qupath.png")
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

  Snip(out_loc . "sedeen.png")
  CloseAllInstances("sedeen.exe")
}

; For viewers that have slide maps in the upper right (ASAP, ImageScope, QuPath)
; map_x and map_y are the coordinates for the upper right corner of the map
MoveFOV(map_width, map_height, map_x, map_y)
{
  global 
  
  ; Conversion factors
  xcf := map_width/img_width, ycf := map_height/img_height
  
  ; Coordinates to click, relative to the slide map.
  small_x := Round(img_x*xcf), small_y := Round(img_y*ycf)
  Sleep, 100
  
  ; Clicks absolute coordinates to move FOV.
  MouseClick, left, map_x-map_width+small_x, map_y+small_y
}

; For viewers that have slide maps in the lower right corner (NDP, Sedeen)
; map_x and map_y are the coordinates for the upper right corner of the map
LowerMoveFOV(map_width, map_height, map_x, map_y)
{
  global 
  
  xcf := map_width/img_width, ycf := map_height/img_height
  small_x := Round(img_x*xcf), small_y := Round(img_y*ycf)
  Sleep, 100
  
  MouseClick, left, map_x-map_width+small_x, map_y-map_height+small_y
}

Snip(name)
{
  Sleep, 500
  
  ; Runs Snipping Tool and waits for it to load fully
  Run, "%a_windir%\System32\SnippingTool.exe"
  WinWaitActive, Snipping Tool
  
  Send, !n                      ; Opens snipping tool menu.
  Send, {Up}                    ; Selects full screen shot.
  Send, {Enter}                 ; Takes screen shot.
  Send, ^s                      ; Opens save window.
  WinWaitActive, Save As        ; Waits for the save window to appear.
  Send, %name%                  ; Assigns name to file.
  Send, {Enter}                 ; Saves file.
  WinWaitActive, Snipping Tool  ; Waits for save window to close.
  Sleep, 200
  
  ; Exits Snipping Tool
  CloseAllInstances("SnippingTool.exe")
}



CloseAllInstances(exename)
{
  ; Puts all window names belonging to the parameter process into a list "WindowsList".
  WinGet WindowsList, List, % "ahk_exe" exename
  
  ; Loops through all window names.
  Loop, %WindowsList%
  {
    ;
    ; Mimics the user closing every window
    ; Usage of PostMessage: 
    ; PostMessage, Msg , wParam, lParam, Control, WinTitle, WinText, ExcludeTitle, ExcludeText
    ;   see https://www.autohotkey.com/docs/commands/PostMessage.htm
    ;
    ; Msg = 0x112 (WM_SYSCOMMAND)   Message is sent as a system command.
    ; wParam = 0xF060 (SC_CLOSE)    The message comprises SC_CLOSE, sent as a parameter of WM_SYSCOMMAND.
    ; lParam = 0                    Default value of 0 is sent.
    ; Control = ""                  Message directly sent to target window.
    ; WinTitle = % "ahk_id" WindowsList%A_Index%
    ;
    PostMessage, 0x112, 0xF060,,, % "ahk_id" WindowsList%A_Index%
    
    ; Optionally, a more "forceful" way of closing windows by sending WM_CLOSE instead of SC_CLOSE
    ; The difference between WM_CLOSE and SC_CLOSE is explained here: https://stackoverflow.com/q/10101742
    ; WinClose, % "ahk_id" Windows%A_Index%
  }
}
