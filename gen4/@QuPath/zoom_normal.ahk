; passing parameters - https://www.autohotkey.com/docs/Scripts.htm#cmd

; find the window
if WinExist(%1%)
{
    WinActivate  ; Uses the last found window.
}

WinWait, %1%

; minimap
; need delay to work!!
delay := 150

Send, {Esc}
Sleep, %delay%

Send, {Alt}
Sleep, 1000

Send, {Right}
Sleep, %delay%
Send, {Right}
Sleep, %delay%
Send, {Right}
Sleep, %delay%

Send, {Down}
Sleep, %delay%
Send, {Down}
Sleep, %delay%
Send, {Down}
Sleep, %delay%
Send, {Down}
Sleep, %delay%
Send, {Down}
Sleep, %delay%
Send, {Down}
Sleep, %delay%

Send, {Right}
Sleep, %delay%

Send, {Down}
Sleep, %delay%

Send, {Enter}
Sleep, 1000

return

