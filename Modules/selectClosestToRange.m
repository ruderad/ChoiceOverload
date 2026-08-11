function ids = selectClosestToRange(ratings, targetRange, n)

% selectClosestToRange  Select stimuli closest to a target rating range.
%
%   ids = selectClosestToRange(ratings, targetRange, n)
%
%   Selects n rated stimuli whose ratings are closest to the specified
%   target range. Stimuli inside the target range are always preferred.
%   If additional stimuli are needed, stimuli outside the range are
%   selected according to their distance from the range.
%
%   When multiple stimuli have the same distance from the target range,
%   selection among them is randomized.
%
%   Inputs:
%       ratings     - Vector of stimulus ratings, indexed by stimulus ID.
%       targetRange - Two-element vector defining the desired rating range.
%       n           - Number of stimuli to select.
%
%   Output:
%       ids         - Stimulus IDs of the selected images.


ratedIDs = find(~isnan(ratings));
ratedRatings = ratings(ratedIDs);

lower = targetRange(1);
upper = targetRange(2);

% Distance of each rating from the target range
distance = zeros(size(ratedRatings));

below = ratedRatings < lower;
above = ratedRatings > upper;

distance(below) = lower - ratedRatings(below);
distance(above) = ratedRatings(above) - upper;

% Randomize first so ties are resolved randomly
order = randperm(numel(ratedIDs));

ratedIDs = ratedIDs(order);
distance = distance(order);

% Sort by distance from target range
[~, order] = sort(distance);

ids = ratedIDs(order(1:n));

end