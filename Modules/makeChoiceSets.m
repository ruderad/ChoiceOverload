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
%   Ratings are indexed by stimulus ID. Unrated stimuli are represented
%   by NaN and are excluded from all choice sets.
%
%   Inputs:
%       ratings  - Vector of stimulus ratings (1-7), indexed by stimulus ID.
%       setSize  - Number of stimuli in each choice set.
%
%   Output:
%       ChoiceSets - Struct array containing the condition and stimulus
%                    IDs for each of the 45 choice sets.

least    = find(ratings <= 2);
moderate = find(ratings >= 3 & ratings <= 5);
most     = find(ratings >= 6);
ratedIDs = find(~isnan(ratings));

ChoiceSets = [];

% Uniform least
for t = 1:5
    ids = least(randperm(numel(least), setSize));

    ChoiceSets(end+1).condition = "UL";
    ChoiceSets(end).imageIDs = ids;
end

% Uniform moderate
for t = 1:5
    ids = moderate(randperm(numel(moderate), setSize));

    ChoiceSets(end+1).condition = "UM";
    ChoiceSets(end).imageIDs = ids;
end

% Uniform most
for t = 1:5
    ids = most(randperm(numel(most), setSize));

    ChoiceSets(end+1).condition = "UH";
    ChoiceSets(end).imageIDs = ids;
end

% Clearly favored
for t = 1:15
    low = least(randperm(numel(least), setSize - 1));
    high = most(randperm(numel(most), 1));

    ids = [low high];
    ids = ids(randperm(setSize));

    ChoiceSets(end+1).condition = "CF";
    ChoiceSets(end).imageIDs = ids;
end

% Random set
for t = 1:15
    ids = ratedIDs(randperm(numel(ratedIDs), setSize));

    ChoiceSets(end+1).condition = "RS";
    ChoiceSets(end).imageIDs = ids;
end

% Shuffle trials within the block
ChoiceSets = ChoiceSets(randperm(numel(ChoiceSets)));

end