global root
root = cd;
global wsi_path
wsi_path = 'C:\Users\Qi Gong\Documents\GitHub\autohotkey\gen2\CMU-1.ndpi';

% if isfile(strcat(root, "\..\matlab_scripts\asap.png"))
%     delete(strcat(root, "\..\matlab_scripts\asap.png"))
% end
% 
% if isfile(strcat(root, "\..\matlab_scripts\ndp.png"))
%     delete(strcat(root, "\..\matlab_scripts\ndp.png"))
% end
% 
% if isfile(strcat(root, "\..\matlab_scripts\qupath.png"))
%     delete(strcat(root, "\..\matlab_scripts\qupath.png"))
% end

if isfile(strcat(root, "\..\matlab_scripts\sedeen.png"))
    delete(strcat(root, "\..\matlab_scripts\sedeen.png"))
end

% inverts target image
target = imread(strcat(root, "\..\matlab_scripts\target.png"));
invert = imcomplement(target);
imwrite(invert, strcat(root, "\target.png"));

% use ActiveX
global server
server = actxserver('WScript.Shell');

server.Run("autohotkey.exe viewer_interface.ahk");

% asapsetup;
% snip_reg('asap');
% !quit ASAP.exe
% 
% ndpsetup;
% snip_reg('ndp');
% !quit NDPView2.exe
% 
% qupathsetup;
% snip_reg('qupath');
% !quit QuPath.exe

sedeensetup;
snip_reg('sedeen');
!quit sedeen.exe



server.SendKeys('{ESC}');

function asapsetup
global root
global wsi_path
global server

% open ASAP
cd('C:\Program Files\ASAP 1.9\bin');
server.Run('ASAP.exe');
pause(5)

% focus on the window
server.AppActivate('ASAP');

% return to root directory
cd(root);

% open file
server.SendKeys('^o');
pause(1)

server.SendKeys(wsi_path);
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

% zoom in
!click 125 60
server.SendKeys('%+4');
server.SendKeys('%+4');
!click 95 60

% remove toolbar
!click r 120 30
server.SendKeys('{UP}~');
pause(1)

% open slide map
server.SendKeys('%');
server.SendKeys('{RIGHT}{UP 3}~');

% call AHK to move FOV
server.SendKeys('%+a');
pause(20)

% close slide map
server.SendKeys('%');
server.SendKeys('{RIGHT}{UP 3}~');
end

function ndpsetup
global wsi_path
global server

% NDP is opened by default
% !CMU-1.ndpi
cmd = strcat('open_ndp "', wsi_path,'"')
system(cmd);
pause(5)

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
end

function qupathsetup
global root
global wsi_path
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

server.SendKeys(wsi_path);
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

function sedeensetup
global root
global wsi_path
global server

% open Sedeen
cd('C:\Program Files\Sedeen Viewer');
server.Run('sedeen.exe');
pause(5)

% focus on the window
server.AppActivate('Sedeen Viewer - CMU-1.ndpi');

% return to root directory
cd(root);

% open file
server.SendKeys('^o');
pause(1)

server.SendKeys(wsi_path);
pause(1)

server.SendKeys('%+o');
pause(5)

% removes tabs and opens zoom bar
server.SendKeys('%vl{DOWN}~');
pause(1)
server.SendKeys('%vt{DOWN}~');
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
end

function snip_reg(name)
global root
global server

server.SendKeys('%+t');
pause;
snip(strcat('\', name, '.png'));

cd('..\matlab_scripts');
[t_matrix, reg_accuracy] = gen2_reg(name,'target')

cd(root);
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
server.SendKeys(strcat(root, '\..\matlab_scripts'));
server.SendKeys(name);
server.SendKeys('~');
pause(1)

% exit snipping tool
server.SendKeys('%fx');
end