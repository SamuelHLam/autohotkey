%
% generate keyboard events with ActiveX
% by WCC
% 8/14/2019
% https://social.technet.microsoft.com/wiki/contents/articles/5169.vbscript-sendkeys-method.aspx

function actxserver_test

asap
return

fn = 'C:\Users\wcc\Desktop\mytest.png'
screenshot(fn)
end

function qupath

% use ActiveX
h = actxserver('WScript.Shell');                      % ActiveX

% start QuPath
% "C:\Program Files\QuPath\QuPath.exe"
dir_init = cd; 
cd('C:\\Program Files\\QuPath');
h.Run('QuPath.exe');
pause(6)

% focus on the window
h.AppActivate('QuPath (0.1.2)');

cd(dir_init)

% open file
h.SendKeys('^o');

pause(1)
h.SendKeys('C:\Users\wcc\Desktop\CMU-1.ndpi');

pause(1)
h.SendKeys('%O');

pause(5)

% do it

h.SendKeys('^k');
pause(5)

% exit
h.SendKeys('%{F4}');

return

end


function asap

% use ActiveX
h = actxserver('WScript.Shell');                      % ActiveX

% start ASAP
% fn = 'C:\Program Files\ASAP 1.9\bin\ASAP.exe';

dir_init = cd; 
cd('C:\\Program Files\\ASAP 1.9\\bin');

h.Run('asap');
pause(5)

% focus on the window
h.AppActivate('ASAP');

% open file
h.SendKeys('^o');

pause(1)
h.SendKeys('C:\Users\wcc\Desktop\CMU-1.ndpi');

pause(1)
h.SendKeys('%o');

cd(dir_init)
pause(2)

% do it

% need to move cursor to center

for i = 1:10
h.SendKeys('%!');
pause(1)
end

if 0
h.SendKeys('%!');
pause(2)

h.SendKeys('%@');
pause(2)

h.SendKeys('%#');
pause(2)

h.SendKeys('%$');
pause(2)
end

pause(5)

% exit
h.SendKeys('%{F4}');


return

end

function screenshot (fullpathname)

% use ActiveX
h = actxserver('WScript.Shell');                      % ActiveX

% start SnippingTool
h.Run('SnippingTool');

% focus on the window
h.AppActivate('Snipping Tool');

% "New"
pause(1)
h.SendKeys('%N');

% prepare the screen here
%

% "Full Screen Snip"
pause(1)
h.SendKeys('s');

% "File"
pause(1)
h.SendKeys('%F');

% "Save as"
pause(1)
h.SendKeys('a');

% the full pathname
pause(1)
h.SendKeys(fullpathname);

% "Save"
h.SendKeys('%S');

% "File"
pause(1)
h.SendKeys('%F');

% "Exit"
pause(1)
h.SendKeys('x');

end


