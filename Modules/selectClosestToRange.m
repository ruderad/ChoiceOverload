function ids = selectClosestToRange( ...
    ratings, targetRange, n, excludeIDs)

% selectClosestToRange
%
% Select n stimuli closest to the requested rating range.
%
% Optional excludeIDs prevents specified stimuli from being selected.


if nargin < 4
    excludeIDs = [];
end


ratedIDs = find(~isnan(ratings));


%% Remove excluded stimuli

if ~isempty(excludeIDs)

    ratedIDs = setdiff( ...
        ratedIDs, ...
        excludeIDs, ...
        'stable');

end


%% Validate available stimuli

if n > numel(ratedIDs)

    error( ...
        ['Requested %d stimuli, but only %d eligible rated ' ...
         'stimuli are available.'], ...
        n, ...
        numel(ratedIDs));

end


ratedRatings = ratings(ratedIDs);


lower = targetRange(1);
upper = targetRange(2);


%% Distance from target region

distance = zeros(size(ratedRatings));

below = ratedRatings < lower;
above = ratedRatings > upper;

distance(below) = ...
    lower - ratedRatings(below);

distance(above) = ...
    ratedRatings(above) - upper;


%% Randomize ties

order = randperm(numel(ratedIDs));

ratedIDs = ratedIDs(order);
distance = distance(order);


%% Sort by distance

[~, order] = sort(distance);

ids = ratedIDs(order(1:n));


end