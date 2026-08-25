function T = initializeAcquisition(P, T, Subject)

% initializeAcquisition
%
% Initialize acquisition infrastructure.
%
% Components:
%
%   Event Logger
%   EEG
%   Eye Tracker
%
%
% Debug mode:
%
%   Event Logger -> may remain active
%   EEG          -> bypassed
%   Eye Tracker  -> bypassed


%% ==============================================================
% Acquisition State
% ==============================================================

T.Acquisition.enabled = ...
    ~P.Debug.enabled;


%% ==============================================================
% Event Logger
% ==============================================================

T.Acquisition.EventLog.requested = ...
    P.Acquisition.EventLog.enabled;

T.Acquisition.EventLog.active = false;

T.Acquisition.EventLog.filepath = '';


%% ==============================================================
% EEG
% ==============================================================

T.Acquisition.EEG.requested = ...
    P.Acquisition.EEG.enabled;

T.Acquisition.EEG.active = false;


%% ==============================================================
% Eye Tracker
% ==============================================================

T.Acquisition.EyeTracker.requested = ...
    P.Acquisition.EyeTracker.enabled;

T.Acquisition.EyeTracker.connected = false;
T.Acquisition.EyeTracker.calibrated = false;
T.Acquisition.EyeTracker.recording = false;


%% ==============================================================
% Debug Mode
% ==============================================================

if P.Debug.enabled


    if T.Acquisition.EEG.requested || ...
            T.Acquisition.EyeTracker.requested

        warning( ...
            ['Debug mode enabled. Hardware acquisition is ' ...
             'requested but bypassed.']);

    end


    T = startEventLogger( ...
        P, ...
        T, ...
        Subject);


    return;

end


%% ==============================================================
% Hardware and Logger Initialization
% ==============================================================

try

    if T.Acquisition.EEG.requested

        T.Acquisition.EEG = initializeEEG(P);
        T.Acquisition.EEG.requested = true;

    end


    if T.Acquisition.EyeTracker.requested

        T.Acquisition.EyeTracker = ...
            initializeEyeTracker( ...
                P, ...
                T, ...
                Subject);

        T.Acquisition.EyeTracker.requested = true;

    end


    T = startEventLogger( ...
        P, ...
        T, ...
        Subject);

catch ME

    % Roll back hardware that was opened before a later backend failed.
    T = cleanupAcquisition(P, T);

    rethrow(ME);

end

end


%% ==============================================================
% Start Event Logger
% ==============================================================

function T = startEventLogger(P, T, Subject)


if ~T.Acquisition.EventLog.requested

    return;

end


filePath = eventLogger( ...
    "initialize", ...
    P, ...
    Subject);


T.Acquisition.EventLog.filepath = filePath;

T.Acquisition.EventLog.active = true;


end