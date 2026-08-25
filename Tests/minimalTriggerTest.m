%% testEEGTrigger
%
% Minimal EEG trigger hardware test.
%
% Tests:
%
%   - serial connection
%   - trigger transmission
%   - trigger range validation
%
% Does NOT require:
%
%   - behavioral task
%   - initializeParameters
%   - event system
%   - eye tracker


clear;
clc;


%% ==============================================================
% Reset MATLAB serial state
% ==============================================================

instrreset;


%% ==============================================================
% EEG configuration
% ==============================================================

EEG.port = '/dev/ttyUSB0';

EEG.BaudRate = 57600;

EEG.DataBits = 8;


%% ==============================================================
% Open serial connection
% ==============================================================

disp('Opening EEG trigger port...');


EEG.serial = serial( ...
    EEG.port, ...
    'BaudRate', EEG.BaudRate, ...
    'DataBits', EEG.DataBits);


fopen(EEG.serial);


disp('EEG trigger port opened');


%% ==============================================================
% Initialize idle state
% ==============================================================

fwrite( ...
    EEG.serial, ...
    0);


disp('Trigger interface initialized');


%% ==============================================================
% Send test triggers
% ==============================================================

testCodes = [10 20 30];


for i = 1:length(testCodes)


    code = testCodes(i);


    fprintf( ...
        'Sending trigger %d\n', ...
        code);


    fwrite( ...
        EEG.serial, ...
        code);


    WaitSecs(1);


end


disp('All triggers sent');


%% ==============================================================
% Cleanup
% ==============================================================

fclose(EEG.serial);

delete(EEG.serial);

clear EEG.serial;


disp('EEG trigger port closed');