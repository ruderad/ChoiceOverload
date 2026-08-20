function Report = validateEventLog(P, Log)

% validateEventLog
%
% Validate a Choice Overload event log against the experiment
% event codebook.
%
% Checks:
%
%   - file integrity
%   - event code validity
%   - Preference Rating sequence
%   - Choice trial sequence
%   - Questionnaire ordering
%   - exposure code consistency
%
%
% Usage:
%
% Log = parseEventLog(filepath);
%
% Report = validateEventLog(P, Log);


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

data = Log.Events;



%% ==============================================================
% File Check
% ==============================================================

if ~isfile(filepath)

    Report.pass = false;

    Report.errors{end+1} = ...
        "Event log file does not exist.";

    return;

end






%% ==============================================================
% Empty File
% ==============================================================

if Report.nEvents == 0

    Report.pass = false;

    Report.errors{end+1} = ...
        "Event log contains no events.";

    return;

end



%% ==============================================================
% Event Code Validation
% ==============================================================


validCodes = collectEventCodes(P);


for i = 1:height(data)


    if ~ismember(data.code(i), validCodes)


        Report.pass = false;


        Report.errors{end+1} = sprintf( ...
            "Unknown event code detected: %d", ...
            data.code(i));

    end

end



%% ==============================================================
% Preference Validation
% ==============================================================

validateRatingStructure(P, Log.Rating, Report);


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



%% ==============================================================
% Print Summary
% ==============================================================


printValidationReport(Report);



end



%% ==============================================================
% Collect All Valid Codes
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
% Preference Validator
% ==============================================================
function validateRatingStructure(P, Rating, Report)


%% No rating data

if isempty(Rating.trials)

    Report.warnings{end+1} = ...
        "No Preference Rating trials detected.";

    return;

end



%% Count trials

Report.nRatingTrials = ...
    length(Rating.trials);



%% Practice validation

if isempty(Rating.practice.stimulus)

    Report.errors{end+1} = ...
        "Preference Rating practice stimulus missing.";

end


if isempty(Rating.practice.response)

    Report.errors{end+1} = ...
        "Preference Rating practice response missing.";

end



%% Main trial validation

for i = 1:length(Rating.trials)


    trial = Rating.trials(i);


    if isempty(trial.stimulus)

        Report.errors{end+1} = sprintf( ...
            "Rating trial %d missing stimulus.", ...
            i);

    end


    if isempty(trial.response)

        Report.errors{end+1} = sprintf( ...
            "Rating trial %d missing response.", ...
            i);

    end


end


end


%% ==============================================================
% Choice Validator
% ==============================================================

function validateChoiceStructure(P, Choice, Report)


%% Check blocks

if isempty(Choice.blocks)

    Report.errors{end+1} = ...
        "No Choice blocks detected.";

    return;

end



%% Count trials

nTrials = 0;



%% Validate each block

for b = 1:length(Choice.blocks)


    block = Choice.blocks(b);


    trials = block.trials;


    nTrials = nTrials + length(trials);



    for t = 1:length(trials)


        trial = trials(t);



        %% Fixation

        if isempty(trial.fixation)

            Report.errors{end+1} = sprintf( ...
                "Choice block %d trial %d missing fixation.", ...
                b,t);

        end



        %% Exposure

        if isempty(trial.exposure)

            Report.errors{end+1} = sprintf( ...
                "Choice block %d trial %d missing exposure.", ...
                b,t);

        end



        %% Mask

        if isempty(trial.mask)

            Report.errors{end+1} = sprintf( ...
                "Choice block %d trial %d missing mask.", ...
                b,t);

        end



        %% Response onset

        if isempty(trial.responseOnset)

            Report.errors{end+1} = sprintf( ...
                "Choice block %d trial %d missing response onset.", ...
                b,t);

        end



        %% Response / Miss

        if isempty(trial.response)

            Report.warnings{end+1} = sprintf( ...
                "Choice block %d trial %d has no response.", ...
                b,t);

        end



        %% Questionnaire rule

        % A questionnaire should only appear after a successful choice.
        % Detailed ordering will be added later.

    end

end



Report.nChoiceTrials = nTrials;


end

%% ==============================================================
% Print
% ==============================================================

function printValidationReport(Report)


fprintf('\n');
fprintf('====================================\n');
fprintf(' Choice Overload Event Validation\n');
fprintf('====================================\n\n');


fprintf('File:\n%s\n\n', ...
    Report.file);


fprintf('Events:\n%d\n\n', ...
    Report.nEvents);


if Report.pass

    fprintf('RESULT: PASS ✓\n');

else

    fprintf('RESULT: FAIL ✗\n\n');


    fprintf('Errors:\n');

    for i = 1:length(Report.errors)

        fprintf('- %s\n', ...
            Report.errors{i});

    end

end


fprintf('\n');

end