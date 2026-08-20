function [rating, RT] = runRatingTrial( ...
    filepath, P, T, trialType)

% runRatingTrial
%
% Run one preference-rating trial.
%
% trialType determines which event markers are used:
%
%   "practice"
%       P.Events.Rating.practiceStimulus
%       P.Events.Rating.practiceResponse
%
%   "main"
%       P.Events.Rating.stimulus
%       P.Events.Rating.response


%% ==============================================================
% Resolve Trial Events
% ==============================================================

trialType = string(trialType);


switch trialType

    case "practice"

        Event.stimulusName = ...
            "RATING_PRACTICE_STIMULUS";

        Event.stimulusCode = ...
            P.Events.Rating.practiceStimulus;


        Event.responseName = ...
            "RATING_PRACTICE_RESPONSE";

        Event.responseCode = ...
            P.Events.Rating.practiceResponse;


    case "main"

        Event.stimulusName = ...
            "RATING_STIMULUS";

        Event.stimulusCode = ...
            P.Events.Rating.stimulus;


        Event.responseName = ...
            "RATING_RESPONSE";

        Event.responseCode = ...
            P.Events.Rating.response;


    otherwise

        error( ...
            'Unknown rating trial type: %s', ...
            char(trialType));

end


%% ==============================================================
% Load Image
% ==============================================================

[textureID, imageWidth, imageHeight] = ...
    readimg( ...
        filepath, ...
        T.window);


%% ==============================================================
% Compute Destination Rectangle
% ==============================================================

scale = min( ...
    P.Screen.imageWidth / imageWidth, ...
    P.Screen.imageHeight / imageHeight);


drawWidth = ...
    imageWidth * scale;


drawHeight = ...
    imageHeight * scale;


imageRect = CenterRectOnPoint( ...
    [0 0 drawWidth drawHeight], ...
    T.centerX, ...
    T.height * ...
        P.Preference.Layout.imageCenterYFraction);


%% ==============================================================
% Collect Response
% ==============================================================

[rating, RT] = collectSliderResponse( ...
    textureID, ...
    imageRect, ...
    P, ...
    T, ...
    Event);


%% ==============================================================
% Free Texture
% ==============================================================

Screen( ...
    'Close', ...
    textureID);


%% ==============================================================
% Blank ITI
% ==============================================================

showBlankScreen( ...
    P.Timing.blankITI, ...
    P, ...
    T);


end