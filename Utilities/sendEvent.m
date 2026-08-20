function sendEvent( ...
    P, T, taskName, eventName, eventCode)

% sendEvent
%
% Route one experimental event to the appropriate acquisition
% devices.
%
% Inputs:
%
%   taskName
%       Name of the task producing the event:
%
%           "PreferenceRating"
%           "Choice"
%
%   eventName
%       Descriptive event label for systems such as eye tracking.
%
%   eventCode
%       Numeric event code for EEG.
%
% Device routing depends on both:
%
%   device enabled
%   task enabled for that device
%
% Debug mode bypasses all event transmission.


%% ==============================================================
% Debug Mode
% ==============================================================

if P.Debug.enabled

    return;

end


%% ==============================================================
% Acquisition Available?
% ==============================================================

if ~isfield(T, 'Acquisition') || ...
        ~T.Acquisition.enabled

    return;

end


%% ==============================================================
% Resolve Task
% ==============================================================

taskName = char(string(taskName));


if ~isfield(P.Acquisition.EEG, taskName)

    error( ...
        'Unknown acquisition task: %s', ...
        taskName);

end


if ~isfield(P.Acquisition.EyeTracker, taskName)

    error( ...
        'Unknown acquisition task: %s', ...
        taskName);

end


%% ==============================================================
% EEG
% ==============================================================

useEEG = ...
    T.Acquisition.EEG.active && ...
    P.Acquisition.EEG.(taskName);


if useEEG

    % ----------------------------------------------------------
    % Future EEG trigger:
    %
    % eventCode
    % ----------------------------------------------------------

end


%% ==============================================================
% Eye Tracker
% ==============================================================

useEyeTracker = ...
    T.Acquisition.EyeTracker.active && ...
    P.Acquisition.EyeTracker.(taskName);


if useEyeTracker

    % ----------------------------------------------------------
    % Future eye-tracker message:
    %
    % eventName
    % ----------------------------------------------------------

end


end