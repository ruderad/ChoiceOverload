function sendEvent( ...
    P, T, taskName, eventName, eventCode)


taskName = char(string(taskName));

eventName = char(string(eventName));


%% ==============================================================
% Event Logger
% ==============================================================

if isfield(T,'Acquisition') && ...
        isfield(T.Acquisition,'EventLog') && ...
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
% Acquisition Available
% ==============================================================

if ~isfield(T,'Acquisition') || ...
        ~T.Acquisition.enabled

    return;

end


%% ==============================================================
% Resolve Backend Availability
% ==============================================================

hasEEG = ...
    isfield(P.Acquisition,'EEG') && ...
    isfield(P.Acquisition.EEG,taskName);


hasEyeTracker = ...
    isfield(P.Acquisition,'EyeTracker') && ...
    isfield(P.Acquisition.EyeTracker,taskName);


%% ==============================================================
% EEG
% ==============================================================

useEEG = ...
    hasEEG && ...
    T.Acquisition.EEG.active && ...
    P.Acquisition.EEG.(taskName);


if useEEG

    try

        sendEEGEvent(eventCode);

    catch ME

        warning( ...
            'EEG event failed: %s', ...
            ME.message);

    end

end


%% ==============================================================
% Eye Tracker
% ==============================================================

useEyeTracker = ...
    hasEyeTracker && ...
    T.Acquisition.EyeTracker.active && ...
    P.Acquisition.EyeTracker.(taskName);


if useEyeTracker

    try

        sendEyeTrackerEvent(eventName);

    catch ME

        warning( ...
            'Eye tracker event failed: %s', ...
            ME.message);

    end

end


end