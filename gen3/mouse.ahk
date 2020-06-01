
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
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


;
; Main -- how to start the script; change the key assignment here 
;
; https://www.autohotkey.com/docs/commands/MouseClickDrag.htm
;
;
;Clicks and holds the specified mouse button, moves the mouse to the destination coordinates, then releases the button.
;
;MouseClickDrag, WhichButton, X1, Y1, X2, Y2 , Speed, Relative
;
;Relative
;If omitted, the X and Y coordinates will be treated as absolute values. To change this behavior, specify the following letter:
;
;R: The X1 and Y1 coordinates will be treated as offsets from the current mouse position. In other words, the cursor will be moved from its current position by X1 pixels to the right (left if negative) and Y1 pixels down (up if negative). Similarly, the X2 and Y2 coordinates will be treated as offsets from the X1 and Y1 coordinates. For example, the following would first move the cursor down and to the right by 5 pixels from its starting position, and then drag it from that position down and to the right by 10 pixels: MouseClickDrag, Left, 5, 5, 10, 10, , R.


; pan left
^1::                                                  
MouseClickDrag, Left, 0, 0, -1, 0, 100, Relative
return

; pan right
^2::                                                  
MouseClickDrag, Left, 0, 0, +1, 0, 100, Relative
return

; pan up
^3::                                                  
MouseClickDrag, Left, 0, 0, 0, -1, 100, Relative
return

; pan down
^4::                                                  
MouseClickDrag, Left, 0, 0, 0, +1, 100, Relative
return


; pan left
^q::                                                  
MouseMove, -1, 0, 100, Relative
return

; pan right
^w::                                                  
MouseMove, +1, 0, 100, Relative
return

; pan up
^e::                                                  
MouseMove, 0, -1, 100, Relative
return

; pan down
^r::                                                  
MouseMove, 0, +1, 100, Relative
return

; zoom in
!+5::
Send, {WheelUp}
return

; zoom out
!+6::
Send, {WheelDown}
return
