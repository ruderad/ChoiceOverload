function R = taskPreferenceRating(R, P, T)

%% ==============================================================
%  Select Images
%  ==============================================================

nPractice = P.Preference.nPracticeTrials;
nMain     = P.Preference.nTrialsPerRound;

% Check that enough images are available
if nPractice + nMain > P.Images.nImages
    error('Not enough images for requested practice and main trials.');
end

% Randomize complete image pool
imagePool = randperm(P.Images.nImages);

% Practice images
practiceImages = imagePool(1:nPractice);

% Main images
mainImages = imagePool(nPractice + 1 : nPractice + nMain);


%% ==============================================================
%  Instructions
%  ==============================================================

showInstructionImage( ...
    P.Instructions.welcome, ...
    P, ...
    T);



%% ==============================================================
%  Begin Main Task
%  ==============================================================
%% ==============================================================
%  Practice
%  ==============================================================

runRatingPractice(practiceImages, P, T);

% practice finished screen
showInstructionImage( ...
    P.Instructions.ratingPracticeFinished, ...
    P, ...
    T);
%% ==============================================================
% Main Rounds
% ==============================================================

for roundNumber = 1:P.Preference.nRounds

    R = runRatingRound( ...
        R, ...
        P, ...
        T, ...
        roundNumber, ...
        mainImages);


    if roundNumber < P.Preference.nRounds

        showInstructionImage( ...
            P.Instructions.ratingRoundFinished, ...
            P, ...
            T);

    else

        showInstructionImage( ...
            P.Instructions.ratingTaskFinished, ...
            P, ...
            T);

    end

end



%% ==============================================================
%  Compute Averages
%  ==============================================================

R = computeAverageRating(R);

end