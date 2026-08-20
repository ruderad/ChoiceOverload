function sendEvent( ...
    P, T, taskName, eventName, eventCode)

% sendEvent
%
% Route one experimental event to:
%
%   development event logger
%   EEG
%   eye tracker
%
%
% The event logger is independent of Debug mode.
%
% Hardware transmission remains completely bypassed when:
%
%   P.Debug.enabled = true
%
%
% Inputs:
%
%   taskName
%
%       "PreferenceRating"
%       "Choice"
%
%
%   eventName
%
%       Descriptive event label.
%
%
%   eventCode
%
%       Numeric EEG trigger code.


%% ==============================================================
% Normalize Event
% ==============================================================

taskName = ...
    char(string(taskName));


eventName = ...
    char(string(eventName));


%% ==============================================================
% Development Event Logger
% ==============================================================

% Log BEFORE the Debug return.
%
% This allows a complete event sequence to be captured while all
% external acquisition hardware remains bypassed.

if isfield(T, 'Acquisition') && ...
        isfield(T.Acquisition, 'EventLog') && ...
        T.Acquisition.EventLog.active

    eventLogger( ...
        "write", ...
        taskName, ...
        eventName, ...
        eventCode);

end


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