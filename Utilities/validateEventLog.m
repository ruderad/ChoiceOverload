function Report = validateEventLog(P, Log)

% validateEventLog
%
% Validate parsed Choice Overload event log.
%
% Usage:
%   Log = parseEventLog(filepath);
%   Report = validateEventLog(P,Log);


Report.pass = true;

Report.file = Log.File;

Report.errors = {};
Report.warnings = {};

Report.nEvents = height(Log.Events);
Report.nRatingTrials = 0;
Report.nChoiceTrials = 0;
Report.nQuestionnaires = 0;


if ~isfield(P,'Events')

    Report.errors{end+1} = ...
        "Experiment event definitions missing.";

    Report.pass = false;

    return;

end


Report = validateEventCodes(P,Log.Events,Report);

Report = validateRating(P,Log.Rating,Report);

Report = validateChoice(P,Log.Choice,Report);


Report.pass = isempty(Report.errors);

end



function Report = validateEventCodes(P,Events,Report)

codes = collectEventCodes(P);

for i = 1:height(Events)

    if ~ismember(Events.code(i),codes)

        Report.errors{end+1}=sprintf( ...
            "Unknown event code detected: %d", ...
            Events.code(i));

    end

end

end



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



function Report = validateRating(P,Rating,Report)

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



function Report = validateChoice(P,Choice,Report)

if isempty(Choice.blocks)

    Report.errors{end+1}="No Choice blocks detected.";

    return;

end


count = 0;


for b = 1:length(Choice.blocks)

    block = Choice.blocks(b);

    for t = 1:length(block.trials)

        trial = block.trials(t);

        count = count + 1;


        if isempty(trial.fixation)

            Report.errors{end+1}=sprintf( ...
                "Choice block %d trial %d missing fixation.",b,t);

        end


        if isempty(trial.exposure)

            Report.errors{end+1}=sprintf( ...
                "Choice block %d trial %d missing exposure.",b,t);

        else

            Report = validateExposure(P,trial,b,t,Report);

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

            Report = validateTiming(trial,b,t,Report);

            Report = validateQuestionnaire(P,trial,b,t,Report);

        end

    end

end


Report.nChoiceTrials = count;

end



function Report = validateExposure(P,trial,b,t,Report)

observed = trial.exposure.code;


if length(observed) ~= 1

    Report.errors{end+1}=sprintf( ...
        "Choice block %d trial %d invalid exposure count.",b,t);

    return;

end


if isnan(trial.setSize)

    Report.errors{end+1}=sprintf( ...
        "Choice block %d trial %d missing set size.",b,t);

    return;

end


if strlength(trial.condition)==0

    Report.errors{end+1}=sprintf( ...
        "Choice block %d trial %d missing condition.",b,t);

    return;

end


try

    expected = getChoiceExposureCode( ...
        P, ...
        trial.setSize, ...
        trial.condition);

catch ME

    Report.errors{end+1}=sprintf( ...
        "Exposure resolution failed block %d trial %d: %s", ...
        b,t,ME.message);

    return;

end


if observed ~= expected

    Report.errors{end+1}=sprintf( ...
        "Choice block %d trial %d exposure mismatch. Expected %d got %d.", ...
        b,t,expected,observed);

end

end



function Report = validateQuestionnaire(P,trial,b,t,Report)

q = trial.questionnaire;

if isempty(q)
    return;
end


Report.nQuestionnaires = Report.nQuestionnaires + 1;


if isempty(trial.response)

    Report.errors{end+1}=sprintf( ...
        "Questionnaire without successful response block %d trial %d.", ...
        b,t);

    return;

end


valid = [

P.Events.Questionnaire.onset(:)
P.Events.Questionnaire.response(:)
P.Events.Questionnaire.timeout(:)

];


for i=1:length(q.code)

    if ~ismember(q.code(i),valid)

        Report.errors{end+1}=sprintf( ...
            "Invalid questionnaire event block %d trial %d.",b,t);

    end

end

end



function Report = validateTiming(trial,b,t,Report)

onset = trial.responseOnset.timestamp;
response = trial.response.timestamp;


if response < onset

    Report.errors{end+1}=sprintf( ...
        "Response before response onset block %d trial %d.",b,t);

end


if (response-onset)<0

    Report.errors{end+1}=sprintf( ...
        "Negative RT block %d trial %d.",b,t);

end

end
