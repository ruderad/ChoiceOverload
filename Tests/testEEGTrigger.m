clear;
clc;

instrreset;


%% Load parameters

initializeParameters;


%% Minimal state

T = struct();


Subject.id = "TEST";


%% Enable EEG only

P.Debug.enabled = false;

P.Acquisition.EEG.enabled = true;

P.Acquisition.EventLog.enabled = true;


%% Initialize acquisition

T = initializeAcquisition( ...
    P, ...
    T, ...
    Subject);


disp("EEG initialized");


%% Send test markers

sendEvent( ...
    P,...
    T,...
    "Test",...
    "TEST_MARKER_10",...
    10);


WaitSecs(1);


sendEvent( ...
    P,...
    T,...
    "Test",...
    "TEST_MARKER_20",...
    20);


WaitSecs(1);


sendEvent( ...
    P,...
    T,...
    "Test",...
    "TEST_MARKER_30",...
    30);


disp("Markers sent");


%% Cleanup

T = cleanupAcquisition(P,T);


disp("EEG closed");