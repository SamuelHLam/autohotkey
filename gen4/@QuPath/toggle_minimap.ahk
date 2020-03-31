; passing parameters - https://www.autohotkey.com/docs/Scripts.htm#cmd

; find the window
if WinExist(%1%)
{
    WinActivate  ; Uses the last found window.
}

WinWait, %1%

; minimap
; need delay to work!!
delay := 500

Send, {Esc}
Sleep, 1000

; menu bar
Send, {Alt}
Sleep, 1000

; View
Send, {Right}
Sleep, %delay%
Send, {Right}
Sleep, %delay%
Send, {Right}
Sleep, 500

; wait to pull down menu
Send, {Down}
Sleep, 1000

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
Send, {Down}
Sleep, %delay%
Send, {Down}
Sleep, %delay%

Send, {Down}
Sleep, %delay%

Send, {Enter}
Sleep, 1000

return

