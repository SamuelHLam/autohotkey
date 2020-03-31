; Hotkey is Win + Alt + 1
; When that is used, the currently active window will become semi-transparent.
; That status will remain until either the window is closed and re-opened,
; or the script Transparency OFF.ahk is used (hotkey Win + Alt + 2).
; I haven't yet checked whether these hotkeys conflict with keyboard shortcuts used by other applications.

#!1::
   WinSet, Transparent, 150, A
return

; Hotkey is Win + Alt + 2
; When that is used, the currently active window will become fully opaque again.
; I haven't yet checked whether this hotkey conflict with keyboard shortcuts used by other applications.

#!2::
   WinSet, Transparent, OFF, A 
return
