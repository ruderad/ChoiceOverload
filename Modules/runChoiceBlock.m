function block = runChoiceBlock(P, T, ChoiceSets, Layout)

% runChoiceBlock  Run all trials in one choice-task block.
%
%   Runs every choice trial in the supplied block and stores its results.
%
%   Inputs:
%       P         - Parameter structure.
%       T         - Task structure.
%       ChoiceSets - Cell array containing the choice set for each trial.
%       Layout    - Pixel-based choice-task layout.
%
%   Output:
%       block     - Structure containing the results of each trial.




nTrials = numel(ChoiceSets);

block.trial = repmat(struct(), 1, nTrials);

for trial = 1:nTrials

    block.trial(trial) = runChoiceTrial( ...
        P, ...
        T, ...
        ChoiceSets{trial}, ...
        Layout);

end

end