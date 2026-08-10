function runRatingPractice(imageIndices, P, T)

% Randomize presentation order
order = imageIndices(randperm(numel(imageIndices)));

for i = 1:numel(order)

    imageIndex = order(i);

    T.progress = i / numel(order);

    runRatingTrial( ...
        P.Images.files{imageIndex}, P, T);

end

end