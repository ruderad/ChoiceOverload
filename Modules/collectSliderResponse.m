function [rating, RT] = collectSliderResponse( ...
    textureID, imageRect, P, T, Event)

%COLLECTSLIDERRESPONSE Collect a preference rating using mouse input.
%
%   [rating, RT] = collectSliderResponse( ...
%       textureID, imageRect, P, T, Event)
%
%   Displays the rating screen and allows the participant to adjust the
%   rating by moving the mouse horizontally across the rating scale.
%
%   The rating is quantized according to P.Preference.step.
%   A left mouse click confirms the current rating.
%
%   The stimulus event is sent only after the FIRST presentation.
%   Subsequent slider redraws do not generate stimulus markers.
%
%   Reaction time is measured from the actual first screen flip
%   until the detected confirming left mouse click.


%% ==============================================================
% Scale Geometry
% ==============================================================

scaleWidth = round( ...
    T.width * ...
    P.Preference.Layout.scaleWidthFraction);


x0 = round( ...
    (T.width - scaleWidth) / 2);


x1 = ...
    x0 + scaleWidth;


%% ==============================================================
% Initial Slider Position
% ==============================================================

rating = ...
    P.Preference.start;


%% ==============================================================
% Initial Stimulus Presentation
% ==============================================================

% This is the ONLY rating-screen presentation that receives
% a stimulus-onset event.
%
% drawRatingScreen returns the Psychtoolbox flip timestamp.

stimulusOnset = drawRatingScreen( ...
    textureID, ...
    imageRect, ...
    rating, ...
    P, ...
    T);


%% ==============================================================
% Stimulus Event
% ==============================================================

sendEvent( ...
    P, ...
    T, ...
    "PreferenceRating", ...
    Event.stimulusName, ...
    Event.stimulusCode);


%% ==============================================================
% Response Clock
% ==============================================================

% Anchor RT directly to the actual first screen flip.

startTime = ...
    stimulusOnset;


%% ==============================================================
% Response Loop
% ==============================================================

while true


    %% ----------------------------------------------------------
    % Emergency Exit
    % -----------------------------------------------------------

    [keyIsDown, ~, keyCode] = ...
        KbCheck;


    if keyIsDown && ...
            keyCode(KbName('ESCAPE'))

        Screen('CloseAll');

        error( ...
            'Experiment terminated by user.');

    end


    %% ----------------------------------------------------------
    % Mouse State
    % -----------------------------------------------------------

    [mouseX, ~, buttons] = ...
        GetMouse(T.window);


    % Timestamp the mouse sample immediately.
    %
    % GetMouse does not provide its own timestamp, so this is the
    % closest software timestamp to the detected response.

    mouseSampleTime = ...
        GetSecs;


    %% ----------------------------------------------------------
    % Convert Mouse Position to Rating
    % -----------------------------------------------------------

    % Constrain mouse position to the rating scale.

    mouseX = ...
        min(max(mouseX, x0), x1);


    % Convert mouse position to normalized scale position.

    sliderPosition = ...
        (mouseX - x0) / scaleWidth;


    % Convert normalized position to rating.

    rating = ...
        P.Preference.min + ...
        sliderPosition * ...
        (P.Preference.max - P.Preference.min);


    % Snap rating to the defined increment.

    rating = ...
        round(rating / P.Preference.step) * ...
        P.Preference.step;


    % Protect against floating-point drift.

    rating = max( ...
        P.Preference.min, ...
        min( ...
            P.Preference.max, ...
            rating));


    %% ----------------------------------------------------------
    % Confirm with Left Mouse Button
    % -----------------------------------------------------------

    if buttons(1)


        %% Response Time

        RT = ...
            mouseSampleTime - startTime;


        %% Response Event

        eventName = sprintf( ...
            '%s rating=%g', ...
            char(Event.responseName), ...
            rating);


        sendEvent( ...
            P, ...
            T, ...
            "PreferenceRating", ...
            eventName, ...
            Event.responseCode);


        %% ------------------------------------------------------
        % Final Slider Display
        % -------------------------------------------------------

        % Draw the final selected slider position.
        %
        % This happens AFTER the response timestamp/event so the
        % screen flip cannot delay the recorded response time.

        drawRatingScreen( ...
            textureID, ...
            imageRect, ...
            rating, ...
            P, ...
            T);


        %% ------------------------------------------------------
        % Wait for Left Mouse Button Release
        % -------------------------------------------------------

        while true

            [~, ~, buttons] = ...
                GetMouse(T.window);


            if ~buttons(1)

                break;

            end

        end


        break;

    end


    %% ----------------------------------------------------------
    % Draw Updated Screen
    % -----------------------------------------------------------

    % No event is sent for ordinary slider redraws.

    drawRatingScreen( ...
        textureID, ...
        imageRect, ...
        rating, ...
        P, ...
        T);


end


end