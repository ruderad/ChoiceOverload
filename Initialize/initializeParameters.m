function P = initializeParameters(root)

%% ==============================================================
%  Experiment
%  ==============================================================

P.Experiment.name    = 'Choice Overload';
P.Experiment.version = '0.2.1';
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

P.Choice.Layout.centerWidth = 0.20;

P.Choice.Layout.imageWidth = 0.08;
P.Choice.Layout.imageHeight = 0.08;

P.Choice.Layout.fixationSize = 0.02;

P.Choice.Layout.maskColor = P.Screen.textColor;


%% ==============================================================
%  Questionnaire
%  ==============================================================

P.Questionnaire = struct();

end