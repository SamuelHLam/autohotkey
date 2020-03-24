; passing parameters - https://www.autohotkey.com/docs/Scripts.htm#cmd

; https://www.autohotkey.com/docs/commands/SetTitleMatchMode.htm
; 1: A window's title must start with the specified WinTitle to be a match.
; 2: A window's title can contain WinTitle anywhere inside it to be a match.
; 3: A window's title must exactly match WinTitle to be a match.
SetTitleMatchMode, 1

; Slow: Can be much slower, but works with all controls which respond to the WM_GETTEXT message.
SetTitleMatchMode, slow

; check if app is already open
;If WinExist(%1%)
;{
;	MsgBox % "already running"
;	return 
;}

; start the application
; https://www.autohotkey.com/docs/commands/Run.htm
; Max: launch maximized -- doesn't work
Run, %2%, Max

; wait
WinWait, NDP.view 2

WinShow, NDP.view 2

; add delay for NDP to accept keyboard input
sleep, 2000

; maximize window
Send, #{Up}

; add delay for NDP to accept keyboard input
sleep, 2000

; hide widget
; Send, t


return

