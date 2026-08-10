function R = computeAverageRating(R)

ratings = vertcat(R.Preference.round.rating);

R.Preference.average = mean(ratings, 1);

end