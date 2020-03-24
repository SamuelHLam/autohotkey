; passing parameters - https://www.autohotkey.com/docs/Scripts.htm#cmd

; find the window
if WinExist(%1%)
{
    WinActivate  ; Uses the last found window.
}

WinWait, %1%

; thumbnail

Sleep, 1000
Send, m
Sleep, 1000

return

