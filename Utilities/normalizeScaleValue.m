function normalizedPosition = normalizeScaleValue(value, P)
%NORMALIZESCALEVALUE Convert a scale value to the interval [0,1].
%
%   normalizedPosition = normalizeScaleValue(value, P)
%
%   Uses the preference scale defined in P.Preference.

normalizedPosition = ...
    (value - P.Preference.min) / ...
    (P.Preference.max - P.Preference.min);

end