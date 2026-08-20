function Report = validateEventLog(P, Log)

% validateEventLog
%
% Validate a parsed Choice Overload event log.
%
% The parser is responsible for reconstruction:
%
%       Log = parseEventLog(filepath)
%
% The validator checks correctness:
%
%       Report = validateEventLog(P, Log)
%
%
% Checks:
%
%   - file integrity
%   - event code validity
%   - Preference Rating structure
%   - Choice trial structure
%
%
% Event definitions are always taken from:
%
%       P.Events


%% ==============================================================
% Initialize Report
% ==============================================================

Report.pass = true;

Report.file = Log.File;

Report.errors = {};

Report.warnings = {};


Report.nEvents = height(Log.Events);

Report.nRatingTrials = 0;

Report.nChoiceTrials = 0;

Report.nQuestionnaires = 0;



%% ==============================================================
% Validate experiment definition
% ==============================================================

if ~isfield(P,'Events')

    Report.pass = false;

    Report.errors{end+1} = ...
        "Experiment event definitions missing.";

    return;

end



%% ==============================================================
% Event Code Validation
% ==============================================================

validateEventCodes( ...
    P, ...
    Log.Events, ...
    Report);



%% ==============================================================
% Preference Rating Validation
% ==============================================================

validateRatingStructure( ...
    P, ...
    Log.Rating, ...
    Report);



%% ==============================================================
% Choice Validation
% ==============================================================

validateChoiceStructure( ...
    P, ...
    Log.Choice, ...
    Report);



%% ==============================================================
% Final Status
% ==============================================================

if isempty(Report.errors)

    Report.pass = true;

else

    Report.pass = false;

end



end



%% ==============================================================
% Event Code Validator
% ==============================================================

function validateEventCodes(P, Events, Report)


validCodes = collectEventCodes(P);


for i = 1:height(Events)


    if ~ismember(Events.code(i), validCodes)


        Report.errors{end+1} = sprintf( ...
            "Unknown event code detected: %d", ...
            Events.code(i));


    end


end


end



%% ==============================================================
% Collect Valid Codes
% ==============================================================

function codes = collectEventCodes(P)


codes = [


P.Events.Experiment.start
P.Events.Experiment.end


P.Events.Rating.practiceStimulus
P.Events.Rating.practiceResponse

P.Events.Rating.roundStart
P.Events.Rating.roundEnd

P.Events.Rating.stimulus
P.Events.Rating.response


P.Events.Choice.blockStart
P.Events.Choice.blockEnd

P.Events.Choice.fixation
P.Events.Choice.mask

P.Events.Choice.responseOnset
P.Events.Choice.response
P.Events.Choice.miss

P.Events.Choice.exposure(:)


P.Events.Questionnaire.onset(:)
P.Events.Questionnaire.response(:)
P.Events.Questionnaire.timeout(:)

];


end



%% ==============================================================
% Preference Rating Validator
% ==============================================================

function validateRatingStructure(P, Rating, Report)


if isempty(Rating.trials)


    Report.warnings{end+1} = ...
        "No Preference Rating trials detected.";


    return;


end



Report.nRatingTrials = ...
    length(Rating.trials);



%% Practice

if isempty(Rating.practice.stimulus)


    Report.errors{end+1} = ...
        "Preference Rating practice stimulus missing.";


end



if isempty(Rating.practice.response)


    Report.errors{end+1} = ...
        "Preference Rating practice response missing.";


end



%% Main trials

for i = 1:length(Rating.trials)


    trial = Rating.trials(i);



    if isempty(trial.stimulus)


        Report.errors{end+1}=sprintf( ...
            "Rating trial %d missing stimulus.",i);


    end



    if isempty(trial.response)


        Report.errors{end+1}=sprintf( ...
            "Rating trial %d missing response.",i);


    end


end


end



%% ==============================================================
% Choice Validator
% ==============================================================

function validateChoiceStructure(P, Choice, Report)


if isempty(Choice.blocks)


    Report.errors{end+1}= ...
        "No Choice blocks detected.";


    return;


end



nTrials = 0;



for b = 1:length(Choice.blocks)



    trials = Choice.blocks(b).trials;


    nTrials = nTrials + length(trials);



    for t = 1:length(trials)



        trial = trials(t);



        if isempty(trial.fixation)


            Report.errors{end+1}=sprintf( ...
                "Choice block %d trial %d missing fixation.", ...
                b,t);


        end



        if isempty(trial.exposure)


            Report.errors{end+1}=sprintf( ...
                "Choice block %d trial %d missing exposure.", ...
                b,t);


        else


            validateExposure( ...
                P, ...
                trial, ...
                b, ...
                t, ...
                Report);


        end



        if isempty(trial.mask)


            Report.errors{end+1}=sprintf( ...
                "Choice block %d trial %d missing mask.", ...
                b,t);


        end



        if isempty(trial.responseOnset)


            Report.errors{end+1}=sprintf( ...
                "Choice block %d trial %d missing response onset.", ...
                b,t);


        end



        if isempty(trial.response)


            Report.warnings{end+1}=sprintf( ...
                "Choice block %d trial %d has no response.", ...
                b,t);


        end



    end


end



Report.nChoiceTrials = nTrials;


end

%% ==============================================================
% Exposure Validator
% ==============================================================

function validateExposure(P, trial, blockIndex, trialIndex, Report)


observedCode = trial.exposure.code;



% Multiple exposure events are suspicious

if length(observedCode) ~= 1


    Report.errors{end+1}=sprintf( ...
        "Choice block %d trial %d has invalid exposure count.", ...
        blockIndex, ...
        trialIndex);


    return;

end



expectedCodes = P.Events.Choice.exposure(:);



if ~ismember(observedCode, expectedCodes)


    Report.errors{end+1}=sprintf( ...
        "Choice block %d trial %d has invalid exposure code.", ...
        blockIndex, ...
        trialIndex);


end


end