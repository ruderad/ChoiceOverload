function [response, RT] = collectChoiceResponse( ...
    window, baseWindow, Layout, stimulusLocations, ...
    choiceOnset, choiceDuration, Highlight)

% collectChoiceResponse
%
% Collect an interactive mouse response during the choice phase.
%
% Visual state:
%
%   Response onset:
%       Yellow border is already visible around fixation.
%
%   Cursor remains inside fixation:
%       Yellow fixation border remains visible.
%
%   Cursor leaves fixation:
%       Fixation highlight disappears permanently.
%
%   Cursor enters a valid stimulus:
%       Yellow border appears around that stimulus.
%
%   Cursor leaves all valid stimuli:
%       No highlight is shown.
%
%   Valid click:
%       Selected stimulus receives a green confirmation border.
%
%
% Mouse-button state and visual state are intentionally independent.
%
% A mouse button held before response onset cannot register as a choice.
% However, holding a button does not prevent hover/highlight updates.


%% ==============================================================
% Initialize Result
% ==============================================================

response = [];
RT = NaN;


%% ==============================================================
% Visual State
% ==============================================================

% Highlight-state convention:
%
%   0  = fixation currently highlighted
%   [] = no highlight
%   >0 = highlighted stimulus location
%
% runChoiceTrial has already drawn the yellow fixation border
% before entering this function.

currentHighlight = 0;


% Fixation is allowed to remain highlighted only until
% the cursor leaves it for the first time.
fixationCueActive = true;


%% ==============================================================
% Mouse-Arming State
% ==============================================================

% If a mouse button is already held when the response phase begins,
% do not allow that existing press to count as a response.
%
% This state controls RESPONSE VALIDITY ONLY.
% It does not control visual highlighting.

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
    % Arm Mouse After Existing Press Is Released
    % -----------------------------------------------------------

    if ~mouseArmed && ~any(buttons)

        mouseArmed = true;

    end


    %% ----------------------------------------------------------
    % Determine Current Highlight Target
    % -----------------------------------------------------------

    if fixationCueActive

        % As long as the cursor remains inside fixation,
        % keep the initial yellow fixation cue visible.

        if IsInRect( ...
                x, ...
                y, ...
                Layout.fixation)

            hoverLocation = 0;


        else

            % Cursor has left fixation.
            %
            % From this point onward the fixation highlight
            % can never return during this response period.

            fixationCueActive = false;

            hoverLocation = [];


            % Check whether the cursor moved directly from
            % fixation onto a valid stimulus.

            for i = stimulusLocations

                if IsInRect( ...
                        x, ...
                        y, ...
                        Layout.rect(i, :))

                    hoverLocation = i;
                    break;

                end

            end

        end


    else

        % The initial fixation cue has already ended.
        %
        % From now on only real stimulus cells can be highlighted.

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

    end


    %% ----------------------------------------------------------
    % Update Highlight Display
    % -----------------------------------------------------------

    if ~isequal( ...
            hoverLocation, ...
            currentHighlight)


        % Restore clean response screen.
        Screen( ...
            'CopyWindow', ...
            baseWindow, ...
            window);


        if isequal(hoverLocation, 0)

            % Initial fixation cue is still active.

            drawResponseHighlight( ...
                window, ...
                Layout.fixation, ...
                Highlight.hoverColor, ...
                Highlight.borderWidth);


        elseif ~isempty(hoverLocation)

            % Cursor is over a valid stimulus.

            drawResponseHighlight( ...
                window, ...
                Layout.rect(hoverLocation, :), ...
                Highlight.hoverColor, ...
                Highlight.borderWidth);


        end

        % If hoverLocation == [], nothing is drawn.
        % The clean cached screen is therefore shown with
        % no yellow response border.


        Screen('Flip', window);


        currentHighlight = hoverLocation;

    end


    %% ----------------------------------------------------------
    % Accept Valid Mouse Click
    % -----------------------------------------------------------

    if mouseArmed && ...
            any(buttons) && ...
            ~isempty(hoverLocation) && ...
            hoverLocation > 0


        response = hoverLocation;

        RT = GetSecs - choiceOnset;


        %% ------------------------------------------------------
        % Green Selection Confirmation
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


end


end