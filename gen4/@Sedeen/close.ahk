; passing parameters - https://www.autohotkey.com/docs/Scripts.htm#cmd


; find the window
;if WinExist, %1%
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

