function cleanupTask(T)

%% ==============================================================
%  Audio (PsychPortAudio)
%  ==============================================================

if isfield(T, 'audio') && isfield(T.audio, 'enabled') && T.audio.enabled
    try
        PsychPortAudio('Stop',  T.audio.handle);
        PsychPortAudio('Close', T.audio.handle);
    catch ME
        warning('cleanupTask:audioCloseFailed', ...
            'Failed to close audio device cleanly (%s).', ME.message);
    end
end

%% ==============================================================
%  Screen / Keyboard / Cursor
%  ==============================================================

ShowCursor;
ListenChar(0);
sca;

end