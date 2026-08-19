function [response, RT] = collectQuestionnaireResponse( ...
    window, baseWindow, Layout, ...
    questionOnset, questionDuration, Highlight)

% collectQuestionnaireResponse
%
% Collect one response for one questionnaire question.
%
% Interaction:
%
%       hover valid button
%           -> yellow border
%
%       leave valid button
%           -> no highlight
%
%       click valid button
%           -> green confirmation border
%
% The function is independent of the number of scale points.
% Valid buttons are determined from:
%
%       size(Layout.button, 1)
%
% Therefore 7-point, 9-point, or other scale lengths require
% no changes to this function.
%
% Inputs:
%
%       window
%           Psychtoolbox onscreen window.
%
%       baseWindow
%           Offscreen cached copy of the clean questionnaire screen.
%
%       Layout
%           Pixel-based questionnaire layout.
%
%       questionOnset
%           Flip timestamp marking question onset.
%
%       questionDuration
%           Maximum response duration.
%
%       Highlight
%           Structure containing:
%
%               hoverColor
%               selectedColor
%               borderWidth
%               feedbackDuration
%
% Outputs:
%
%       response
%           Selected scale point.
%           NaN if no response occurs before timeout.
%
%       RT
%           Reaction time from question onset.
%           NaN on timeout.


%% ==============================================================
% Initialize
% ==============================================================

response = NaN;
RT = NaN;

nScalePoints = size(Layout.button, 1);

currentHighlight = [];


%% ==============================================================
% Mouse-Arming State
% ==============================================================

% A button already held when the question appears must not
% automatically become a response.

[~, ~, buttons] = GetMouse(window);

mouseArmed = ~any(buttons);


%% ==============================================================
% Response Loop
% ==============================================================

while isnan(response)


    %% ----------------------------------------------------------
    % Timeout
    % -----------------------------------------------------------

    if GetSecs - questionOnset >= questionDuration
        break;
    end


    %% ----------------------------------------------------------
    % Read Mouse
    % -----------------------------------------------------------

    [x, y, buttons] = GetMouse(window);


    %% ----------------------------------------------------------
    % Arm Mouse
    % -----------------------------------------------------------

    if ~mouseArmed && ~any(buttons)
        mouseArmed = true;
    end


    %% ----------------------------------------------------------
    % Detect Hovered Scale Point
    % -----------------------------------------------------------

    hoverScalePoint = [];


    for scalePoint = 1:nScalePoints

        if IsInRect( ...
                x, ...
                y, ...
                Layout.button(scalePoint, :))

            hoverScalePoint = scalePoint;
            break;

        end

    end


    %% ----------------------------------------------------------
    % Update Hover Display
    % -----------------------------------------------------------

    if ~isequal( ...
            hoverScalePoint, ...
            currentHighlight)


        % Restore clean questionnaire screen.

        Screen( ...
            'CopyWindow', ...
            baseWindow, ...
            window);


        % Draw yellow border only when cursor is over
        % a valid response button.

        if ~isempty(hoverScalePoint)

            drawResponseHighlight( ...
                window, ...
                Layout.button(hoverScalePoint, :), ...
                Highlight.hoverColor, ...
                Highlight.borderWidth);

        end


        Screen('Flip', window);


        currentHighlight = hoverScalePoint;

    end


    %% ----------------------------------------------------------
    % Accept Valid Response
    % -----------------------------------------------------------

    if mouseArmed && ...
            any(buttons) && ...
            ~isempty(hoverScalePoint)


        response = hoverScalePoint;

        RT = GetSecs - questionOnset;


        %% ------------------------------------------------------
        % Green Selection Feedback
        % -------------------------------------------------------

        Screen( ...
            'CopyWindow', ...
            baseWindow, ...
            window);


        drawResponseHighlight( ...
            window, ...
            Layout.button(response, :), ...
            Highlight.selectedColor, ...
            Highlight.borderWidth);


        feedbackOnset = Screen('Flip', window);


        %% ------------------------------------------------------
        % Wait for Mouse Release
        % -------------------------------------------------------

        [~, ~, buttons] = GetMouse(window);


        while any(buttons)

            WaitSecs(0.001);

            [~, ~, buttons] = GetMouse(window);

        end


        %% ------------------------------------------------------
        % Maintain Green Feedback
        % -------------------------------------------------------

        remainingFeedback = ...
            Highlight.feedbackDuration - ...
            (GetSecs - feedbackOnset);


        if remainingFeedback > 0
            WaitSecs(remainingFeedback);
        end


        break;

    end


    WaitSecs(0.001);


end


end