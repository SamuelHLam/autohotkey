; 4-4-2020
; for pan_xy()

; for debugging
; MsgBox, %2% . %3% . %4% . %5%

; passing parameters - https://www.autohotkey.com/docs/Scripts.htm#cmd

; find the window
if WinExist(%1%)
{
    WinActivate  ; Uses the last found window.
}

;  save the current location
MouseGetPos, xpos, ypos

;wait
Sleep, 500

;  do mouse dragging slowly
xfrom := A_Args[4]
xto := A_Args[4] + A_Args[2]
yfrom := A_Args[5]
yto := A_Args[5] + A_Args[3]
 
; for debugging
; MsgBox, %xfrom% . %xto% . %yfrom% . %yto%

MouseClickDrag, L, %xfrom%, %yfrom%, %xto%, %yto%, 100

;wait
Sleep, 500

;  restore the previoius location
MouseMove, xpos, ypos

return
