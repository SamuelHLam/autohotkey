; passing parameters - https://www.autohotkey.com/docs/Scripts.htm#cmd

;	MsgBox %1%

; find the window
;if WinExist, QuPath
;{
;    WinActivate  ; Uses the last found window.
;	WinWait, %1%
;}
;else
;{
;	MsgBox % "Cannot find window"
;	return
;}

; close the application
Send, !{F4}

return

