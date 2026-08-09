function [rating, RT] = collectSliderResponse(textureID, imageRect, P, T)
%COLLECTSLIDERRESPONSE Collect a preference rating using mouse input.
%
%   [rating, RT] = collectSliderResponse(textureID, imageRect, P, T)
%
%   Displays the rating screen and allows the participant to adjust the
%   rating by moving the mouse horizontally across the rating scale.
%   The rating is quantized according to P.Preference.step. A left mouse
%   click confirms the current rating.
%
%   Reaction time is measured from the initial presentation of the
%   rating screen until the confirming left mouse click.
%
%   INPUTS
%       textureID : Psychtoolbox texture containing the stimulus image.
%       imageRect : Destination rectangle for the stimulus image.
%       P          : Parameter structure.
%       T          : Task structure.
%
%   OUTPUTS
%       rating : Final preference rating.
%       RT     : Response time in seconds.
%
%   EXAMPLE
%
%       [rating, RT] = collectSliderResponse( ...
%           textureID, imageRect, P, T);
%% Scale geometry
scaleWidth = round( ...
    T.width * P.Preference.Layout.scaleWidthFraction);
x0 = round((T.width - scaleWidth) / 2);
x1 = x0 + scaleWidth;
%% Initial slider position
rating = P.Preference.start;
% Draw initial screen
drawRatingScreen(textureID, imageRect, rating, P, T);
% Start RT clock after the rating screen is presented
startTime = GetSecs;
%% Response loop
while true
    %----------------------------------------------------------
    % Check keyboard for emergency exit
    %----------------------------------------------------------

    [keyIsDown, ~, keyCode] = KbCheck;

    if keyIsDown && keyCode(KbName('ESCAPE'))

        Screen('CloseAll');
        error('Experiment terminated by user.');

    end
    % Get current mouse position and button state
    [mouseX, ~, buttons] = GetMouse(T.window);
    %----------------------------------------------------------
    % Convert mouse position to rating
    %----------------------------------------------------------
    % Constrain mouse position to the rating scale
    mouseX = min(max(mouseX, x0), x1);
    % Convert mouse position to normalized scale position
    sliderPosition = (mouseX - x0) / scaleWidth;
    % Convert normalized position to rating
    rating = P.Preference.min + ...
        sliderPosition * ...
        (P.Preference.max - P.Preference.min);
    % Snap rating to the defined increment
    rating = round(rating / P.Preference.step) * ...
        P.Preference.step;
    % Protect against floating-point drift
    rating = max(P.Preference.min, ...
        min(P.Preference.max, rating));
    %----------------------------------------------------------
    % Draw updated screen
    %----------------------------------------------------------
    drawRatingScreen(textureID, imageRect, rating, P, T);
    %----------------------------------------------------------
    % Confirm with left mouse button
    %----------------------------------------------------------
    if buttons(1)
    RT = GetSecs - startTime;
    % Wait for left mouse button release
    while true
        [~, ~, buttons] = GetMouse(T.window);
        if ~buttons(1)
            break;
        end
    end
    break;
    end
end