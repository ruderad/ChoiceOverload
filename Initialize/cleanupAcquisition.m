function cleanupAcquisition(P, T)

% cleanupAcquisition
%
% Safely shut down acquisition infrastructure.
%
% Safe to call:
%
%   in debug mode
%   before acquisition initializes
%   after partial initialization
%   from the experiment error handler


%% ==============================================================
% Nothing to Clean
% ==============================================================

if nargin < 2 || ...
        isempty(T)

    return;

end


%% ==============================================================
% Acquisition Initialized?
% ==============================================================

if ~isfield(T, 'Acquisition')

    return;

end


%% ==============================================================
% Event Logger
% ==============================================================

% The logger may be active even when Debug mode is enabled,
% therefore it must be cleaned before the Debug return.

if isfield(T.Acquisition, 'EventLog') && ...
        T.Acquisition.EventLog.active

    eventLogger( ...
        "close");

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

if isfield(T.Acquisition, 'EyeTracker') && ...
        T.Acquisition.EyeTracker.active

    % ----------------------------------------------------------
    % Future cleanup:
    %
    %   stop recording
    %   close file
    %   transfer data
    %   disconnect
    % ----------------------------------------------------------

end


%% ==============================================================
% EEG
% ==============================================================

if isfield(T.Acquisition, 'EEG') && ...
        T.Acquisition.EEG.active

    % ----------------------------------------------------------
    % Future cleanup:
    %
    %   stop/reset trigger interface
    %   disconnect
    % ----------------------------------------------------------

end


end