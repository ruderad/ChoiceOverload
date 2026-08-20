function Report = validateEventLog(P, Log)

% validateEventLog
%
% Validation layer for Choice Overload.
%
% Usage:
%   Log = parseEventLog(filepath);
%   Report = validateEventLog(P, Log);
%
% Checks:
%   - event validity
%   - rating integrity
%   - choice event sequence
%   - exposure trigger correctness
%   - questionnaire consistency
%   - response timing integrity
%
% The validator checks the recorded execution.
% It does not duplicate experiment generation logic.

%% Initialize report

Report.pass = true;

Report.file = Log.File;

Report.errors = {};
Report.warnings = {};

Report.nEvents = height(Log.Events);
Report.nRatingTrials = 0;
Report.nChoiceTrials = 0;
Report.nQuestionnaires = 0;


%% Parameter integrity

if ~isfield(P,"Events")

    Report.errors{end+1} = ...
        "Missing event definition table.";

    Report.pass = false;
    return;

end


%% Run validation layers

Report = validateEventCodes(P,Log.Events,Report);

Report = validateRating(Log.Rating,Report);

Report = validateChoice(P,Log.Choice,Report);


Report.pass = isempty(Report.errors);

end



%% ==============================================================
function Report = validateEventCodes(P,Events,Report)

valid = collectEventCodes(P);

for i = 1:height(Events)

    if ~ismember(Events.code(i),valid)

        Report.errors{end+1}=sprintf( ...
            "Unknown event code %d.", Events.code(i));

    end

end

end



%% ==============================================================
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
function Report = validateRating(Rating,Report)

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
function Report = validateChoice(P,Choice,Report)

for b = 1:length(Choice.blocks)

    block = Choice.blocks(b);

    for t = 1:length(block.trials)

        trial = block.trials(t);

        Report.nChoiceTrials = Report.nChoiceTrials + 1;


        if isempty(trial.fixation)

            Report.errors{end+1}=sprintf( ...
                "Block %d trial %d missing fixation.",b,t);

        end


        if isempty(trial.exposure)

            Report.errors{end+1}=sprintf( ...
                "Block %d trial %d missing exposure.",b,t);

        else

            Report = validateExposure(P,trial,b,t,Report);

        end


        if isempty(trial.mask)

            Report.errors{end+1}=sprintf( ...
                "Block %d trial %d missing mask.",b,t);

        end


        if isempty(trial.responseOnset)

            Report.errors{end+1}=sprintf( ...
                "Block %d trial %d missing response onset.",b,t);

        end


        if isempty(trial.response)

            Report.warnings{end+1}=sprintf( ...
                "Block %d trial %d missing response.",b,t);

        else

            Report = validateTiming(trial,b,t,Report);

        end


        Report = validateQuestionnaire(P,trial,b,t,Report);

    end

end

end



%% ==============================================================
function Report = validateExposure(P,trial,b,t,Report)

observed = trial.exposure.code;


if length(observed) ~= 1

    Report.errors{end+1}=sprintf( ...
        "Block %d trial %d invalid exposure count.",b,t);

    return;

end


if isnan(trial.setSize) || strlength(trial.condition)==0

    Report.errors{end+1}=sprintf( ...
        "Block %d trial %d missing exposure metadata.",b,t);

    return;

end


try

    expected = getChoiceExposureCode( ...
        P, trial.setSize, trial.condition);

catch ME

    Report.errors{end+1}=sprintf( ...
        "Exposure validation failed block %d trial %d: %s", ...
        b,t,ME.message);

    return;

end


if observed ~= expected

    Report.errors{end+1}=sprintf( ...
        "Exposure mismatch block %d trial %d. Expected %d got %d.", ...
        b,t,expected,observed);

end

end



%% ==============================================================
function Report = validateQuestionnaire(P,trial,b,t,Report)

q = trial.questionnaire;

if isempty(q)
    return;
end


Report.nQuestionnaires = Report.nQuestionnaires + 1;


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
function Report = validateTiming(trial,b,t,Report)

onset = trial.responseOnset.timestamp;
response = trial.response.timestamp;


if response < onset

    Report.errors{end+1}=sprintf( ...
        "Response before onset block %d trial %d.",b,t);

end


if response-onset < 0

    Report.errors{end+1}=sprintf( ...
        "Negative RT block %d trial %d.",b,t);

end

end
