function Log = generateFakeLog(P)

% generateFakeLog
%
% Creates a minimal valid Choice Overload log.
% Used for validator testing.


Log.File = "fake_test_log";


%% Events

Log.Events = table();

Log.Events.timestamp = [];

Log.Events.task = strings(0,1);

Log.Events.code = [];

Log.Events.event = strings(0,1);



%% Helper

time = 0;


function addEvent(task,code,event)

    time = time + 1;

    Log.Events(end+1,:) = ...
        {time,string(task),code,string(event)};

end


%% Experiment

addEvent( ...
    "Experiment", ...
    P.Events.Experiment.start, ...
    "EXP_START");



%% Choice block

block.start = Log.Events(end,:);

block.events = table();


trial = struct();


trial.setSize = 24;

trial.condition = "UL";


trial.fixation = table( ...
    2,"Choice",22,"FIXATION", ...
    'VariableNames', ...
    {'timestamp','task','code','event'});


trial.exposure = table( ...
    3,"Choice", ...
    getChoiceExposureCode(P,24,"UL"), ...
    "CHOICE_EXPOSURE setSize=24 condition=UL", ...
    'VariableNames', ...
    {'timestamp','task','code','event'});


trial.mask = table( ...
    4,"Choice",23,"MASK", ...
    'VariableNames', ...
    {'timestamp','task','code','event'});


trial.responseOnset = table( ...
    5,"Choice",24,"RESPONSE_ONSET", ...
    'VariableNames', ...
    {'timestamp','task','code','event'});


trial.response = table( ...
    6,"Choice",25,"RESPONSE", ...
    'VariableNames', ...
    {'timestamp','task','code','event'});


trial.questionnaire = table();



block.events = [
    trial.fixation;
    trial.exposure;
    trial.mask;
    trial.responseOnset;
    trial.response
];


block.trials = trial;


Log.Choice.blocks = block;



%% Rating

Log.Rating.trials = struct([]);

Log.Rating.practice.stimulus = table();

Log.Rating.practice.response = table();



end