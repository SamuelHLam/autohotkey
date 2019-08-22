function gen2

root = cd
delete(strcat(root, "\qupath.png"))

% use ActiveX
server = actxserver('WScript.Shell');

server.Run("autohotkey.exe viewer_interface.ahk");

qupath(server);
end


function qupath(server)
root = cd;
cd('C:\Program Files\QuPath');
20

% open QuPath
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

server.SendKeys('C:\Users\wcc\Documents\GitHub\autohotkey\gen2\CMU-1.ndpi');
pause(1)

server.SendKeys('%+o');
pause(5)

% remove side bar
server.SendKeys('+a');
pause(2)

% call AHK to open magnification menu
command = 'click.exe 430 60';
system(command);
system(command);
pause(1)

% set magnification
server.SendKeys('+{TAB}20~');
pause(2)

% call AHK to move FOV
server.SendKeys('%+q');
pause(15)

snip(server, strcat(root, "\qupath.png"));

command = 'exit.exe QuPath.exe';
system(command);
server.SendKeys('{ESC}');
end

function snip(server, save_path)
% start SnippingTool
server.Run('SnippingTool');

% focus on the window
server.AppActivate('Snipping Tool');
pause(1)

server.SendKeys('%n{UP}~^s');
pause(2)
server.SendKeys(save_path);
pause(1)
server.SendKeys('~');
pause(1)
server.SendKeys('%fx');
end
