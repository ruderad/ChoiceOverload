function EyeTracker = startEyeTrackingRecording(EyeTracker)

% startEyeTrackingRecording
%
% Start EyeLink recording.


if ~EyeTracker.calibrated

    warning( ...
        'Starting EyeLink without calibration.');

end


status = Eyelink('StartRecording');


if status ~= 0

    error( ...
        'EyeLink failed to start recording (status %d).', ...
        status);

end


WaitSecs(0.05);


Eyelink('Message','SYNCTIME');


EyeTracker.recording = true;


end