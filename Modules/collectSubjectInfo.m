function [Subject, aborted] = collectSubjectInfo()

% collectSubjectInfo
%
% Experimenter form for entering participant information.
%
% Outputs:
%
%   Subject.ID
%   Subject.Age
%   Subject.Sex
%   Subject.Handedness
%   Subject.BlockOrder
%
% BlockOrder options:
%
%   Auto
%       Block order will later be counterbalanced automatically
%       from the participant ID.
%
%   Ascending
%       Manual override.
%
%   Descending
%       Manual override.
%
% aborted = true if Cancel is pressed.


%% ==============================================================
% Default Output
% ==============================================================

Subject.ID          = '';
Subject.Age         = NaN;
Subject.Sex         = '';
Subject.Handedness  = '';
Subject.BlockOrder  = 'Auto';

aborted = true;


%% ==============================================================
% Options
% ==============================================================

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


blockOrderOptions = { ...
    'Auto', ...
    'Ascending', ...
    'Descending'};


%% ==============================================================
% Create Window
% ==============================================================

fig = uifigure( ...
    'Name', 'Participant Information', ...
    'Position', [500 350 430 360], ...
    'Resize', 'off', ...
    'WindowStyle', 'modal');


%% ==============================================================
% Title
% ==============================================================

uilabel(fig, ...
    'Text', 'Participant Information', ...
    'FontSize', 16, ...
    'FontWeight', 'bold', ...
    'HorizontalAlignment', 'center', ...
    'Position', [75 315 280 25]);


%% ==============================================================
% Subject ID
% ==============================================================

uilabel(fig, ...
    'Text', 'Subject ID:', ...
    'HorizontalAlignment', 'right', ...
    'Position', [45 265 100 22]);


idField = uieditfield(fig, ...
    'text', ...
    'Position', [160 262 220 28]);


%% ==============================================================
% Age
% ==============================================================

uilabel(fig, ...
    'Text', 'Age:', ...
    'HorizontalAlignment', 'right', ...
    'Position', [45 220 100 22]);


ageField = uieditfield(fig, ...
    'text', ...
    'Position', [160 217 220 28]);


%% ==============================================================
% Sex
% ==============================================================

uilabel(fig, ...
    'Text', 'Sex:', ...
    'HorizontalAlignment', 'right', ...
    'Position', [45 175 100 22]);


sexField = uidropdown(fig, ...
    'Items', sexOptions, ...
    'Value', sexOptions{1}, ...
    'Position', [160 172 220 28]);


%% ==============================================================
% Handedness
% ==============================================================

uilabel(fig, ...
    'Text', 'Handedness:', ...
    'HorizontalAlignment', 'right', ...
    'Position', [45 130 100 22]);


handField = uidropdown(fig, ...
    'Items', handednessOptions, ...
    'Value', handednessOptions{1}, ...
    'Position', [160 127 220 28]);


%% ==============================================================
% Block Order
% ==============================================================

uilabel(fig, ...
    'Text', 'Block Order:', ...
    'HorizontalAlignment', 'right', ...
    'Position', [45 85 100 22]);


blockOrderField = uidropdown(fig, ...
    'Items', blockOrderOptions, ...
    'Value', 'Auto', ...
    'Position', [160 82 220 28]);


%% ==============================================================
% Buttons
% ==============================================================

uibutton(fig, ...
    'Text', 'Cancel', ...
    'Position', [45 25 100 30], ...
    'ButtonPushedFcn', @cancelCallback);


uibutton(fig, ...
    'Text', 'Start Experiment', ...
    'FontWeight', 'bold', ...
    'Position', [230 25 150 30], ...
    'ButtonPushedFcn', @startCallback);


%% ==============================================================
% Wait for Experimenter
% ==============================================================

uiwait(fig);


%% ==============================================================
% Start Callback
% ==============================================================

    function startCallback(~, ~)

        Subject.ID = strtrim(idField.Value);

        Subject.Age = ...
            str2double(ageField.Value);

        Subject.Sex = ...
            sexField.Value;

        Subject.Handedness = ...
            handField.Value;

        Subject.BlockOrder = ...
            blockOrderField.Value;


        aborted = false;


        uiresume(fig);

        delete(fig);

    end


%% ==============================================================
% Cancel Callback
% ==============================================================

    function cancelCallback(~, ~)

        aborted = true;


        uiresume(fig);

        delete(fig);

    end


end