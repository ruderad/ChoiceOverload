function EEG = initializeEEG(P)

% initializeEEG
%
% Initialize serial EEG trigger interface.
%
% Hardware:
%
%   Serial USB trigger
%
% Configuration:
%
%   BaudRate: 57600
%   DataBits: 8


%% --------------------------------------------------------------
% Reset MATLAB serial state
% ---------------------------------------------------------------

instrreset;


%% --------------------------------------------------------------
% Create serial object
% ---------------------------------------------------------------

EEG.serial = serial( ...
    P.Acquisition.EEG.port, ...
    'BaudRate',P.acquisition.EEG.BaudRate, ...
    'DataBits',P.Acquisition.EEG.DataBits);


%% --------------------------------------------------------------
% Open port
% ---------------------------------------------------------------

fopen(EEG.serial);


%% --------------------------------------------------------------
% Set idle state
% ---------------------------------------------------------------

fwrite( ...
    EEG.serial, ...
    0);


%% --------------------------------------------------------------
% State
% ---------------------------------------------------------------

EEG.active = true;


end