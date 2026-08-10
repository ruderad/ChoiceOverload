function R = runRatingRound(R, P, T, roundNumber, imageIndices)

% Randomize presentation order
order = imageIndices(randperm(numel(imageIndices)));

% Store presentation order
R.Preference.round(roundNumber).order = order;

% Present images
for i = 1:numel(order)

    imageIndex = order(i);

    T.progress = i / numel(order);

    [rating, RT] = runRatingTrial( ...
        P.Images.files{imageIndex}, P, T);

    % Store according to image identity
    R.Preference.round(roundNumber).rating(imageIndex) = rating;
    R.Preference.round(roundNumber).RT(imageIndex)     = RT;

end

end