function P = initializeParameters(root)

%% ==============================================================
%  Experiment
%  ==============================================================

P.Experiment.name    = 'Choice Overload';
P.Experiment.version = '1.0';
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
P.Screen.imageWidth  = 700;
P.Screen.imageHeight = 700;


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
%  Preference Rating Task
%  ==============================================================

P.Preference.nRounds = 2;

P.Preference.min   = 0;
P.Preference.max   = 10;
P.Preference.step  = 0.2;
P.Preference.start = 5;

%% ==============================================================
%  Choice Task
%  ==============================================================

P.Choice = struct();

%% ==============================================================
%  Questionnaire
%  ==============================================================

P.Questionnaire = struct();

end