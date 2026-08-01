%% ==============================================================
%  Choice Overload Experiment
%  ==============================================================

clear;
clc;
close all;

%% ==============================================================
%  Experiment Root
%  ==============================================================

root = fileparts(mfilename('fullpath'));
addpath(genpath(root));

%% ==============================================================
%  Initialization
%  ==============================================================

P = initializeParameters(root);
R = initializeResults(P);

%% ==============================================================
%  Run Experiment
%  ==============================================================

try

    T = initializeTask(P);

    % Task 1: Preference Rating
    R = taskPreferenceRating(R, P, T);

    cleanupTask();

catch ME

    cleanupTask();
    rethrow(ME);

end