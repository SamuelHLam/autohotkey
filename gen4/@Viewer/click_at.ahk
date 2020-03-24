; passing parameters - https://www.autohotkey.com/docs/Scripts.htm#cmd

; find the window
if WinExist(%1%)
{
    WinActivate  ; Uses the last found window.
}

WinActivate, %1%

; click
CoordMode, Mouse, Screen    ; Absolute coordinates when using mouse functions
Click %2%, %3%, left

Sleep, 500

return

