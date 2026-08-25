function EyeTracker = calibrateEyeTracker(EyeTracker)

% calibrateEyeTracker
%
% Run EyeLink calibration procedure.


if ~EyeTracker.connected

    error( ...
        'EyeLink is not initialized.');

end


EyelinkDoTrackerSetup( ...
    EyeTracker.el);


EyeTracker.calibrated = true;


end