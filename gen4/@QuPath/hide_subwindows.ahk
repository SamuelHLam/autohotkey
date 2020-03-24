; passing parameters - https://www.autohotkey.com/docs/Scripts.htm#cmd

; find the window
if WinExist(%1%)
{
    WinActivate  ; Uses the last found window.
}

WinWait, %1%

; cursor location
Send, {Esc}
Send, {Alt}
Send, {Right}
Send, {Right}
Send, {Right}
Send, {Down}
Send, {Down}
Send, {Down}
Send, {Down}
Send, {Down}
Send, {Down}
Send, {Down}
Send, {Down}
Send, {Down}
Send, {Down}
Send, {Down}
Send, {Down}
Send, {Down}
Send, {Down}
Send, {Down}
Send, {Down}
Send, {Down}
Send, {Enter}

; scale bar
Send, {Esc}
Send, {Alt}
Send, {Right}
Send, {Right}
Send, {Right}
Send, {Down}
Send, {Down}
Send, {Down}
Send, {Down}
Send, {Down}
Send, {Down}
Send, {Down}
Send, {Down}
Send, {Down}
Send, {Down}
Send, {Down}
Send, {Down}
Send, {Down}
Send, {Down}
Send, {Down}
Send, {Down}
Send, {Down}
Send, {Down}
Send, {Enter}


; panel
Send, +a

sleep, 1000

return

