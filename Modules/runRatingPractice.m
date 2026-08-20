function runRatingPractice(imageIndices, P, T)

%% ==============================================================
% Randomize Presentation Order
% ==============================================================

order = ...
    imageIndices(randperm(numel(imageIndices)));


%% ==============================================================
% Run Practice Trials
% ==============================================================

for i = 1:numel(order)

    imageIndex = ...
        order(i);


    T.progress = ...
        i / numel(order);


    runRatingTrial( ...
        P.Images.files{imageIndex}, ...
        P, ...
        T, ...
        "practice");

end


end