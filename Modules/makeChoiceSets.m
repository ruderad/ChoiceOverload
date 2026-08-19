function ChoiceSets = makeChoiceSets( ...
    ratings, setSize, ratingRanges, trialCounts)

% makeChoiceSets
%
% Generate all choice sets for one set-size block.
%
% Inputs:
%
%   ratings
%       Vector of stimulus ratings indexed by stimulus ID.
%
%   setSize
%       Number of stimuli presented in each choice set.
%
%   ratingRanges
%       Struct containing:
%
%           ratingRanges.least
%           ratingRanges.moderate
%           ratingRanges.high
%
%   trialCounts
%       Struct containing the number of trials for each condition:
%
%           trialCounts.UL
%           trialCounts.UM
%           trialCounts.UH
%           trialCounts.CF
%           trialCounts.RS
%
% Output:
%
%   ChoiceSets
%       Struct array containing:
%
%           .condition
%           .imageIDs
%
%
% Conditions:
%
%   UL = Uniform Least
%   UM = Uniform Moderate
%   UH = Uniform High
%   CF = Clearly Favored
%   RS = Random Set
%
% All trial counts and rating ranges are parameterized.


%% ==============================================================
% Validate Inputs
% ==============================================================

requiredRanges = { ...
    'least', ...
    'moderate', ...
    'high'};


for i = 1:numel(requiredRanges)

    if ~isfield(ratingRanges, requiredRanges{i})

        error( ...
            'Missing rating range: ratingRanges.%s', ...
            requiredRanges{i});

    end

end


requiredConditions = { ...
    'UL', ...
    'UM', ...
    'UH', ...
    'CF', ...
    'RS'};


for i = 1:numel(requiredConditions)

    condition = requiredConditions{i};

    if ~isfield(trialCounts, condition)

        error( ...
            'Missing trial count: trialCounts.%s', ...
            condition);

    end


    count = trialCounts.(condition);

    if count < 0 || ...
            count ~= round(count)

        error( ...
            'trialCounts.%s must be a non-negative integer.', ...
            condition);

    end

end


if setSize < 2 || ...
        setSize ~= round(setSize)

    error( ...
        'setSize must be an integer greater than or equal to 2.');

end


%% ==============================================================
% Rated Stimuli
% ==============================================================

ratedIDs = find(~isnan(ratings));


if numel(ratedIDs) < setSize

    error( ...
        ['Choice-set size is %d, but only %d rated stimuli ' ...
         'are available.'], ...
        setSize, ...
        numel(ratedIDs));

end


%% ==============================================================
% Preallocate Choice Sets
% ==============================================================

totalTrials = ...
    trialCounts.UL + ...
    trialCounts.UM + ...
    trialCounts.UH + ...
    trialCounts.CF + ...
    trialCounts.RS;


emptyTrial = struct( ...
    'condition', "", ...
    'imageIDs', []);


ChoiceSets = repmat( ...
    emptyTrial, ...
    1, ...
    totalTrials);


trialIndex = 0;


%% ==============================================================
% Uniform Least
% ==============================================================

for t = 1:trialCounts.UL

    trialIndex = trialIndex + 1;


    ids = selectClosestToRange( ...
        ratings, ...
        ratingRanges.least, ...
        setSize);


    ChoiceSets(trialIndex).condition = "UL";
    ChoiceSets(trialIndex).imageIDs = ids;

end


%% ==============================================================
% Uniform Moderate
% ==============================================================

for t = 1:trialCounts.UM

    trialIndex = trialIndex + 1;


    ids = selectClosestToRange( ...
        ratings, ...
        ratingRanges.moderate, ...
        setSize);


    ChoiceSets(trialIndex).condition = "UM";
    ChoiceSets(trialIndex).imageIDs = ids;

end


%% ==============================================================
% Uniform High
% ==============================================================

for t = 1:trialCounts.UH

    trialIndex = trialIndex + 1;


    ids = selectClosestToRange( ...
        ratings, ...
        ratingRanges.high, ...
        setSize);


    ChoiceSets(trialIndex).condition = "UH";
    ChoiceSets(trialIndex).imageIDs = ids;

end


%% ==============================================================
% Clearly Favored
% ==============================================================

for t = 1:trialCounts.CF

    trialIndex = trialIndex + 1;


    % Select the favored item first.

    high = selectClosestToRange( ...
        ratings, ...
        ratingRanges.high, ...
        1);


    % Select the remaining items from the least-preferred range.
    %
    % Excluding the favored stimulus guarantees that the same
    % stimulus cannot appear twice in one choice set.

    low = selectClosestToRange( ...
        ratings, ...
        ratingRanges.least, ...
        setSize - 1, ...
        high);


    ids = [low high];


    % Randomize the spatial-list position of the favored item.

    ids = ids(randperm(numel(ids)));


    ChoiceSets(trialIndex).condition = "CF";
    ChoiceSets(trialIndex).imageIDs = ids;

end


%% ==============================================================
% Random Set
% ==============================================================

for t = 1:trialCounts.RS

    trialIndex = trialIndex + 1;


    ids = ratedIDs( ...
        randperm( ...
            numel(ratedIDs), ...
            setSize));


    ChoiceSets(trialIndex).condition = "RS";
    ChoiceSets(trialIndex).imageIDs = ids;

end


%% ==============================================================
% Shuffle Trials Within Block
% ==============================================================

if ~isempty(ChoiceSets)

    ChoiceSets = ChoiceSets( ...
        randperm(numel(ChoiceSets)));

end


end