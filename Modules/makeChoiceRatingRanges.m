function ranges = makeChoiceRatingRanges(minRating, maxRating, step)

% makeChoiceRatingRanges
%
% Divide a discrete preference-rating scale into three symmetric
% regions:
%
%       Least | Moderate | High
%
% Examples:
%
%   1:7
%       Least    = [1 2]
%       Moderate = [3 5]
%       High     = [6 7]
%
%   1:9
%       Least    = [1 3]
%       Moderate = [4 6]
%       High     = [7 9]
%
% The outer regions contain approximately one third of the
% available rating levels. Any remainder is assigned to the
% moderate region.


%% Validate scale

if step <= 0
    error('Rating scale step must be greater than zero.');
end

if maxRating <= minRating
    error('Maximum rating must be greater than minimum rating.');
end


%% Construct rating levels

nIntervalsExact = ...
    (maxRating - minRating) / step;

nIntervals = round(nIntervalsExact);


if abs(nIntervalsExact - nIntervals) > 1e-10

    error( ...
        ['Rating range must be evenly divisible by ' ...
         'P.Preference.step.']);

end


ratingValues = ...
    minRating + (0:nIntervals) * step;


nLevels = numel(ratingValues);


if nLevels < 3
    error('Rating scale must contain at least three levels.');
end


%% Divide into three regions

outerCount = round(nLevels / 3);

middleStart = outerCount + 1;
middleEnd   = nLevels - outerCount;


%% Store ranges

ranges.least = [ ...
    ratingValues(1), ...
    ratingValues(outerCount)];

ranges.moderate = [ ...
    ratingValues(middleStart), ...
    ratingValues(middleEnd)];

ranges.high = [ ...
    ratingValues(nLevels - outerCount + 1), ...
    ratingValues(end)];


% Useful for debugging/documentation.
ranges.values = ratingValues;


end