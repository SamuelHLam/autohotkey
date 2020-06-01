; passing parameters - https://www.autohotkey.com/docs/Scripts.htm#cmd

; check if app is already open
If WinExist(%1%)
{
	MsgBox % "already running"
	return 
}

; start the application
Run, %2%

; update window
; wait until activated
; disappeared after April!
WinWaitActive, Software Update
; close window
Send, !{F4}

; wait until activated
WinWaitActive, Sedeen Viewer

; maximize window
Send, #{Up}


return

