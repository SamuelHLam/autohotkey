%
% generate keyboard events with ActiveX
% by WCC
% 8/14/2019
% https://social.technet.microsoft.com/wiki/contents/articles/5169.vbscript-sendkeys-method.aspx
% 9/10/2019

function actxserver_test

wsi_filename = 'C:\Users\wcc\Desktop\CMU-1.ndpi'

qupath2
return

asap(wsi_filename)
return

fn = 'C:\Users\wcc\Desktop\mytest.png'
screenshot(fn)
end

function qupath2 (wsi_filename)

% save the initial directory
dir_init = cd;

% use ActiveX
h = actxserver('WScript.Shell');                      % ActiveX


% focus on the window
h.AppActivate('QuPath (0.1.2)');
pause(1)

%
h.SendKeys('{INSERT}');
pause(1)
h.SendKeys('{LEFT}');
pause(1)

return

% go back to the intitial directory
cd(dir_init)

% open File/Open by ^o
h.SendKeys('^o');
pause(1)

% enter the WSI filename
h.SendKeys(wsi_filename);
pause(1)

% open file by alt-o
h.SendKeys('%O');
pause(5)

% close the analysis panel by shift-a
h.SendKeys('+a');
pause(1)

% choose zoom level

% goto menu
h.SendKeys('%');
pause(1)

% the "View" tab
h.SendKeys('{RIGHT}')
pause(1)
h.SendKeys('{RIGHT}')
pause(1)
h.SendKeys('{RIGHT}')
pause(1)

% the "Zoom" entry
h.SendKeys('{DOWN}')
pause(1)
h.SendKeys('{DOWN}')
pause(1)
h.SendKeys('{DOWN}')
pause(1)
h.SendKeys('{DOWN}')
pause(1)
h.SendKeys('{DOWN}')
pause(1)
h.SendKeys('{DOWN}')
pause(1)
h.SendKeys('{RIGHT}')
pause(1)

% "100%" is 20x
h.SendKeys('{DOWN}');
pause(1)
h.SendKeys('{ENTER}');
pause(1)

% do it

%h.SendKeys('^k');
pause(5)

% exit QuPath by closing the window by alt-F4
h.SendKeys('%{F4}');

return

end


%
% QuPath
%
function qupath (wsi_filename)

% save the initial directory
dir_init = cd;

% use ActiveX
h = actxserver('WScript.Shell');                      % ActiveX

% start QuPath
% The executable is in "C:\Program Files\QuPath\QuPath.exe"
cd('C:\\Program Files\\QuPath');
h.Run('QuPath.exe');
pause(6)

% focus on the window
h.AppActivate('QuPath (0.1.2)');

% go back to the intitial directory
cd(dir_init)

% open File/Open by ^o
h.SendKeys('^o');
pause(1)

% enter the WSI filename
h.SendKeys(wsi_filename);
pause(1)

% open file by alt-o
h.SendKeys('%O');
pause(5)

% close the analysis panel by shift-a
h.SendKeys('+a');
pause(1)

% choose zoom level

% goto menu
h.SendKeys('%');
pause(1)

% the "View" tab
h.SendKeys('{RIGHT}')
pause(1)
h.SendKeys('{RIGHT}')
pause(1)
h.SendKeys('{RIGHT}')
pause(1)

% the "Zoom" entry
h.SendKeys('{DOWN}')
pause(1)
h.SendKeys('{DOWN}')
pause(1)
h.SendKeys('{DOWN}')
pause(1)
h.SendKeys('{DOWN}')
pause(1)
h.SendKeys('{DOWN}')
pause(1)
h.SendKeys('{DOWN}')
pause(1)
h.SendKeys('{RIGHT}')
pause(1)

% "100%" is 20x
h.SendKeys('{DOWN}');
pause(1)
h.SendKeys('{ENTER}');
pause(1)

% do it

%h.SendKeys('^k');
pause(5)

% exit QuPath by closing the window by alt-F4
h.SendKeys('%{F4}');

return

end


%
% ASAP
%
% timing is based on WCC's NUC2
function asap (wsi_filename)

% save the current directory
dir_init = cd;

% use ActiveX
h = actxserver('WScript.Shell');                      % ActiveX

% start ASAP
% the executable is in 'C:\Program Files\ASAP 1.9\bin\ASAP.exe';
cd('C:\\Program Files\\ASAP 1.9\\bin');
h.Run('asap');
pause(5)

% focus on the window
h.AppActivate('ASAP');

% enter File/Open manu by ^o
h.SendKeys('^o');
pause(1)

% enter the WSI file name
h.SendKeys(wsi_filename);
pause(1)

% open the file by alt-o
h.SendKeys('%o');
pause(2)

% need to check error here ...

% go back to the initial directory
cd(dir_init)

%


% % need to move cursor to center
% for i = 1:10
% h.SendKeys('%!');
% pause(1)
% end

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

% do something

% capture the screenshot
fn = 'C:\Users\wcc\Desktop\mytest.png'
screenshot(fn)
pause(5)

% exit ASAP by closing the window alt-F4
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

function windowshot (fullpathname)

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




