; passing parameters - https://www.autohotkey.com/docs/Scripts.htm#cmd

; find the window
if WinExist(%1%)
{
    WinActivate  ; Uses the last found window.
}

WinWait, %1%

; minimap
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
Send, {Enter}

return

