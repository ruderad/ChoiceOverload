function P = initializeParameters(root)

%% ==============================================================
%  Experiment
%  ==============================================================

P.Experiment.name    = 'Choice Overload';
P.Experiment.version = '0.3.0';
P.Experiment.date    = datestr(now,'yyyy-mm-dd');

% Root directory of the experiment
P.Experiment.root = root;

%% ==============================================================
%  Debug
%  ==============================================================

P.Debug.enabled = true;

%% ==============================================================
%  Acquisition
%  ==============================================================

% Debug mode is the master hardware bypass.
%
% When P.Debug.enabled = true:
%
%   EEG        -> completely bypassed
%   EyeTracker -> completely bypassed

%% Event Log

% Development / validation event logger.
%
% This logger is independent of Debug mode.
%
% When enabled, every sendEvent(...) call is written to a
% session-specific TSV file under Logs/.
%
% This allows the complete event-marker sequence to be validated
% without EEG or eye-tracking hardware.

P.Acquisition.EventLog.enabled = true;

P.Acquisition.EventLog.folder = ...
    fullfile(P.Experiment.root, 'Logs');


%% EEG

% Is the EEG hardware part of this experiment setup?
P.Acquisition.EEG.enabled = true;

P.Acquisition.EEG.port = '/dev/ttyUSB0';

P.Acquisition.EEG.BaudRate = 57600;
P.Acquisition.EEG.DataBits = 8;

% Which tasks should use EEG?
P.Acquisition.EEG.PreferenceRating = false;
P.Acquisition.EEG.Choice           = true;


%% Eye Tracker

% Is the eye tracker part of this experiment setup?
P.Acquisition.EyeTracker.enabled = true;

% Which tasks should use eye tracking?
P.Acquisition.EyeTracker.PreferenceRating = true;
P.Acquisition.EyeTracker.Choice           = true;

%% ==============================================================
%  Screen
%  ==============================================================

P.Screen.backgroundColor = [128 128 128];
P.Screen.textColor       = [255 255 255];

% Image display area (pixels)
P.Screen.imageWidth  = 550;
P.Screen.imageHeight = 550;


%% ==============================================================
%  Images
%  ==============================================================

P.Images.folder = fullfile(P.Experiment.root, 'stimuli', 'mugs');

extensions = {'*.jpg', '*.jpeg', '*.png', '*.bmp'};

files = struct([]);

for i = 1:numel(extensions)
    files = [files; dir(fullfile(P.Images.folder, extensions{i}))];
end

% Sort alphabetically
[~, idx] = sort({files.name});
files = files(idx);

P.Images.files = fullfile({files.folder}, {files.name});
P.Images.names = {files.name};
P.Images.nImages = numel(P.Images.files);


%% ==============================================================
%  Timing
%  ==============================================================

P.Timing.blankITI = 0.050;    % seconds

%% ==============================================================
%  Message Screens
%  ==============================================================

P.Message.fontSize = 28;

%% ==============================================================
%  Instruction Screens
%  ==============================================================

instructionFolder = ...
    fullfile(P.Experiment.root, 'Instructions');

P.Instructions.welcome = ...
    fullfile(instructionFolder, 'welcome.png');

P.Instructions.ratingPracticeFinished = ...
    fullfile(instructionFolder, 'ratingPracticeFinished.png');

P.Instructions.ratingRoundFinished = ...
    fullfile(instructionFolder, 'ratingRoundFinished.png');

P.Instructions.ratingTaskFinished = ...
    fullfile(instructionFolder, 'ratingTaskFinished.png');

P.Instructions.choiceInstruction = ...
    fullfile(instructionFolder, 'choiceInstruction.png');

P.Instructions.experimentFinished = ...
    fullfile(instructionFolder, 'experimentFinished.png');

%% ==============================================================
%  Preference Rating Task
%  ==============================================================

P.Preference.nRounds = 2;

P.Preference.nPracticeTrials = 5;
P.Preference.nTrialsPerRound = 120;

P.Preference.min   = 1;
P.Preference.max   = 9;
P.Preference.step  = 0.25;

% Sitance between labeled (major) ticks
P.Preference.majorTickInterval = 1;
P.Preference.start = 5;

P.Choice.RatingRanges = makeChoiceRatingRanges( ...
    P.Preference.min, ...
    P.Preference.max, ...
    P.Preference.step);

%% ==============================================================
%  Preference Rating Layout
%  ==============================================================

% Image
P.Preference.Layout.imageCenterYFraction = 0.40;

