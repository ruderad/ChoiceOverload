function normalizedPosition = normalizeScaleValue(value, P)
%NORMALIZESCALEVALUE Convert a scale value to the interval [0, 1].
%
%   normalizedPosition = normalizeScaleValue(value, P)
%
%   Linearly maps a value from the preference rating scale defined in
%   P.Preference to the normalized interval [0, 1]. This is primarily
%   used to convert rating values into screen coordinates when drawing
%   the rating scale and slider.
%
%   INPUTS
%       value : Value on the preference scale.
%       P     : Parameter structure containing:
%                   P.Preference.min
%                   P.Preference.max
%
%   OUTPUT
%       normalizedPosition : Value normalized to the interval [0, 1].
%
%   EXAMPLE
%
%       sliderPosition = normalizeScaleValue(rating, P);
%       sliderX = x0 + sliderPosition * scaleWidth;
%
%   Keeping the normalization logic in a single function ensures that
%   any future changes to the scale definition are propagated
%   automatically throughout the experiment.

normalizedPosition = ...
    (value - P.Preference.min) / ...
    (P.Preference.max - P.Preference.min);

end