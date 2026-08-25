function EyeTracker = cleanupEyeTracker(EyeTracker,P)


% cleanupEyeTracker


if isempty(EyeTracker)

    return;

end



%% ==============================================================
% Stop recording
% ==============================================================

if EyeTracker.recording

    Eyelink('SetOfflineMode');

    WaitSecs(0.5);

    Eyelink('StopRecording');

end



%% ==============================================================
% Close EDF
% ==============================================================

if isfield(EyeTracker,'edfFile')

    Eyelink('CloseFile');


    try

        Eyelink('ReceiveFile', ...
            EyeTracker.edfFile, ...
            P.Results.path, ...
            1);

    catch ME

        warning( ...
            'EDF transfer failed: %s', ...
            ME.message);

    end

end



%% ==============================================================
% Shutdown
% ==============================================================

Eyelink('Shutdown');


EyeTracker.connected = false;

EyeTracker.recording = false;


end