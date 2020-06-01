; passing parameters - https://www.autohotkey.com/docs/Scripts.htm#cmd

; find the window
if WinExist(%1%)
{
    WinActivate  ; Uses the last found window.
}

; Drag up
MouseGetPos, xpos, ypos
MouseClickDrag, L, xpos, ypos, xpos, ypos-20, 100
MouseMove, xpos, ypos
return