% Rating scale
P.Preference.Layout.scaleWidthFraction = 0.60;
P.Preference.Layout.scaleYFraction = 0.85;

% Tick marks
P.Preference.Layout.majorTickHeightFraction = 0.020;
P.Preference.Layout.minorTickHeightFraction = 0.010;

P.Preference.Layout.majorTickWidth = 2;
P.Preference.Layout.minorTickWidth = 1;

% Slider
P.Preference.Layout.sliderHeightFraction = 0.030;
P.Preference.Layout.sliderWidth = 4;

% Labels
P.Preference.Layout.labelOffsetFraction = 0.050;
P.Preference.Layout.fontSize = 24;

% Instructions
P.Preference.Layout.instructionsYFraction = 0.84;

% Progress bar
P.Preference.Layout.progressYFraction = 0.98;
P.Preference.Layout.progressWidthFraction = 0.30;
P.Preference.Layout.progressHeight = 4;

% Colors
P.Preference.Layout.scaleColor = [255 255 255];
P.Preference.Layout.tickColor = [255 255 255];
P.Preference.Layout.sliderColor = [0 180 0];
P.Preference.Layout.progressColor = [0 180 0];

%% ==============================================================
%  Choice Task
%  ==============================================================

P.Choice.setSizes = [6 12 24];

%% Choice Condition Trial Counts

P.Choice.TrialCounts.UL = 5;
P.Choice.TrialCounts.UM = 5;
P.Choice.TrialCounts.UH = 5;

P.Choice.TrialCounts.CF = 15;
P.Choice.TrialCounts.RS = 15;

%% Choice Task Layout
P.Choice.Layout.nColumns = 6;
P.Choice.Layout.nRows = 5;

P.Choice.Layout.centerWidth = 0.10;

P.Choice.Layout.imageWidth = 0.175;
P.Choice.Layout.imageHeight = 0.175;

P.Choice.Layout.maskColor = P.Screen.textColor;

P.Choice.Layout.fixationCrossSize   = 0.04;
P.Choice.Layout.fixationColor       = [0 1 0];
P.Choice.Layout.fixationBorderWidth = 3;
P.Choice.Layout.fixationCrossWidth  = 3;

%% Choice Response Highlighting

P.Choice.Highlight.hoverColor    = [255 255 0];   % Yellow
P.Choice.Highlight.selectedColor = [0 255 0];     % Green

P.Choice.Highlight.borderWidth = 5;

% How long the green selection confirmation remains visible
P.Choice.Highlight.feedbackDuration = 0.25;


% Choice Task Timing
P.Choice.fixationDuration       = 1.0;
P.Choice.exposureDuration       = 8.0;
P.Choice.maskDuration           = 0.5;
P.Choice.choiceFixationDuration = 1.0;
P.Choice.choiceDuration         = 3.0;

%% ==============================================================
%  Questionnaire
%  ==============================================================

P.Questionnaire.nQuestions   = 3;

% Can later be changed to 9 without changing questionnaire modules.
P.Questionnaire.nScalePoints = 9;

% Maximum response time PER QUESTION.
P.Questionnaire.duration = 6.0;


%% ==============================================================
% Questionnaire Images
% ==============================================================

% Known question-image dimensions used for layout aspect ratio.
P.Questionnaire.imageWidth  = 1872;
P.Questionnaire.imageHeight = 350;


%% ==============================================================
% Questionnaire Layout
% ==============================================================

% Q0 general instruction
P.Questionnaire.Layout.instructionWidth  = 0.82;
P.Questionnaire.Layout.instructionHeight = 0.12;
P.Questionnaire.Layout.instructionY      = -0.28;

% Current question
P.Questionnaire.Layout.questionWidth = 0.78;
P.Questionnaire.Layout.questionY     = 0.00;

% Rating scale
P.Questionnaire.Layout.scaleWidth = 0.70;
P.Questionnaire.Layout.buttonY    = 0.22;

P.Questionnaire.Layout.buttonWidth  = 0.055;
P.Questionnaire.Layout.buttonHeight = 0.055;

P.Questionnaire.Layout.buttonBorderWidth = 2;


%% ==============================================================
% Questionnaire Response Highlighting
% ==============================================================

P.Questionnaire.Highlight.hoverColor    = [255 255 0];
P.Questionnaire.Highlight.selectedColor = [0 255 0];

P.Questionnaire.Highlight.borderWidth = 5;

P.Questionnaire.Highlight.feedbackDuration = 0.25;


%% ==============================================================
% Questionnaire Files
% ==============================================================

