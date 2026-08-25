function T = cleanupAcquisition(P, T)

% cleanupAcquisition
%
% Safely shut down acquisition infrastructure.
%
% Components:
%
%   Event Logger
%   Eye Tracker
%   EEG


if nargin < 2 || isempty(T)

    return;

end


if ~isfield(T,'Acquisition')

    return;

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
        isstruct(T.Acquisition.EyeTracker) && ...
        isfield(T.Acquisition.EyeTracker,'connected') && ...
        T.Acquisition.EyeTracker.connected


    T.Acquisition.EyeTracker = ...
        cleanupEyeTracker( ...
            T.Acquisition.EyeTracker, ...
            P);


end



%% ==============================================================
% EEG
% ==============================================================

if isfield(T.Acquisition,'EEG') && ...
        isstruct(T.Acquisition.EEG) && ...
        isfield(T.Acquisition.EEG,'active') && ...
        T.Acquisition.EEG.active


    fclose(T.Acquisition.EEG.serial);

    delete(T.Acquisition.EEG.serial);


    T.Acquisition.EEG.active = false;


end



%% ==============================================================
% Event Logger
% ==============================================================

if isfield(T.Acquisition,'EventLog') && ...
        T.Acquisition.EventLog.active

    eventLogger("close");

    T.Acquisition.EventLog.active = false;

end


end