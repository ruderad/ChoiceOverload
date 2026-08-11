function ChoiceSets = makeChoiceSets(ratings, setSize)

% makeChoiceSets  Generate choice sets for one set-size block.
%
%   ChoiceSets = makeChoiceSets(ratings, setSize)
%
%   Generates 45 choice sets for the specified set size:
%       5  Uniform Least      (UL)
%       5  Uniform Moderate   (UM)
%       5  Uniform High       (UH)
%       15 Clearly Favored    (CF)
%       15 Random Set         (RS)
%
%   Uniform conditions select stimuli closest to their intended rating
%   range. If insufficient stimuli are available within the target range,
%   the closest available ratings are used as substitutes.
%
%   Inputs:
%       ratings  - Vector of stimulus ratings (1-7), indexed by stimulus ID.
%       setSize  - Number of stimuli in each choice set.
%
%   Output:
%       ChoiceSets - Struct array containing the condition and stimulus
%                    IDs for each of the 45 choice sets.


% Uniform Least
for t = 1:5

    ids = selectClosestToRange(ratings, [1 2], setSize);

    ChoiceSets(t).condition = "UL";
    ChoiceSets(t).imageIDs = ids;

end


% Uniform Moderate
for t = 1:5

    ids = selectClosestToRange(ratings, [3 5], setSize);

    ChoiceSets(5+t).condition = "UM";
    ChoiceSets(5+t).imageIDs = ids;

end


% Uniform High
for t = 1:5

    ids = selectClosestToRange(ratings, [6 7], setSize);

    ChoiceSets(10+t).condition = "UH";
    ChoiceSets(10+t).imageIDs = ids;

end


% Clearly Favored
for t = 1:15

    low = selectClosestToRange(ratings, [1 2], setSize - 1);
    high = selectClosestToRange(ratings, [6 7], 1);

    ids = [low high];

    % Randomize position of the highly favored item
    ids = ids(randperm(setSize));

    ChoiceSets(15+t).condition = "CF";
    ChoiceSets(15+t).imageIDs = ids;

end


% Random Set
ratedIDs = find(~isnan(ratings));

for t = 1:15

    ids = ratedIDs(randperm(numel(ratedIDs), setSize));

    ChoiceSets(30+t).condition = "RS";
    ChoiceSets(30+t).imageIDs = ids;

end


% Shuffle trials within block
ChoiceSets = ChoiceSets(randperm(numel(ChoiceSets)));

end