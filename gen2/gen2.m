global root
root = cd;
if isfile(strcat(root, "\ndp.png"))
    delete(strcat(root, "\ndp.png"))
end

% inverts target image
target = imread(strcat(root, "\target.png"));
invert = imcomplement(target);
imwrite(invert, strcat(root, "\..\gen2\target.png"));

% use ActiveX
global server
server = actxserver('WScript.Shell');

server.Run("autohotkey.exe viewer_interface.ahk");

ndp;

% cd('..\matlab_scripts');
% [t_matrix, reg_accuracy] = gen2_reg(qupath, target);
cd(root);

server.SendKeys('{ESC}');

function asap
global root
global server

% open QuPath
cd('C:\Program Files\ASAP 1.9\bin');
server.Run('ASAP.exe');
pause(2)

% focus on the window
server.AppActivate('ASAP');

% return to root directory
cd(root);

% open file
server.SendKeys('^o');
pause(1)

server.SendKeys(strcat(root, '\CMU-1.ndpi'));
pause(1)

server.SendKeys('%+o');
pause(2)

% remove all sidebars
server.SendKeys('%');
server.SendKeys('{RIGHT}{UP 2}{RIGHT}~');
server.SendKeys('%');
server.SendKeys('{RIGHT}{UP 2}{RIGHT}{DOWN}~');
server.SendKeys('%');
server.SendKeys('{RIGHT}{UP 2}{RIGHT}{DOWN 2}~');
pause(1)

% remove toolbar
!click r 120 30
server.SendKeys('{UP}~');
pause(1)

%%%
% zoom in somehow
%%%

% open slide map
server.SendKeys('%');
server.SendKeys('{RIGHT}{UP 3}~');

% call AHK to move FOV
server.SendKeys('%+a');
pause(20)

% close slide map
server.SendKeys('%');
server.SendKeys('{RIGHT}{UP 3}~');

snip("\asap.png");

!quit ASAP.exe
end

function ndp
global root
global server

% NDP is opened by default
!CMU-1.ndpi
pause(2)

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

snip("\qupath.png");

!quit QuPath.exe
end

function sedeen
global root
global server

% open QuPath
cd('C:\Program Files\Sedeen Viewer');
server.Run('sedeen.exe');
pause(2)

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
pause(2)

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
