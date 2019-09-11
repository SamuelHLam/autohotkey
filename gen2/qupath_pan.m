global root
root = cd;
delete(strcat(root, "\..\matlab_scripts\qupath.png"));

% use ActiveX
global server
server = actxserver('WScript.Shell');

server.Run("autohotkey.exe viewer_interface.ahk");

qupathsetup;
server.SendKeys('%+t');
pause(10);
server.SendKeys('%+c');
snip("\qupath.png");

cd('..\matlab_scripts');
[t_matrix, reg_accuracy] = gen2_reg('qupath','target')

cd(root);
!quit QuPath.exe
server.SendKeys('{ESC}');

function qupathsetup
global root
global server

% open QuPath
cd('C:\Program Files\QuPath');
server.Run('QuPath.exe');
pause(2)

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
server.SendKeys('+{TAB 4} +{TAB} +{TAB} ');
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
server.SendKeys(strcat(root, '\..\matlab_scripts'));
server.SendKeys(name);
server.SendKeys('~');
pause(1)

% exit snipping tool
server.SendKeys('%fx');
end