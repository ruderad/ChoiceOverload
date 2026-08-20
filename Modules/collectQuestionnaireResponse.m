function [response, RT] = collectQuestionnaireResponse( ...
    P, T, baseWindow, Layout, ...
    questionOnset, questionDuration, Highlight, QuestionnaireEvent)

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
%           -> response event emitted immediately
%           -> green confirmation border
%
%       timeout
%           -> timeout event emitted immediately
%
%
% The function is independent of:
%
%       number of questionnaire questions
%       number of scale points
%
% Valid response buttons are determined from:
%
%       size(Layout.button, 1)
%
% Therefore 7-point, 9-point, or other scale lengths require
% no changes to this function.
%
%
% Timing:
%
% Mouse state is sampled first and timestamped immediately.
%
% Response RT and response/timeout markers are therefore based on
% that mouse-sample timestamp and occur before any feedback flip.


%% ==============================================================
% Window
% ==============================================================

window = ...
    T.window;


%% ==============================================================
% Initialize
% ==============================================================

response = ...
    NaN;


RT = ...
    NaN;


nScalePoints = ...
    size(Layout.button, 1);


currentHighlight = ...
    [];


%% ==============================================================
% Mouse-Arming State
% ==============================================================

% A button already held when the question appears must not
% automatically become a response.

[~, ~, buttons] = ...
    GetMouse(window);


mouseArmed = ...
    ~any(buttons);


%% ==============================================================
% Response Loop
% ==============================================================

while isnan(response)


    %% ----------------------------------------------------------
    % Read Mouse
    % -----------------------------------------------------------

    [x, y, buttons] = ...
        GetMouse(window);


    % Timestamp this mouse sample immediately.
    %
    % GetMouse does not provide its own timestamp, so this is our
    % closest software estimate of when the current mouse state
    % was observed.

    mouseSampleTime = ...
        GetSecs;


    elapsedTime = ...
        mouseSampleTime - questionOnset;


    %% ----------------------------------------------------------
    % Timeout
    % -----------------------------------------------------------

    % Timeout is evaluated against the timestamp belonging to the
    % current mouse sample.
    %
    % A response sampled after the deadline is therefore not
    % accidentally accepted.

    if elapsedTime >= questionDuration


        %% ------------------------------------------------------
        % Timeout Event
        % -------------------------------------------------------

        eventName = sprintf( ...
            '%s elapsed=%.6f', ...
            char(QuestionnaireEvent.timeoutName), ...
            elapsedTime);


        sendEvent( ...
            P, ...
            T, ...
            "Choice", ...
            eventName, ...
            QuestionnaireEvent.timeoutCode);


        break;

    end


    %% ----------------------------------------------------------
    % Arm Mouse
    % -----------------------------------------------------------

    if ~mouseArmed && ...
            ~any(buttons)

        mouseArmed = ...
            true;

    end


    %% ----------------------------------------------------------
    % Detect Hovered Scale Point
    % -----------------------------------------------------------

    hoverScalePoint = ...
        [];


    for scalePoint = 1:nScalePoints

        if IsInRect( ...
                x, ...
                y, ...
                Layout.button(scalePoint, :))

            hoverScalePoint = ...
                scalePoint;

            break;

        end

    end


    %% ----------------------------------------------------------
    % Accept Valid Response
    % -----------------------------------------------------------

    % IMPORTANT:
    %
    % Response acceptance happens BEFORE any hover-display flip.
    %
    % This prevents screen refreshes from delaying the recorded
    % response time or acquisition marker.

    if mouseArmed && ...
            any(buttons) && ...
            ~isempty(hoverScalePoint)


        response = ...
            hoverScalePoint;


        RT = ...
            elapsedTime;


        %% ------------------------------------------------------
        % Response Event
        % -------------------------------------------------------

        eventName = sprintf( ...
            '%s value=%d RT=%.6f', ...
            char(QuestionnaireEvent.responseName), ...
            response, ...
            RT);


        sendEvent( ...
            P, ...
            T, ...
            "Choice", ...
            eventName, ...
            QuestionnaireEvent.responseCode);


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


        feedbackOnset = ...
            Screen('Flip', window);


        %% ------------------------------------------------------
        % Wait for Mouse Release
        % -------------------------------------------------------

        [~, ~, buttons] = ...
            GetMouse(window);


        while any(buttons)

            WaitSecs(0.001);


            [~, ~, buttons] = ...
                GetMouse(window);

        end


        %% ------------------------------------------------------
        % Maintain Green Feedback
        % -------------------------------------------------------

        remainingFeedback = ...
            Highlight.feedbackDuration - ...
            (GetSecs - feedbackOnset);


        if remainingFeedback > 0

            WaitSecs( ...
                remainingFeedback);

        end


        break;

    end


    %% ----------------------------------------------------------
    % Update Hover Display
    % -----------------------------------------------------------

    % Ordinary hover changes happen only after we know this mouse
    % sample was not an accepted response.

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


        Screen( ...
            'Flip', ...
            window);


        currentHighlight = ...
            hoverScalePoint;

    end


    %% ----------------------------------------------------------
    % Small Polling Pause
    % -----------------------------------------------------------

    WaitSecs(0.001);


end


end