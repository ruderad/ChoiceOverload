function Report = validateEventLog(P, Log)

% validateEventLog
%
% Validate parsed Choice Overload event log.
%
% Usage:
%
% Log = parseEventLog(filepath);
% Report = validateEventLog(P, Log);


%% ==============================================================
% Initialize
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
% Experiment Definition
% ==============================================================

if ~isfield(P,'Events')

    Report.pass = false;

    Report.errors{end+1} = ...
        "Experiment event definitions missing.";

    return;

end



%% ==============================================================
% Event Codes
% ==============================================================

Report = validateEventCodes(P, Log.Events, Report);



%% ==============================================================
% Rating
% ==============================================================

Report = validateRatingStructure(P, Log.Rating, Report);



%% ==============================================================
% Choice
% ==============================================================

Report = validateChoiceStructure(P, Log.Choice, Report);



%% ==============================================================
% Final Status
% ==============================================================

Report.pass = isempty(Report.errors);


end



%% ==============================================================
% Event Code Validation
% ==============================================================

function Report = validateEventCodes(P, Events, Report)


validCodes = collectEventCodes(P);


for i = 1:height(Events)

    if ~ismember(Events.code(i), validCodes)

        Report.errors{end+1}=sprintf( ...
            "Unknown event code detected: %d", ...
            Events.code(i));

    end

end


end



%% ==============================================================
% Collect Event Codes
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
% Rating Validation
% ==============================================================

function Report = validateRatingStructure(P, Rating, Report)


if isempty(Rating.trials)

    Report.warnings{end+1}= ...
        "No Preference Rating trials detected.";

    return;

end



Report.nRatingTrials = length(Rating.trials);



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
% Choice Validation
% ==============================================================

function Report = validateChoiceStructure(P, Choice, Report)


if isempty(Choice.blocks)

    Report.errors{end+1}= ...
        "No Choice blocks detected.";

    return;

end



nTrials = 0;



for b = 1:length(Choice.blocks)


    block = Choice.blocks(b);

    trials = block.trials;


    nTrials = nTrials + length(trials);



    for t = 1:length(trials)


        trial = trials(t);



        if isempty(trial.fixation)

            Report.errors{end+1}=sprintf( ...
                "Choice block %d trial %d missing fixation.",b,t);

        end



        if isempty(trial.exposure)

            Report.errors{end+1}=sprintf( ...
                "Choice block %d trial %d missing exposure.",b,t);

        else

            Report = validateExposure( ...
                P, block, trial, b, t, Report);

        end



        if isempty(trial.mask)

            Report.errors{end+1}=sprintf( ...
                "Choice block %d trial %d missing mask.",b,t);

        end



        if isempty(trial.responseOnset)

            Report.errors{end+1}=sprintf( ...
                "Choice block %d trial %d missing response onset.",b,t);

        end



        if isempty(trial.response)

            Report.warnings{end+1}=sprintf( ...
                "Choice block %d trial %d has no response.",b,t);

        else

            Report = validateTiming( ...
                trial, b, t, Report);


            Report = validateQuestionnaire( ...
                P, trial, b, t, Report);

        end


    end


end



Report.nChoiceTrials = nTrials;


end



%% ==============================================================
% Exposure Validation
% ==============================================================

function Report = validateExposure(P, block, trial, b, t, Report)


observed = trial.exposure.code;


if length(observed) ~= 1


    Report.errors{end+1}=sprintf( ...
        "Choice block %d trial %d invalid exposure count.",b,t);


    return;

end



try

    expected = getChoiceExposureCode(P, block);


catch

    Report.errors{end+1}=sprintf( ...
        "Cannot determine exposure for block %d.",b);

    return;

end



if observed ~= expected

    Report.errors{end+1}=sprintf( ...
        "Choice block %d trial %d exposure mismatch. Expected %d got %d.", ...
        b,t,expected,observed);

end


end



%% ==============================================================
% Questionnaire Validation
% ==============================================================

function Report = validateQuestionnaire(P, trial, b, t, Report)


q = trial.questionnaire;


if isempty(q)

    return;

end



Report.nQuestionnaires = ...
    Report.nQuestionnaires + 1;



if isempty(trial.response)

    Report.errors{end+1}=sprintf( ...
        "Choice block %d trial %d questionnaire without response.",b,t);

    return;

end



valid = [

    P.Events.Questionnaire.onset(:)
    P.Events.Questionnaire.response(:)
    P.Events.Questionnaire.timeout(:)

];



for i = 1:length(q.code)


    if ~ismember(q.code(i),valid)

        Report.errors{end+1}=sprintf( ...
            "Invalid questionnaire event block %d trial %d.",b,t);

    end


end


end



%% ==============================================================
% Timing Validation
% ==============================================================

function Report = validateTiming(trial,b,t,Report)


onset = trial.responseOnset.timestamp;

response = trial.response.timestamp;



if response < onset


    Report.errors{end+1}=sprintf( ...
        "Choice block %d trial %d response before response onset.", ...
        b,t);


end



RT = response - onset;



if RT < 0


    Report.errors{end+1}=sprintf( ...
        "Choice block %d trial %d negative reaction time.", ...
        b,t);


end


end