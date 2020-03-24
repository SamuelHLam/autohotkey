; passing parameters - https://www.autohotkey.com/docs/Scripts.htm#cmd


; open the WSI
Send, ^o
WinWait, Open File
Send, %2%
Send, !o

; wait
sleep, 3000


return