% Generate Q0 ... Qn automatically.
%
% No questionnaire-count hardcoding here.

P.Questionnaire.questionFiles = ...
    cell(1, P.Questionnaire.nQuestions + 1);


for q = 0:P.Questionnaire.nQuestions

    P.Questionnaire.questionFiles{q + 1} = ...
        fullfile( ...
            P.Experiment.root, ...
            'Instructions', ...
            sprintf('Q%d.png', q));

end

%% ==============================================================
%  Event Markers
%  ==============================================================

% Event-codebook version.
%
% Increment this if the meaning or numbering of event codes
% changes in a future experiment version.

P.Events.version = '1.1';


%% ==============================================================
% Experiment
% ==============================================================

P.Events.Experiment.start = 1;
P.Events.Experiment.end   = 2;


%% ==============================================================
% Preference Rating
% ==============================================================

% Practice trials are kept separate from experimental trials.

P.Events.Rating.practiceStimulus = 10;
P.Events.Rating.practiceResponse = 11;

% Main rating rounds.

P.Events.Rating.roundStart = 12;
P.Events.Rating.roundEnd   = 13;

P.Events.Rating.stimulus = 14;
P.Events.Rating.response = 15;


%% ==============================================================
% Choice Task — General Events
% ==============================================================

P.Events.Choice.blockStart = 20;
P.Events.Choice.blockEnd   = 21;

P.Events.Choice.fixation = 22;
P.Events.Choice.mask     = 23;

P.Events.Choice.responseOnset = 24;
P.Events.Choice.response      = 25;

P.Events.Choice.miss = 26;


%% ==============================================================
% Choice Task — Exposure Events
% ==============================================================

% Choice exposure is the main experimental manipulation.
%
% Each Set Size x Condition combination receives its own EEG code.
%
% Rows:
%       set sizes
%
% Columns:
%       UL  UM  UH  CF  RS


P.Events.Choice.conditions = [ ...
    "UL", ...
    "UM", ...
    "UH", ...
    "CF", ...
    "RS"];


nSetSizes = ...
    numel(P.Choice.setSizes);

nConditions = ...
    numel(P.Events.Choice.conditions);


exposureStartCode = 30;


exposureCodes = ...
    exposureStartCode : ...
    exposureStartCode + ...
    nSetSizes * nConditions - 1;


P.Events.Choice.exposure = ...
    reshape( ...
        exposureCodes, ...
        nConditions, ...
        nSetSizes)';


%% ==============================================================
% Questionnaire
% ==============================================================

% Questionnaire event codes are generated automatically from
% P.Questionnaire.nQuestions.
%
% No assumption is made about there being exactly three questions.


nQuestions = ...
    P.Questionnaire.nQuestions;


questionStartCode = 45;


P.Events.Questionnaire.onset = ...
    questionStartCode + ...
    (0:nQuestions - 1);


P.Events.Questionnaire.response = ...
    questionStartCode + ...
    nQuestions + ...
    (0:nQuestions - 1);


P.Events.Questionnaire.timeout = ...
    questionStartCode + ...
    2 * nQuestions + ...
    (0:nQuestions - 1);
%% ==============================================================
% EEG/ET Sync
% ==============================================================

P.Events.Acquisition.sync = 55;

%% ==============================================================
% Validate Event-Code Range
% ==============================================================

allEventCodes = [ ...
    P.Events.Experiment.start, ...
    P.Events.Experiment.end, ...
    P.Events.Rating.practiceStimulus, ...
    P.Events.Rating.practiceResponse, ...
    P.Events.Rating.roundStart, ...
    P.Events.Rating.roundEnd, ...
    P.Events.Rating.stimulus, ...
    P.Events.Rating.response, ...
    P.Events.Choice.blockStart, ...
    P.Events.Choice.blockEnd, ...
    P.Events.Choice.fixation, ...
    P.Events.Choice.mask, ...
    P.Events.Choice.responseOnset, ...
    P.Events.Choice.response, ...
    P.Events.Choice.miss, ...
    P.Events.Choice.exposure(:)', ...
    P.Events.Questionnaire.onset, ...
    P.Events.Questionnaire.response, ...
    P.Events.Questionnaire.timeout];


if max(allEventCodes) > 255

    error( ...
        ['Event codebook exceeds the 8-bit trigger range ' ...
         '(maximum code = %d).'], ...
        max(allEventCodes));

end


if numel(unique(allEventCodes)) ~= ...
        numel(allEventCodes)

    error( ...
        'Duplicate EEG event codes detected.');

end

end