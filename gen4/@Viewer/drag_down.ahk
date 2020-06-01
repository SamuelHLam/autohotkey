; passing parameters - https://www.autohotkey.com/docs/Scripts.htm#cmd

; find the window
if WinExist(%1%)
{
    WinActivate  ; Uses the last found window.
}

; wait
Sleep, 1000

; Click
MouseClick, L, 500, 500, 1, 100

; wait
Sleep, 1000

; Drag down
MouseClickDrag, L, 500, 500, 500, %2%, 100

; wait
Sleep, 1000

return
