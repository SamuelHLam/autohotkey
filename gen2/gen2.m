global root
root = cd;
%delete(strcat(root, "\ndpview2.png"))
delete(strcat(root, "\sedeen.png"))
delete(strcat(root, "\qupath.png"))

% use ActiveX
global server
server = actxserver('WScript.Shell');

server.Run("autohotkey.exe viewer_interface.ahk");

%ndp;
sedeen;
qupath;
server.SendKeys('{ESC}');


function ndp
global root
global server

% NDP is opened by default
!CMU-1.ndpi

% focus on the window
server.AppActivate('NDP.view 2');
!click 100 100
pause(1)

server.SendKeys('5');
pause(1)
server.SendKeys('m');
pause(1)

% call AHK to move FOV
server.SendKeys('%+n');
pause(35)

% closes slide map
server.SendKeys('m');

snip("\ndp.png");

!quit NDPView2.exe
end

function qupath
global root
global server

% open QuPath
cd('C:\Program Files\QuPath');
server.Run('QuPath.exe');
pause(5)

% focus on the window
server.AppActivate('QuPath (0.1.2)');

% maximize window
server.SendKeys('% x');

% return to root directory
cd(root);

% open file
server.SendKeys('^o');
pause(1)

server.SendKeys(strcat(root, '\CMU-1.ndpi'));
pause(1)

server.SendKeys('%+o');
pause(3)

% remove side bar
server.SendKeys('+a');
pause(2)

% call AHK to open magnification menu
!click 430 60
!click 430 60
pause(1)

% set magnification
server.SendKeys('+{TAB}20~');
pause(2)

% call AHK to move FOV
server.SendKeys('%+q');
pause(12)

% close menu items
server.SendKeys('+{TAB}+{TAB}+{TAB}+{TAB} +{TAB} +{TAB} ');

snip("\qupath.png");

!quit QuPath.exe
end

function sedeen
global root
global server

% open QuPath
cd('C:\Program Files\Sedeen Viewer');
server.Run('sedeen.exe');
pause(5)

% focus on the window
server.AppActivate('Sedeen Viewer');

% return to root directory
cd(root);

% open file
server.SendKeys('^o');
pause(1)

server.SendKeys(strcat(root, '\CMU-1.ndpi'));
pause(1)

server.SendKeys('%+o');
pause(5)

% removes tabs and opens zoom bar
server.SendKeys('%vl{DOWN}~%vt{DOWN}~');
pause(1)

% call AHK to click button to zoom to 20x
%command = 'click.exe 30 250';
%system(command);
!click 30 250
pause(1)

% closes zoom bar and opens slide map
server.SendKeys('%vt{DOWN}~%vt~');
pause(1)

% call AHK to move FOV
server.SendKeys('%+s');
pause(27)

% closes slide map
server.SendKeys('%vt~');

snip("\sedeen.png");

!quit sedeen.exe
end

function snip(name)
global root
global server

% start snipping tool
server.Run('SnippingTool');

% focus on the window
server.AppActivate('Snipping Tool');
pause(1)

% full screen snip
server.SendKeys('%n{UP}~^s');
pause(2)
server.SendKeys(root);
server.SendKeys(name);
server.SendKeys('~');
pause(1)

% exit snipping tool
server.SendKeys('%fx');
end
