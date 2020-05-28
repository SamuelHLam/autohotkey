; passing parameters - https://www.autohotkey.com/docs/Scripts.htm#cmd
; 4/5/2020: changed to SendInput

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
SendInput, ^v

; save as
SendInput, !f
SendInput, a

; need to wait here; otherwise filename got cut
WinWait, Save As
SendInput, %1%
SendInput, !s

; exit
SendInput, !f
SendInput, x

WinWaitClose
return

