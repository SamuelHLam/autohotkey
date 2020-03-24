; passing parameters - https://www.autohotkey.com/docs/Scripts.htm#cmd

; open the WSI
Send, ^{PrintScreen}

FileDelete, %1%

Run, mspaint.exe

WinWait, Untitled - Paint

if WinExist("Untitled - Paint")
{
    WinActivate  ; Uses the last found window.
}


; paste
Send, ^v

; save as
Send, !f
Send, a

; need to wait here; otherwise filename got cut
WinWait, Save As
Send, %1%
Send, !s

; exit
Send, !f
Send, x

WinWaitClose
return

