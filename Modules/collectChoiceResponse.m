function [response, RT] = collectChoiceResponse( ...
    window, baseWindow, Layout, stimulusLocations, ...
    choiceOnset, choiceDuration, Highlight)

% collectChoiceResponse  Collect an interactive choice response.
%
%   [response, RT] = collectChoiceResponse( ...
%       window, baseWindow, Layout, stimulusLocations, ...
%       choiceOnset, choiceDuration, Highlight)
%
%   During the response phase:
%
%       1. Yellow border begins on the fixation cell.
%       2. Yellow border moves to a valid stimulus cell when hovered.
%       3. If the mouse leaves all valid cells, the yellow border
%          returns to fixation.
%       4. Clicking a valid stimulus turns its border green.
%
%   Only occupied stimulus locations can be selected.
%
%   Inputs:
%       window            - Onscreen Psychtoolbox window.
%       baseWindow        - Cached choice display in an offscreen window.
%       Layout            - Pixel-based choice-task layout.
%       stimulusLocations - Indices containing actual stimuli.
%       choiceOnset       - Response-phase onset timestamp.
%       choiceDuration    - Maximum response duration.
%       Highlight         - Highlight parameter structure.
%
%   Outputs:
%       response          - Selected spatial location.
%       RT                - Response time from choice onset.


%% ==============================================================
% Initialize
% ==============================================================
response = [];
RT = NaN;

% 0 means the initial fixation highlight is currently visible.
% [] means no highlight is visible.
% Positive values are valid stimulus locations.
currentHighlight = 0;



%% ==============================================================
% Mouse State
% ==============================================================

% Do not allow a button that was already held before response onset
% to count as a choice.
[~, ~, buttons] = GetMouse(window);

mouseArmed = ~any(buttons);


%% ==============================================================
% Response Loop
% ==============================================================

while isempty(response)


    %% ----------------------------------------------------------
    % Timeout
    % -----------------------------------------------------------

    if GetSecs - choiceOnset >= choiceDuration
        break;
    end


    %% ----------------------------------------------------------
    % Read Mouse
    % -----------------------------------------------------------

    [x, y, buttons] = GetMouse(window);


    %% ----------------------------------------------------------
    % Arm Mouse After Release
    % -----------------------------------------------------------

    if ~mouseArmed

        if ~any(buttons)
            mouseArmed = true;
        end

        continue;

    end


    %% ----------------------------------------------------------
    % Determine Hover Location
    % -----------------------------------------------------------

    hoverLocation = [];

    for i = stimulusLocations

        if IsInRect( ...
                x, ...
                y, ...
                Layout.rect(i, :))

            hoverLocation = i;
            break;

        end

    end

    %% ----------------------------------------------------------
    % Update Hover Display
    % -----------------------------------------------------------

    if ~isequal(hoverLocation, currentHighlight)

        % Restore the clean response display.
        Screen( ...
            'CopyWindow', ...
            baseWindow, ...
            window);


        % Only draw a yellow border when the mouse is
        % over a valid stimulus location.
        if ~isempty(hoverLocation)

            drawResponseHighlight( ...
                window, ...
                Layout.rect(hoverLocation, :), ...
                Highlight.hoverColor, ...
                Highlight.borderWidth);

        end


        Screen('Flip', window);

        currentHighlight = hoverLocation;

    end


    %% ----------------------------------------------------------
    % Valid Click
    % -----------------------------------------------------------

    if any(buttons) && ~isempty(hoverLocation)

        response = hoverLocation;
        RT = GetSecs - choiceOnset;


        %% ------------------------------------------------------
        % Green Selection Feedback
        % -------------------------------------------------------

        Screen( ...
            'CopyWindow', ...
            baseWindow, ...
            window);


        drawResponseHighlight( ...
            window, ...
            Layout.rect(response, :), ...
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
        % Keep Green Feedback Visible Long Enough to Perceive
        % -------------------------------------------------------

        remainingFeedback = ...
            Highlight.feedbackDuration - ...
            (GetSecs - feedbackOnset);


        if remainingFeedback > 0

            WaitSecs(remainingFeedback);

        end


        break;

    end


end


end