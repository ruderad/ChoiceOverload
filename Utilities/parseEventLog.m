function Log = parseEventLog(filepath)

% parseEventLog
%
% Parse a Choice Overload event log into a structured MATLAB object.
%
% This version adds trial-level Choice metadata:
%   trial.setSize
%   trial.condition
%
% These are extracted from:
%   CHOICE_EXPOSURE setSize=X condition=Y
%
% Validation remains separate.

if ~isfile(filepath)
    error('Event log file does not exist.');
end

Metadata = readMetadata(filepath);

opts = detectImportOptions(filepath,'FileType','text');
opts.CommentStyle = '#';
opts.VariableNames = {'timestamp','task','code','event'};
opts = setvartype(opts,{'task','event'},'string');

Events = readtable(filepath,opts);

Log.File = filepath;
Log.Metadata = Metadata;
Log.Events = Events;

Log.Rating = parseRatingEvents(Events);
Log.Choice = parseChoiceEvents(Events);

end


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

        parts = split(line,'\t');

        if numel(parts)==2

            key = strtrim(parts(1));
            value = strtrim(parts(2));

            Metadata.(matlab.lang.makeValidName(key)) = value;

        end

    else
        break;
    end

end

fclose(fid);

end


function Rating = parseRatingEvents(Events)

emptyTrial = struct( ...
    'stimulus', [], ...
    'response', []);

Rating.practice = emptyTrial;
Rating.trials = repmat(emptyTrial,0,1);

mask = Events.task == "PreferenceRating";
events = Events(mask,:);

if isempty(events)
    return;
end

codes = events.code;

practiceStim = find(codes==10,1);

if ~isempty(practiceStim)

    trial = emptyTrial;

    trial.stimulus = events(practiceStim,:);

    responseIdx = find(codes==11 & ((1:length(codes))'>practiceStim),1);

    if ~isempty(responseIdx)
        trial.response = events(responseIdx,:);
    end

    Rating.practice = trial;

end


stimuli = find(codes==14);

Rating.trials = repmat(emptyTrial,length(stimuli),1);

for i=1:length(stimuli)

    trial = emptyTrial;

    start = stimuli(i);

    trial.stimulus = events(start,:);

    responseIdx = find(codes==15 & ((1:length(codes))'>start),1);

    if ~isempty(responseIdx)
        trial.response = events(responseIdx,:);
    end

    Rating.trials(i)=trial;

end

end


function Choice = parseChoiceEvents(Events)

Choice = struct();

emptyBlock = struct( ...
    'start', table(), ...
    'events', table(), ...
    'trials', struct([]));

Choice.blocks = repmat(emptyBlock,0,1);

events = Events(Events.task=="Choice",:);

if isempty(events)
    return;
end

codes = events.code;

blockStarts = find(codes==20);

for b=1:length(blockStarts)

    block = emptyBlock;

    start = blockStarts(b);

    if b < length(blockStarts)
        stop = blockStarts(b+1)-1;
    else
        stop = height(events);
    end

    block.start = events(start,:);
    block.events = events(start:stop,:);

    block.trials = parseChoiceTrials(block.events);

    Choice.blocks(b)=block;

end

end


function trials = parseChoiceTrials(events)

emptyTrial = struct( ...
    'events', table(), ...
    'setSize', NaN, ...
    'condition', "", ...
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

fixations = find(codes==22);

for t=1:length(fixations)

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

    trial.fixation = trialEvents(trialCodes==22,:);

    trial.exposure = trialEvents(trialCodes>=30 & trialCodes<=99,:);

    if ~isempty(trial.exposure)

        eventName = string(trial.exposure.event(1));

        setSizeToken = regexp(eventName,'setSize=(\d+)','tokens','once');

        conditionToken = regexp(eventName,'condition=([A-Za-z]+)','tokens','once');

        if ~isempty(setSizeToken)
            trial.setSize = str2double(setSizeToken{1});
        end

        if ~isempty(conditionToken)
            trial.condition = string(conditionToken{1});
        end

    end

    trial.mask = trialEvents(trialCodes==23,:);

    trial.responseOnset = trialEvents(trialCodes==24,:);

    trial.response = trialEvents(trialCodes==25 | trialCodes==26,:);

    trial.questionnaire = trialEvents(trialCodes>=100,:);

    trials(end+1)=trial;

end

end
