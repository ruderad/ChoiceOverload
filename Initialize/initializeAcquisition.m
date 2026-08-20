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
%
%
% The event logger is intentionally independent of Debug mode so
% marker sequences can be validated without hardware.


%% ==============================================================
% Acquisition State
% ==============================================================

% Hardware acquisition state.

T.Acquisition.enabled = ...
    ~P.Debug.enabled;


%% ==============================================================
% Event Logger
% ==============================================================

T.Acquisition.EventLog.requested = ...
    P.Acquisition.EventLog.enabled;


T.Acquisition.EventLog.active = ...
    false;


T.Acquisition.EventLog.filepath = ...
    '';


%% ==============================================================
% EEG
% ==============================================================

T.Acquisition.EEG.requested = ...
    P.Acquisition.EEG.enabled;


T.Acquisition.EEG.active = ...
    false;


%% ==============================================================
% Eye Tracker
% ==============================================================

T.Acquisition.EyeTracker.requested = ...
    P.Acquisition.EyeTracker.enabled;


T.Acquisition.EyeTracker.active = ...
    false;


%% ==============================================================
% Debug Mode
% ==============================================================

if P.Debug.enabled


    % Hardware is bypassed, but the mock/event logger may still
    % operate so the complete event sequence can be inspected.

    T = startEventLogger( ...
        P, ...
        T, ...
        Subject);


    return;

end


%% ==============================================================
% EEG
% ==============================================================

if P.Acquisition.EEG.enabled

    % ----------------------------------------------------------
    % Future EEG initialization:
    %
    %   connect to trigger interface
    %   validate connection
    %   prepare recording / trigger system
    %
    % After successful initialization:
    %
    %   T.Acquisition.EEG.active = true;
    % ----------------------------------------------------------

    error( ...
        ['EEG acquisition is enabled, but the EEG hardware ' ...
         'integration has not been implemented yet.']);

end


%% ==============================================================
% Eye Tracker
% ==============================================================

if P.Acquisition.EyeTracker.enabled

    % ----------------------------------------------------------
    % Future eye-tracker initialization:
    %
    %   connect
    %   create recording
    %   calibration
    %   validation
    %
    % After successful initialization:
    %
    %   T.Acquisition.EyeTracker.active = true;
    % ----------------------------------------------------------

    error( ...
        ['Eye-tracker acquisition is enabled, but the ' ...
         'hardware integration has not been implemented yet.']);

end


%% ==============================================================
% Event Logger
% ==============================================================

% In real acquisition mode, start the event logger only after
% hardware initialization has completed successfully.
%
% This avoids leaving an open log resource after a partial
% hardware-initialization failure.

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


T.Acquisition.EventLog.filepath = ...
    filePath;


T.Acquisition.EventLog.active = ...
    true;


end