; Assignment #2 assigned by WCC, 7/23/2019
; Goal: enter QuPath, take a screenshot with Snipping Tool, and then exit QuPath
; Condition: QuPath is already installed and can be invoked from Windows 
; Requirements: 100% clear comments
; 7/9/2019 code added by Samuel
; 7/10/2019 comments added by WCC

;
; Default parameters
;
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.

#SingleInstance Force       ; In case previous script did not quit

CoordMode, Pixel, Screen    ; Absolute coordinates when using pixel search functions
CoordMode, Mouse, Screen    ; Absolute coordinates when using mouse functions

;
; Input parameters
;

; Dimensions of slide image
img_width   := 51200
img_height  := 38144

; Boundaries of region of interest on slide
x1          := 5850
y1          := 30000
x2          := 6850
y2          := 30800

;
; Global variables
;

; Target image path
target_path = "%A_WorkingDir%\target.png"

; Center of region of interest
roi_x           := round((x1+x2)/2)
roi_y           := round((y1+y2)/2)
;roi_x := 6200
;roi_y := 30200

; Position of ASAP slide map (bottom right corner)
asap_map_x  := A_ScreenWidth-33
asap_map_y  := A_ScreenHeight-93

; Position of ImageScope slide map (top right corner)
is_map_x    := A_ScreenWidth-8
is_map_y    := 32

; Position of NDP.view 2 slide map (bottom right corner)
ndp_map_x   := A_ScreenWidth-17
ndp_map_y   := A_ScreenHeight-17

; Position of QuPath slide map (top right corner)
qp_map_x    := A_ScreenWidth-12
qp_map_y    := 92

; Position of Sedeen slide map (top right corner)
sdn_map_x   := A_ScreenWidth-2
sdn_map_y   := 44

;
; Main -- how to start the script; change the key assignment here 
;
; https://www.autohotkey.com/docs/commands/MouseClickDrag.htm
;

; Drag left
!+1::
MouseClickDrag, L, 150, 150, 200, 150
return

; Drag right
!+2::
MouseClickDrag, L, 150, 150, 100, 150
return

; Drag up
!+3::
MouseClickDrag, L, 150, 150, 150, 100
return

; Drag down
!+4::
MouseClickDrag, L, 150, 150, 150, 200
return

; Wheel up
!+5::
MouseMove, 150, 150
Send, {WheelUp}
return

; Wheel down
!+6::
MouseMove, 150, 150
Send, {WheelDown}
return

; move FOV main
!+a::
LowerMoveFOV(asap_map_x, asap_map_y, 0x000000, 0)
return

!+n::
LowerMoveFOV(ndp_map_x, ndp_map_y, 0x707000, -2)
return

!+q::
MoveFOV(qp_map_x, qp_map_y, 0x404040, 0)
return

!+s::
MoveFOV(sdn_map_x, sdn_map_y, 0x000000, 1)
return

; Set up target window
!+t::
Gui, New
Gui, +AlwaysOnTop
;Gui, -caption -Border
Gui, Add, Picture, , %A_WorkingDir%\target.png
Gui, Margin, 0, 0
Gui, Show, AutoSize Center
WinSet, Transparent, 150, viewer_interface.ahk
return

; Close target window after panning
!+c::
PostMessage, 0x112, 0xF060,,, viewer_interface.ahk

Esc::
ExitApp

; For viewers that have slide maps in the upper right (ImageScope, QuPath, Sedeen)
; map_x and map_y are the coordinates for the upper right corner of the map
MoveFOV(map_x, map_y, border_color, offset)
{
    global
    ; Find left border by scanning along x-axis searching for border color
    map_width := 5
    Loop
    {
        map_width++
        PixelGetColor, curr, map_x - map_width, map_y + 5
        MouseMove, map_x - map_width, map_y + 5
    } Until curr == border_color
    map_width += offset
    ;MsgBox, The width is %map_width%.

    ; Find lower border by scanning along y-axis searching for border color
    map_height := 5
    Loop
    {
        map_height++
        PixelGetColor, curr, map_x - 5, map_y + map_height
        MouseMove, map_x - 5, map_y + map_height
    } Until curr == border_color
    map_height += offset
    ;MsgBox, The height is %map_height%.
    
    ; Conversion factors
    xcf := map_width/img_width, ycf := map_height/img_height
    
    ; Coordinates to click, relative to the slide map.
    small_x := Round(roi_x*xcf), small_y := Round(roi_y*ycf)
    Sleep, 100
    
    click_x := map_x - map_width + small_x
    click_y := map_y + small_y
    
    ; Clicks absolute coordinates to move FOV.
    Click, %click_x%, %click_y%
}

; For viewers that have slide maps in the lower right corner (ASAP, NDP)
; map_x and map_y are the coordinates for the lower right corner of the map
; Checking for the border involves bit masking because the border color of the map
; in NDP is inconsistent, always some variation of 0x7_7___
LowerMoveFOV(map_x, map_y, border_color, offset)
{
    global 
    
    ; Find left border
    map_width := 5
    Loop
    {
        map_width++
        PixelGetColor, curr, map_x - map_width, map_y - 5
        MouseMove, map_x - map_width, map_y - 5
    } Until ((border_color == 0) ? (curr == border_color) : (curr & border_color == border_color))
    map_width += offset
    ;MsgBox, The width is %map_width%.

    ; Find upper border
    map_height := 5
    Loop
    {
        map_height++
        PixelGetColor, curr, map_x - 5, map_y - map_height
        MouseMove, map_x - 5, map_y - map_height
    } Until ((border_color == 0) ? (curr == border_color) : (curr & border_color == border_color))
    map_height += offset
    ;MsgBox, The height is %map_height%.
    
    xcf := map_width/img_width, ycf := map_height/img_height
    small_x := Round(roi_x*xcf), small_y := Round(roi_y*ycf)
    Sleep, 100
    
    click_x := map_x - map_width + small_x
    click_y := map_y - map_height + small_y
    
    Click, %click_x%, %click_y%
}