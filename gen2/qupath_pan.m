global root
root = cd;
delete(strcat(root, "\..\matlab_scripts\qupath.png"));

% use ActiveX
global server
server = actxserver('WScript.Shell');

server.Run("autohotkey.exe viewer_interface.ahk");

qupathsetup;
snip("\qupath.png");

cd('..\matlab_scripts');
[t_matrix, reg_accuracy] = gen2_reg('qupath','target')


if reg_accuracy < 0.98
    % determine panning amounts from t_matrix
    pan_x = round(t_matrix(3,1)/100)
    pan_y = round(t_matrix(3,2)/100)
    
    % pan left
    if pan_x > 0
        for i = 1:pan_x
            server.SendKeys('%+1');
            pause(1)
        end
    % pan right    
    else
       for i = 1:abs(pan_x)
            server.SendKeys('%+2');
            pause(1)
        end 
    end
    
    % pan up
    if pan_y < 0
        for i = 1:abs(pan_y)
            server.SendKeys('%+3');
            pause(1)
        end
    % pan right    
    else
       for i = 1:pan_y
            server.SendKeys('%+4');
            pause(1)
        end 
    end
end

%cd(root);
%!quit QuPath.exe
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