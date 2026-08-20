function Log = parseEventLog(filepath)

% parseEventLog
%
% Parse a Choice Overload event log into a structured MATLAB object.
%
% This function reconstructs the experimental structure from the
% event stream.
%
% It DOES NOT validate correctness.
%
% Validation is handled separately by:
%
%       validateEventLog.m
%
%
% Output:
%
%       Log.File
%       Log.Metadata
%       Log.Events
%       Log.Rating
%       Log.Choice


%% ==============================================================
% Validate File
% ==============================================================

if ~isfile(filepath)

    error( ...
        'Event log file does not exist.');

end


%% ==============================================================
% Read Metadata
% ==============================================================

Metadata = ...
    readMetadata(filepath);



%% ==============================================================
% Read Event Table
% ==============================================================

opts = detectImportOptions( ...
    filepath, ...
    'FileType','text');


opts.CommentStyle = '#';


opts.VariableNames = ...
    {'timestamp','task','code','event'};


opts = setvartype( ...
    opts, ...
    {'task','event'}, ...
    'string');


Events = readtable( ...
    filepath, ...
    opts);



%% ==============================================================
% Main Structure
% ==============================================================

Log.File = filepath;

Log.Metadata = Metadata;

Log.Events = Events;



%% ==============================================================
% Task Parsing
% ==============================================================

Log.Rating = ...
    parseRatingEvents(Events);



Log.Choice = ...
    parseChoiceEvents(Events);



end



%% ==============================================================
% Metadata Reader
% ==============================================================

function Metadata = readMetadata(filepath)


Metadata = struct();



fid = fopen(filepath,'r');


while true


    line = fgetl(fid);


    if ~ischar(line)

        break;

    end



    if startsWith(line,'#')


        line = erase(line,'#');


        parts = split( ...
            line, ...
            '\t');


        if numel(parts)==2


            key = strtrim(parts(1));

            value = strtrim(parts(2));


            Metadata.( ...
                matlab.lang.makeValidName(key)) = value;

        end


    else

        break;

    end


end


fclose(fid);


end



%% ==============================================================
% Preference Rating Parser
% ==============================================================

function Rating = parseRatingEvents(Events)


%% ==============================================================
% Initialize
% ==============================================================

emptyTrial = struct( ...
    'stimulus', [], ...
    'response', []);


Rating = struct();

Rating.practice = emptyTrial;

Rating.trials = repmat( ...
    emptyTrial, ...
    0, ...
    1);



%% ==============================================================
% Extract Rating Events
% ==============================================================

mask = ...
    Events.task == "PreferenceRating";


events = ...
    Events(mask,:);


if isempty(events)

    return;

end


codes = events.code;



%% ==============================================================
% Practice Trial
% ==============================================================

practiceStim = ...
    find(codes == 10,1);



if ~isempty(practiceStim)


    trial = emptyTrial;


    trial.stimulus = ...
        events(practiceStim,:);


    responseIdx = find( ...
        codes == 11 & ...
        ((1:length(codes))' > practiceStim), ...
        1);


    if ~isempty(responseIdx)

        trial.response = ...
            events(responseIdx,:);

    end


    Rating.practice = trial;


end



%% ==============================================================
% Main Trials
% ==============================================================

stimuli = ...
    find(codes == 14);



Rating.trials = repmat( ...
    emptyTrial, ...
    length(stimuli), ...
    1);



for i = 1:length(stimuli)


    trial = emptyTrial;


    start = stimuli(i);


    trial.stimulus = ...
        events(start,:);


    responseIdx = find( ...
        codes == 15 & ...
        ((1:length(codes))' > start), ...
        1);



    if ~isempty(responseIdx)

        trial.response = ...
            events(responseIdx,:);

    end



    Rating.trials(i) = trial;


end


end



%% ==============================================================
% Choice Parser
% ==============================================================

function Choice = parseChoiceEvents(Events)


Choice = struct();

emptyBlock = struct( ...
    'start', table(), ...
    'events', table(), ...
    'trials', struct([]));

Choice.blocks = repmat(emptyBlock,0,1);



mask = ...
    Events.task == "Choice";


events = ...
    Events(mask,:);



if isempty(events)

    return;

end



codes = events.code;



blockStarts = ...
    find(codes == 20);



for b = 1:length(blockStarts)


    block = emptyBlock;


    start = ...
        blockStarts(b);



    if b < length(blockStarts)

        stop = ...
            blockStarts(b+1)-1;

    else

        stop = ...
            height(events);

    end



    block.start = ...
        events(start,:);


    block.events = ...
        events(start:stop,:);



    block.trials = ...
        parseChoiceTrials(block.events);



    Choice.blocks(b)=block;


end



end



%% ==============================================================
% Choice Trial Parser
% ==============================================================

function trials = parseChoiceTrials(events)

% Reconstruct Choice trials.
% Parser only extracts structure.
% Validation is handled by validateEventLog.m


emptyTrial = struct( ...
    'events', table(), ...
    'fixation', table(), ...
    'exposure', table(), ...
    'mask', table(), ...
    'responseOnset', table(), ...
    'response', table(), ...
    'questionnaire', table());


trials = repmat(emptyTrial,0,1);


if isempty(events)
    return;
end


codes = events.code;


% Trial starts
fixations = find(codes == 22);


for t = 1:length(fixations)


    trial = emptyTrial;


    start = fixations(t);


    if t < length(fixations)

        stop = fixations(t+1)-1;

    else

        stop = height(events);

    end


    trialEvents = events(start:stop,:);


    trial.events = trialEvents;


    trialCodes = trialEvents.code;


    % Fixation
    idx = trialCodes == 22;

    trial.fixation = trialEvents(idx,:);


    % Exposure
    % Exposure codes are defined in P.Events.
    % Keep parser flexible.
    idx = trialCodes >= 30 & trialCodes <= 99;

    trial.exposure = trialEvents(idx,:);


    % Mask
    idx = trialCodes == 23;

    trial.mask = trialEvents(idx,:);


    % Response onset
    idx = trialCodes == 24;

    trial.responseOnset = trialEvents(idx,:);


    % Response or miss
    idx = trialCodes == 25 | trialCodes == 26;

    trial.response = trialEvents(idx,:);


    % Questionnaire events
    idx = trialCodes >= 100;

    trial.questionnaire = trialEvents(idx,:);


    trials(end+1) = trial;


end


end



