function showMessageScreen(message, P, T)
%SHOWMESSAGESCREEN Display a centered message and wait for SPACE.
%
%   showMessageScreen(message, P, T)
%
%   Displays one or more lines of text centered on the screen. The
%   function blocks execution until the participant presses the SPACE
%   key. Pressing ESCAPE immediately terminates the experiment.
%
%   INPUTS
%       message : Cell array of strings. Each cell represents one line
%                 of text. Empty strings can be used to insert blank lines.
%       P       : Parameter structure.
%       T       : Task structure.
%
%   EXAMPLE
%
%       showMessageScreen({
%           'Preference Rating'
%           ''
%           'You will see pictures of mugs.'
%           'Rate how much you like each mug.'
%           ''
%           'LEFT / RIGHT   Move Slider'
%           'SPACE          Confirm Rating'
%           ''
%           'Press SPACE to begin.'
%       }, P, T);
%
%   This function is intended to be a generic message renderer for the
%   entire experiment and can be reused for instructions, break screens,
%   round transitions, completion messages, calibration prompts, and
%   other text-only screens.

%% Clear screen

Screen('FillRect', T.window, P.Screen.backgroundColor);

%% Font

Screen('TextSize', T.window, ...
    P.Message.fontSize);

%% Build multiline string

text = strjoin(message, newline);

%% Draw text

DrawFormattedText( ...
    T.window, ...
    text, ...
    'center', ...
    'center', ...
    P.Screen.textColor);

Screen('Flip', T.window);

%% Wait for SPACE

KbReleaseWait;

while true

    [keyIsDown,~,keyCode] = KbCheck;

    if ~keyIsDown
        continue;
    end

    if keyCode(KbName('space'))

        KbReleaseWait;
        break;

    elseif keyCode(KbName('ESCAPE'))

        Screen('CloseAll');
        error('Experiment terminated by user.');

    end

end

end