function R = runRatingRound(R, P, T, roundNumber)

% Generate random presentation order
order = randperm(P.Images.nImages);

% Store presentation order
R.Preference.round(roundNumber).order = order;

% Preallocate
R.Preference.round(roundNumber).rating = nan(1, P.Images.nImages);
R.Preference.round(roundNumber).RT     = nan(1, P.Images.nImages);

% Present images
for i = 1:P.Images.nImages

    imageIndex = order(i);

    T.progress = i / P.Images.nImages;

    [rating, RT] = runRatingTrial(P.Images.files{imageIndex}, P, T);

    % Store according to image identity (not presentation order)
    R.Preference.round(roundNumber).rating(imageIndex) = rating;
    R.Preference.round(roundNumber).RT(imageIndex)     = RT;

end

end