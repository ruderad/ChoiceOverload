function sendEEGEvent(EEG,eventCode)

% sendEEGEvent
%
% Send one EEG marker.
%
% Trigger protocol:
%
%   single byte serial trigger
%
% Valid range:
%
%   1-63


%% --------------------------------------------------------------
% Validate trigger
% ---------------------------------------------------------------

eventCode = double(eventCode);


if eventCode < 1 || eventCode > 63

    error( ...
        'EEG trigger code must be between 1 and 63.');

end


%% --------------------------------------------------------------
% Send trigger
% ---------------------------------------------------------------
disp(eventCode)

fwrite( ...
    EEG.serial, ...
    eventCode);


end