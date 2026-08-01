function R = computeAverageRating(R)

R.Preference.average = mean( ...
    [R.Preference.round(1).rating;
     R.Preference.round(2).rating], ...
    1);

end