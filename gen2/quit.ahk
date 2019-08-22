#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

exename = %1%
quit(exename)
ExitApp

quit(exename)
{
    ; Puts all window names belonging to the parameter process into a list "WindowsList".
    WinGet WindowsList, List, % "ahk_exe" exename
    
    ; Loops through all window names.
    Loop, %WindowsList%
    {
        ;
        ; Mimics the user closing every window
        ; Usage of PostMessage: 
        ; PostMessage, Msg , wParam, lParam, Control, WinTitle, WinText, ExcludeTitle, ExcludeText
        ;   see https://www.autohotkey.com/docs/commands/PostMessage.htm
        ;
        ; Msg = 0x112 (WM_SYSCOMMAND)   Message is sent as a system command
        ; wParam = 0xF060 (SC_CLOSE)    The message comprises SC_CLOSE, sent as a parameter of WM_SYSCOMMAND
        ; lParam = 0                    Default value of 0 is sent
        ; Control = ""                  Message directly sent to target window
        ; WinTitle = % "ahk_id" WindowsList%A_Index%
        ;
        PostMessage, 0x112, 0xF060,,, % "ahk_id" WindowsList%A_Index%
        
        ; Optionally, a more "forceful" way of closing windows by sending WM_CLOSE instead of SC_CLOSE
        ; The difference between WM_CLOSE and SC_CLOSE is explained here: https://stackoverflow.com/q/10101742
        ; WinClose, % "ahk_id" Windows%A_Index%
    }
}

