; passing parameters - https://www.autohotkey.com/docs/Scripts.htm#cmd

; find the window
if WinExist(%1%)
{
    WinActivate  ; Uses the last found window.
}

; wait
Sleep, 1000

; Click
MouseClick, L, 150, 150, 1, 100

; wait
Sleep, 1000


; Drag left
MouseClickDrag, L, 150, 150, %2%, 150, 100

; wait
Sleep, 1000

return
