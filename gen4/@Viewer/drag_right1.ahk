; passing parameters - https://www.autohotkey.com/docs/Scripts.htm#cmd

; find the window
if WinExist(%1%)
{
    WinActivate  ; Uses the last found window.
}

; Drag left
MouseClickDrag, L, 150, 150, %2%, 150, 100

;wait
Sleep, 500

return
