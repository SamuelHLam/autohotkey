; passing parameters - https://www.autohotkey.com/docs/Scripts.htm#cmd

; find the window
if WinExist(%1%)
{
    WinActivate  ; Uses the last found window.
}

WinWait, %1%

; 20x

Sleep, 1000
;for cmu-1
;Send, ^n
;works for camelyon
Send, ^f
Send, !v
Send,{Enter}
Send, !v
Send,{Enter}
Send, !v
Send,{Enter}
Send, !v
Send,{Enter}
Send, !v
Send,{Enter}
Sleep, 1000

return

