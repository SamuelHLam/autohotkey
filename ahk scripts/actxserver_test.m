function actxserver_test

% use ActiveX
h = actxserver('WScript.Shell');                      % ActiveX

% run script
h.Run("autohotkey.exe v6.ahk");
pause(1)

% send hotkey
h.SendKeys('^k');
end

