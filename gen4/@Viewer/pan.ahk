; passing parameters - https://www.autohotkey.com/docs/Scripts.htm#cmd

; find the window
if WinExist(%1%)
{
    WinActivate  ; Uses the last found window.
}

;wait
Sleep, 500

; Drag
MouseGetPos, xpos, ypos
MouseClickDrag, L, 500, 500, %2%, %3%, 100
MouseMove, xpos, ypos

;wait
Sleep, 500

return
