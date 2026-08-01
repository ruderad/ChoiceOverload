function R = taskPreferenceRating(R, P, T)

% Instructions

% Round 1
R = runRatingRound(R, P, T, 1);

% Break

% Round 2
R = runRatingRound(R, P, T, 2);

% Compute averages
R = computeAverageRating(R);

end