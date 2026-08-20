function cleanupAcquisition(P, T)

% cleanupAcquisition
%
% Safely shut down external acquisition hardware.
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
% Debug Mode
% ==============================================================

if P.Debug.enabled

    return;

end


%% ==============================================================
% Acquisition Initialized?
% ==============================================================

if ~isfield(T, 'Acquisition')

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