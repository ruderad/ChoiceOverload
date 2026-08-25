function EyeTracker = initializeEyeTracker(P,T,Subject)

% initializeEyeTracker
%
% Initialize EyeLink connection and configuration.
%
% Does NOT:
%
%   - calibrate
%   - start recording
%
% These are separate steps.


%% ==============================================================
% Initialize state
% ==============================================================

EyeTracker = struct();


EyeTracker.connected = false;

EyeTracker.calibrated = false;

EyeTracker.recording = false;


%% ==============================================================
% Initialize EyeLink defaults
% ==============================================================

el = EyelinkInitDefaults(T.window);


el.backgroundcolour = P.Screen.backgroundColor;


EyelinkUpdateDefaults(el);



%% ==============================================================
% Initialize connection
% ==============================================================

dummyMode = 0;


if ~EyelinkInit(dummyMode,1)

    Eyelink('Shutdown');

    error( ...
        'EyeLink initialization failed.');

end


EyeTracker.connected = true;


%% ==============================================================
% Tracker information
% ==============================================================

[version, trackerVersion] = ...
    Eyelink('GetTrackerVersion');


fprintf( ...
    'Running experiment on a %s tracker.\n', ...
    trackerVersion);



%% ==============================================================
% Screen configuration
% ==============================================================

W = T.windowRect(RectRight);

H = T.windowRect(RectBottom);


Eyelink('Command', ...
    'screen_pixel_coords = %ld %ld %ld %ld', ...
    0, ...
    0, ...
    W-1, ...
    H-1);


Eyelink('Message', ...
    'DISPLAY_COORDS %ld %ld %ld %ld', ...
    0, ...
    0, ...
    W-1, ...
    H-1);



%% ==============================================================
% Calibration configuration
% ==============================================================

Eyelink('Command', ...
    'calibration_type = HV9');


Eyelink('Command', ...
    'saccade_velocity_threshold = 35');


Eyelink('Command', ...
    'saccade_acceleration_threshold = 9500');



%% ==============================================================
% EDF configuration
% ==============================================================

Eyelink('Command', ...
    ['file_event_filter = ' ...
     'LEFT,RIGHT,FIXATION,SACCADE,BLINK,' ...
     'MESSAGE,FIXUPDATE']);


Eyelink('Command', ...
    ['file_sample_data = ' ...
     'LEFT,RIGHT,GAZE,HREF,AREA,' ...
     'GAZERES,STATUS']);


Eyelink('Command', ...
    ['link_event_filter = ' ...
     'LEFT,RIGHT,FIXATION,SACCADE,' ...
     'BLINK,MESSAGE,FIXUPDATE']);


Eyelink('Command', ...
    ['link_sample_data = ' ...
     'LEFT,RIGHT,GAZE,GAZERES,' ...
     'AREA,STATUS']);



%% ==============================================================
% EDF file
% ==============================================================

edfFile = ...
    sprintf('%s_ET.edf', Subject.id);


status = Eyelink('OpenFile',edfFile);


if status ~= 0

    Eyelink('Shutdown');

    error( ...
        'Could not open EDF file.');

end


EyeTracker.edfFile = edfFile;


%% ==============================================================
% Save EyeLink object
% ==============================================================

EyeTracker.el = el;


end