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

T = [];


try

    %% Psychtoolbox

    T = initializeTask(P);


    %% Acquisition

    T = initializeAcquisition( ...
        P, ...
        T, ...
        R.Subject);


    %% Task 1: Preference Rating

    R = taskPreferenceRating( ...
        R, ...
        P, ...
        T);


    %% Prepare Choice Sets

    rating = R.Preference.average;


    ChoiceSets = cell( ...
        1, ...
        numel(P.Choice.setSizes));


    for i = 1:numel(P.Choice.setSizes)

        ChoiceSets{i} = makeChoiceSets( ...
            rating, ...
            P.Choice.setSizes(i), ...
            P.Choice.RatingRanges, ...
            P.Choice.TrialCounts);

    end


    %% Task 2: Choice

    R = taskChoice( ...
        R, ...
        P, ...
        T, ...
        ChoiceSets);


    %% Cleanup Acquisition

    cleanupAcquisition(P, T);


    %% Cleanup Psychtoolbox

    cleanupTask();


    %% Save Results

    saveResults( ...
        R, ...
        root);


catch ME

    %% Emergency Cleanup

    cleanupAcquisition( ...
        P, ...
        T);


    cleanupTask();


    rethrow(ME);

end