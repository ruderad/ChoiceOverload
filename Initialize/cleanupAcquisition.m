function T = cleanupAcquisition(P, T)

% cleanupAcquisition
%
% Safely shut down acquisition infrastructure.


if nargin < 2 || isempty(T)

    return;

end


if ~isfield(T,'Acquisition')

    return;

end


%% ==============================================================
% Event Logger
% ==============================================================

if isfield(T.Acquisition,'EventLog') && ...
        T.Acquisition.EventLog.active

    eventLogger("close");

    T.Acquisition.EventLog.active = false;

end


%% ==============================================================
% Debug Mode
% ==============================================================

if P.Debug.enabled

    return;

end


%% ==============================================================
% Eye Tracker
% ==============================================================

if isfield(T.Acquisition,'EyeTracker') && ...
        T.Acquisition.EyeTracker.active


    % Future cleanup here


    T.Acquisition.EyeTracker.active = false;

end


%% ==============================================================
% EEG
% ==============================================================

if isfield(T.Acquisition,'EEG') && ...
        T.Acquisition.EEG.active


    % Future cleanup here


    T.Acquisition.EEG.active = false;

end


end