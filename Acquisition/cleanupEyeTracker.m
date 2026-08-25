function EyeTracker = cleanupEyeTracker(EyeTracker,P)


% cleanupEyeTracker


if isempty(EyeTracker)

    return;

end



%% ==============================================================
% Stop recording
% ==============================================================

if isfield(EyeTracker,'recording') && ...
        EyeTracker.recording

    Eyelink('StopRecording');

    EyeTracker.recording = false;

    Eyelink('SetOfflineMode');

    WaitSecs(0.5);

end



%% ==============================================================
% Close EDF
% ==============================================================

if isfield(EyeTracker,'edfFile') && ...
        ~isempty(EyeTracker.edfFile)

    Eyelink('CloseFile');


    if ~isfolder(P.Results.path)

        mkdir(P.Results.path);

    end


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