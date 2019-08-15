function actxserver_test
    ahk_path = "ahk_scripts\v6.ahk"

    % use ActiveX
    h = actxserver('WScript.Shell');                      % ActiveX

    % run script
    h.Run(strcat("autohotkey.exe ", ahk_path));
    pause(3)

    % send hotkey
    h.SendKeys('^k');
    
    pause(40)
    
    cd matlab_scripts
    
    timeout = 0;
    while isfile("sedeen.png") == 0
        pause(1)
        timeout = timeout + 1;
        if timeout == 1000
            disp('script did not run in allowed time');
            break
        end
    end
    
    auto_reg
end

