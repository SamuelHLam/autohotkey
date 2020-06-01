; passing parameters - https://www.autohotkey.com/docs/Scripts.htm#cmd

; open the WSI
Send, ^o
sleep, 1000
;WinWaitActive, Open file

Send, %2%
Send, !o

; wait
sleep, 1000


return

