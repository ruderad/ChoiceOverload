function [Subject, aborted] = collectSubjectInfo()

% collectSubjectInfo
%
% Experimenter form for entering participant information.
% Compatible with MATLAB R2016a and later, Linux-safe.
%
% Outputs:
%
%   Subject.ID
%   Subject.Age
%   Subject.Sex
%   Subject.Handedness
%   Subject.Education
%   Subject.BlockOrder
%
% aborted = true if Cancel is pressed.


%% ==============================================================
% Default Output
%% ==============================================================

Subject.ID          = '';
Subject.Age         = NaN;
Subject.Sex         = '';
Subject.Handedness  = '';
Subject.Education   = '';
Subject.BlockOrder  = 'Auto';

aborted = true;


%% ==============================================================
% Options
%% ==============================================================

sexOptions = { ...
    'Male', ...
    'Female', ...
    'Other', ...
    'Prefer not to say'};

handednessOptions = { ...
    'Right', ...
    'Left', ...
    'Ambidextrous', ...
    'Prefer not to say'};

educationOptions = { ...
    'Primary', ...
    'Associate', ...
    'Bachelor', ...
    'Masters', ...
    'Doctorate'};

blockOrderOptions = { ...
    'Auto', ...
    'Ascending', ...
    'Descending'};


%% ==============================================================
% Layout Constants
%% ==============================================================

figW       = 430;
rowPitch   = 45;
topY       = 310;         % y of the first field row (from bottom)
labelX     = 45;
labelW     = 100;
fieldX     = 160;
fieldW     = 220;
labelH     = 22;
fieldH     = 28;
buttonH    = 30;
buttonY    = 25;

rowY = @(i) topY - (i - 1) * rowPitch;

nRows = 6;
figH  = topY + 75;        % enough room for title above + buttons below


%% ==============================================================
% Create Figure (centered on screen)
%% ==============================================================

screenSize = get(0, 'ScreenSize');   % [left bottom width height]
figX = round((screenSize(3) - figW) / 2);
figY = round((screenSize(4) - figH) / 2);

fig = figure( ...
    'Name', 'Participant Information', ...
    'NumberTitle', 'off', ...
    'MenuBar', 'none', ...
    'ToolBar', 'none', ...
    'Position', [figX figY figW figH], ...
    'Resize', 'off', ...
    'Color', [0.94 0.94 0.94]);


%% ==============================================================
% Title
%% ==============================================================

uicontrol(fig, ...
    'Style', 'text', ...
    'String', 'Participant Information', ...
    'FontSize', 14, ...
    'FontWeight', 'bold', ...
    'HorizontalAlignment', 'center', ...
    'BackgroundColor', get(fig, 'Color'), ...
    'Position', [75 topY+50 280 25]);


%% ==============================================================
% Row Helpers
%% ==============================================================

    function h = makeLabel(txt, i)
        h = uicontrol(fig, ...
            'Style', 'text', ...
            'String', txt, ...
            'HorizontalAlignment', 'right', ...
            'BackgroundColor', get(fig, 'Color'), ...
            'Position', [labelX rowY(i) labelW labelH]);
    end

    function h = makeEdit(i)
        h = uicontrol(fig, ...
            'Style', 'edit', ...
            'BackgroundColor', 'white', ...
            'HorizontalAlignment', 'left', ...
            'Position', [fieldX rowY(i)-3 fieldW fieldH]);
    end

    function h = makeDropdown(items, i)
        h = uicontrol(fig, ...
            'Style', 'popupmenu', ...
            'String', items, ...
            'Value', 1, ...
            'BackgroundColor', 'white', ...
            'Position', [fieldX rowY(i)-3 fieldW fieldH]);
    end


%% ==============================================================
% Fields
%% ==============================================================

% Row 1: Subject ID
makeLabel('Subject ID:', 1);
idField = makeEdit(1);

% Row 2: Age
makeLabel('Age:', 2);
ageField = makeEdit(2);

% Row 3: Sex
makeLabel('Sex:', 3);
sexField = makeDropdown(sexOptions, 3);

% Row 4: Handedness
makeLabel('Handedness:', 4);
handField = makeDropdown(handednessOptions, 4);

% Row 5: Education
makeLabel('Education:', 5);
educationField = makeDropdown(educationOptions, 5);

% Row 6: Block Order
makeLabel('Block Order:', 6);
blockOrderField = makeDropdown(blockOrderOptions, 6);


%% ==============================================================
% Buttons
%% ==============================================================

uicontrol(fig, ...
    'Style', 'pushbutton', ...
    'String', 'Cancel', ...
    'Position', [45 buttonY 100 buttonH], ...
    'Callback', @cancelCallback);

uicontrol(fig, ...
    'Style', 'pushbutton', ...
    'String', 'Start Experiment', ...
    'FontWeight', 'bold', ...
    'Position', [230 buttonY 150 buttonH], ...
    'Callback', @startCallback);


%% ==============================================================
% Wait for Experimenter
%% ==============================================================

uiwait(fig);


%% ==============================================================
% Start Callback
%% ==============================================================

    function startCallback(~, ~)

        Subject.ID = strtrim(get(idField, 'String'));

        Subject.Age = str2double(get(ageField, 'String'));

        Subject.Sex = sexOptions{get(sexField, 'Value')};

        Subject.Handedness = handednessOptions{get(handField, 'Value')};

        Subject.Education = educationOptions{get(educationField, 'Value')};

        Subject.BlockOrder = blockOrderOptions{get(blockOrderField, 'Value')};

        aborted = false;

        uiresume(fig);
        delete(fig);

    end


%% ==============================================================
% Cancel Callback
%% ==============================================================

    function cancelCallback(~, ~)

        aborted = true;

        uiresume(fig);
        delete(fig);

    end

end