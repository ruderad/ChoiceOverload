function [Subject, aborted] = collectSubjectInfo()
% collectSubjectInfo
%
% Simple experimenter form for entering participant information.
%
% OUTPUT
%   Subject.ID
%   Subject.Age
%   Subject.Sex
%   Subject.Handedness
%
% aborted = true if Cancel is pressed.

%% Default output

Subject.ID = '';
Subject.Age = NaN;
Subject.Sex = '';
Subject.Handedness = '';

aborted = true;

%% Options

sexOptions = {'Male', 'Female', 'Other', 'Prefer not to say'};

handednessOptions = {'Right', 'Left', 'Ambidextrous', 'Prefer not to say'};

%% Create window

fig = uifigure( ...
    'Name', 'Participant Information', ...
    'Position', [500 400 430 300], ...
    'Resize', 'off', ...
    'WindowStyle', 'modal');

%% Title

uilabel(fig, ...
    'Text', 'Participant Information', ...
    'FontSize', 16, ...
    'FontWeight', 'bold', ...
    'HorizontalAlignment', 'center', ...
    'Position', [75 250 280 25]);

%% Subject ID

uilabel(fig, ...
    'Text', 'Subject ID:', ...
    'HorizontalAlignment', 'right', ...
    'Position', [45 205 100 22]);

idField = uieditfield(fig, 'text', ...
    'Position', [160 202 220 28]);

%% Age

uilabel(fig, ...
    'Text', 'Age:', ...
    'HorizontalAlignment', 'right', ...
    'Position', [45 160 100 22]);

ageField = uieditfield(fig, 'text', ...
    'Position', [160 157 220 28]);

%% Sex

uilabel(fig, ...
    'Text', 'Sex:', ...
    'HorizontalAlignment', 'right', ...
    'Position', [45 115 100 22]);

sexField = uidropdown(fig, ...
    'Items', sexOptions, ...
    'Value', sexOptions{1}, ...
    'Position', [160 112 220 28]);

%% Handedness

uilabel(fig, ...
    'Text', 'Handedness:', ...
    'HorizontalAlignment', 'right', ...
    'Position', [45 70 100 22]);

handField = uidropdown(fig, ...
    'Items', handednessOptions, ...
    'Value', handednessOptions{1}, ...
    'Position', [160 67 220 28]);

%% Buttons

uibutton(fig, ...
    'Text', 'Cancel', ...
    'Position', [45 20 100 30], ...
    'ButtonPushedFcn', @cancelCallback);

uibutton(fig, ...
    'Text', 'Start Experiment', ...
    'FontWeight', 'bold', ...
    'Position', [230 20 150 30], ...
    'ButtonPushedFcn', @startCallback);

%% Wait

uiwait(fig);

%% ==============================================================
% Start callback
% ==============================================================

    function startCallback(~, ~)

        Subject.ID = idField.Value;
        Subject.Age = str2double(ageField.Value);
        Subject.Sex = sexField.Value;
        Subject.Handedness = handField.Value;

        aborted = false;

        uiresume(fig);
        delete(fig);

    end

%% ==============================================================
% Cancel callback
% ==============================================================

    function cancelCallback(~, ~)

        aborted = true;

        uiresume(fig);
        delete(fig);

    end

end
