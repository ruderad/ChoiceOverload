function P = initializeParameters(root)

%% ==============================================================
%  Experiment
%  ==============================================================

P.Experiment.name    = 'Choice Overload';
P.Experiment.version = '0.2.3';
P.Experiment.date    = datestr(now,'yyyy-mm-dd');

% Root directory of the experiment
P.Experiment.root = root;

%% ==============================================================
%  Debug
%  ==============================================================

P.Debug.enabled = true;

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
%  Preference Rating Task
%  ==============================================================

P.Preference.nRounds = 2;

P.Preference.nPracticeTrials = 5;
P.Preference.nTrialsPerRound = 30;

P.Preference.min   = 1;
P.Preference.max   = 7;
P.Preference.step  = 1;
% Sitance between labeled (major) ticks
P.Preference.majorTickInterval = 1;
P.Preference.start = 5;

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

P.Choice.blockOrder = [1 2 3];

% Choice Task Layout
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
P.Questionnaire.nScalePoints = 7;

% Maximum response time PER QUESTION.
P.Questionnaire.duration = 6.0;


%% ==============================================================
% Questionnaire Images
% ==============================================================

% Known question-image dimensions used for layout aspect ratio.
P.Questionnaire.imageWidth  = 1988;
P.Questionnaire.imageHeight = 204;


%% ==============================================================
% Questionnaire Layout
% ==============================================================

% Q0 general instruction
P.Questionnaire.Layout.instructionWidth  = 0.70;
P.Questionnaire.Layout.instructionHeight = 0.10;
P.Questionnaire.Layout.instructionY      = -0.28;

% Current question
P.Questionnaire.Layout.questionWidth = 0.65;
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
end