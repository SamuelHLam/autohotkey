function actxserver_test
    ahk_path = "ahk_scripts\pan_zoom.ahk"

    % use ActiveX
    h = actxserver('WScript.Shell');                      % ActiveX

    % run script
    h.Run(strcat("autohotkey.exe ", ahk_path));
    pause(3)
    
    % test panning and zooming
    h.SendKeys('%+1');
    pause(1)
    h.SendKeys('%+2');
    pause(1)
    h.SendKeys('%+3');
    pause(1)
    h.SendKeys('%+4');
    pause(1)
    h.SendKeys('%+5');
    pause(1)
    h.SendKeys('%+6');
    pause(1)
    

%     % send hotkey
%     h.SendKeys('^k');
%     
%     pause(40)
%     
%     cd matlab_scripts
%     
%     timeout = 0;
%     while isfile("sedeen.png") == 0
%         pause(1)
%         timeout = timeout + 1;
%         if timeout == 1000
%             disp('script did not run in allowed time');
%             break
%         end
%     end
%     
%     auto_reg
end

