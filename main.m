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

    % Prepare choice sets
    rating = R.Preference.average;

    rating = R.Preference.average;

    ChoiceSets = cell(1, numel(P.Choice.setSizes));

    for i = 1:numel(P.Choice.setSizes)

        ChoiceSets{i} = makeChoiceSets( ...
            rating, ...
            P.Choice.setSizes(i));

    end

    % Task 2: Choice
    R = taskChoice(R, P, T, ChoiceSets);

    cleanupTask();

    % Save results
    saveResults(R, root);

catch ME

    cleanupTask();
    rethrow(ME);

end