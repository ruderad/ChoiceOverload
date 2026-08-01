function R = initializeResults(P)

%% ==============================================================
%  Preference Rating Task
%  ==============================================================

for round = 1:P.Preference.nRounds

    R.Preference.round(round).rating = ...
        nan(1, P.Images.nImages);

    R.Preference.round(round).RT = ...
        nan(1, P.Images.nImages);

    R.Preference.round(round).order = ...
        nan(1, P.Images.nImages);

end

R.Preference.average = ...
    nan(1, P.Images.nImages);

end