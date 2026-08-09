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
% Collect Subject Info
% ==============================================================

[R.Subject, aborted] = collectSubjectInfo();

if aborted
    return;
end

%% ==============================================================
% Run Experiment
% ==============================================================

try

    T = initializeTask(P);

    % Task 1: Preference Rating
    R = taskPreferenceRating(R, P, T);

    cleanupTask();

    % Save results
    saveResults(R, root);

catch ME

    cleanupTask();
    rethrow(ME);

end