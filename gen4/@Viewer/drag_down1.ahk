; passing parameters - https://www.autohotkey.com/docs/Scripts.htm#cmd

; find the window
if WinExist(%1%)
{
    WinActivate  ; Uses the last found window.
}

; Drag down
MouseClickDrag, L, 500, 500, 500, %2%, 100

;wait
Sleep, 500

return
