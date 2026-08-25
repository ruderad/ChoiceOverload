function EyeTracker = startEyeTrackingRecording(EyeTracker)

% startEyeTrackingRecording
%
% Start EyeLink recording.


if ~EyeTracker.calibrated

    warning( ...
        'Starting EyeLink without calibration.');

end


Eyelink('StartRecording');


WaitSecs(0.05);


Eyelink('Message','SYNCTIME');


EyeTracker.recording = true;


end