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

showMessageScreen( ...
    { ...
    'Preference Rating'; ...
    ''; ...
    'You will see pictures of mugs.'; ...
    'Rate how much you like each mug.'; ...
    ''; ...
    'LEFT / RIGHT        Move Slider'; ...
    'SPACE            Confirm Rating'; ...
    ''; ...
    'You will begin with a short practice.'; ...
    ''; ...
    'Press SPACE to begin.'}, P, T);


%% ==============================================================
%  Practice
%  ==============================================================

runRatingPractice(practiceImages, P, T);


%% ==============================================================
%  Begin Main Task
%  ==============================================================

showMessageScreen( ...
    { ...
    'Practice Completed!'; ...
    ''; ...
    'The main task will now begin.'; ...
    ''; ...
    'Press SPACE to begin round 1.'}, P, T);


%% ==============================================================
%  Main Rounds
%  ==============================================================

for roundNumber = 1:P.Preference.nRounds

    R = runRatingRound( ...
        R, P, T, roundNumber, mainImages);

    % Break between rounds
    if roundNumber < P.Preference.nRounds

        showMessageScreen( ...
            { ...
            sprintf('Round %d Completed!', roundNumber); ...
            ''; ...
            'Take a break.'; ...
            ''; ...
            sprintf('Press SPACE to begin round %d.', ...
                    roundNumber + 1)}, P, T);

    end

end


%% ==============================================================
%  Task Complete
%  ==============================================================

showMessageScreen( ...
    { ...
    'Preference Rating Task Completed!'; ...
    ''; ...
    'Good job!'; ...
    ''; ...
    'Call the experimenter.'}, P, T);


%% ==============================================================
%  Compute Averages
%  ==============================================================

R = computeAverageRating(R);

end