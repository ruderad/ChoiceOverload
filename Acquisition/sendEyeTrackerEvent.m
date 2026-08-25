function sendEyeTrackerEvent(EyeTracker,eventName)

% sendEyeTrackerEvent
%
% Send event message to EDF file.


if ~EyeTracker.recording

    return;

end


Eyelink('Message',char(eventName));


end