function R = runRatingRound( ...
    R, P, T, roundNumber, imageIndices)

% runRatingRound
%
% Run one experimental preference-rating round.
%
% Sends:
%
%   RATING_ROUND_START
%   RATING_STIMULUS / RATING_RESPONSE for each trial
%   RATING_ROUND_END
%
% Trial-level stimulus and response events are handled by
% runRatingTrial / collectSliderResponse.


%% ==============================================================
% Randomize Presentation Order
% ==============================================================

order = ...
    imageIndices(randperm(numel(imageIndices)));


%% ==============================================================
% Store Presentation Order
% ==============================================================

R.Preference.round(roundNumber).order = ...
    order;


%% ==============================================================
% Round Start Event
% ==============================================================

eventName = sprintf( ...
    'RATING_ROUND_START round=%d', ...
    roundNumber);


sendEvent( ...
    P, ...
    T, ...
    "PreferenceRating", ...
    eventName, ...
    P.Events.Rating.roundStart);


%% ==============================================================
% Run Main Trials
% ==============================================================

for i = 1:numel(order)

    imageIndex = ...
        order(i);


    T.progress = ...
        i / numel(order);


    [rating, RT] = runRatingTrial( ...
        P.Images.files{imageIndex}, ...
        P, ...
        T, ...
        "main");


    %% ----------------------------------------------------------
    % Store According to Image Identity
    % -----------------------------------------------------------

    R.Preference.round(roundNumber).rating(imageIndex) = ...
        rating;


    R.Preference.round(roundNumber).RT(imageIndex) = ...
        RT;

end


%% ==============================================================
% Round End Event
% ==============================================================

eventName = sprintf( ...
    'RATING_ROUND_END round=%d', ...
    roundNumber);


sendEvent( ...
    P, ...
    T, ...
    "PreferenceRating", ...
    eventName, ...
    P.Events.Rating.roundEnd);


end