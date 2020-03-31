% generate 3-note chord
% 3-26-2020
% WCC and Trinity

function chord_gen (chordname, duration)

sample_rate = 8192;

% parse the chordname to get the base pitch
switch chordname
    case {'C','c'}
        i_pitch = 1;
    case {'D','d'}
        i_pitch = 3;
    case {'E','e'}
        i_pitch = 5;
    case {'F','f'}
        i_pitch = 6;
    case {'G','g'}
        i_pitch = 8;
    case {'A','a'}
        i_pitch = 10;
    case {'B','b'}
        i_pitch = 12;
end

% decide if it is a major or minor chord
switch chordname
    case {'C','D','E','F','G','A','B'}
        i_pitch3 = i_pitch+4;
    case {'c','d','e','f','g','a','n'}
        i_pitch3 = i_pitch+3;
end

% create the pitch table; make it longer than one octave
tab = zeros(24,1);
magicnumber = 0.5 .^ (1/12);
c = 440 * (magicnumber .^ 10);
for i = 1:24
    tab(i,1) = c / (magicnumber .^ i);
end

% the 3 pitches
fr1 = tab(i_pitch,1);
fr3 = tab(i_pitch3,1);
fr5 = tab(i_pitch+7,1);

% lower one octave for some chords -- not complete
switch chordname
    case {'A','B','a','b','G','g','F'}
        fr1 = fr1 / 2;
        fr3 = fr3 / 2;
        fr5 = fr5 / 2;
end

% three waveforms
wav1 = mypitch(fr1,duration,sample_rate);
wav3 = mypitch(fr3,duration,sample_rate);
wav5 = mypitch(fr5,duration,sample_rate);

% combine three waveforms
wav = (wav1+wav3+wav5)/3;

% generate sound
sound(wav,sample_rate)

% synchronize 
pause(duration)

return

    function y = mypitch (freq,duration,sample_rate)
        % freq = 220;
        % duration = 2;
        t = 0:1/sample_rate:duration;
        y = sin(2*pi*t*freq);
        % plot(t,y,'-')
    end

end
