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

T.Acquisition.EyeTracker.active = false;


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
% EEG
% ==============================================================

if T.Acquisition.EEG.requested


    T.Acquisition.EEG = initializeEEG(P);


end


%% ==============================================================
% Eye Tracker
% ==============================================================

if T.Acquisition.EyeTracker.requested

    error( ...
        ['Eye-tracker acquisition is enabled, but the ' ...
         'hardware integration has not been implemented yet.']);

end


%% ==============================================================
% Event Logger
% ==============================================================

T = startEventLogger( ...
    P, ...
    T, ...
    Subject);


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