; passing parameters - https://www.autohotkey.com/docs/Scripts.htm#cmd

; check if app is already open
If WinExist(%1%)
{
	MsgBox % "already running"
	return 
}

; start the application
Run, %2%

; wait until activated
WinWaitActive, %1%

; maximize window
Send, #{Up}


return

