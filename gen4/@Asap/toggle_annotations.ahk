; passing parameters - https://www.autohotkey.com/docs/Scripts.htm#cmd

; find the window
if WinExist(%1%)
{
    WinActivate  ; Uses the last found window.
}

WinActivate, ASAP

; open the WSI
Send, {Esc}
Send, {Alt}
Send, {Right}
Send, {Down}
Send, {Down}
Send, {Down}
Send, {Down}
Send, {Right}
Send, {Enter}

return

