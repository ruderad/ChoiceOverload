function T = initializeAcquisition(P, T, Subject)

% initializeAcquisition
%
% Initialize external acquisition devices.
%
% This function establishes device-level acquisition state.
% Task-specific routing is handled later by sendEvent.
%
% Debug mode bypasses all hardware initialization.


%% ==============================================================
% Acquisition State
% ==============================================================

T.Acquisition.enabled = ...
    ~P.Debug.enabled;


%% EEG

T.Acquisition.EEG.requested = ...
    P.Acquisition.EEG.enabled;

T.Acquisition.EEG.active = false;


%% Eye Tracker

T.Acquisition.EyeTracker.requested = ...
    P.Acquisition.EyeTracker.enabled;

T.Acquisition.EyeTracker.active = false;


%% ==============================================================
% Debug Mode
% ==============================================================

if P.Debug.enabled

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


end