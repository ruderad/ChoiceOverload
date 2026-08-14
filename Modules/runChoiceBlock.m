function block = runChoiceBlock( ...
    window, textures, ChoiceSets, Layout, maskTexture)

% runChoiceBlock  Run all trials in one choice-task block.
%
%   block = runChoiceBlock( ...
%       window, textures, ChoiceSets, Layout, maskTexture)
%
%   Runs every choice trial in the supplied block and stores its results.
%
%   Inputs:
%       window      - Psychtoolbox window pointer.
%       textures    - PTB textures indexed by image ID.
%       ChoiceSets  - Cell array containing the choice set for each trial.
%       Layout      - Pixel-based choice-task layout.
%       maskTexture - PTB texture used for empty locations.
%
%   Output:
%       block       - Structure containing the results of each trial.


nTrials = numel(ChoiceSets);

block.trial = repmat(struct(), 1, nTrials);


for trial = 1:nTrials

    block.trial(trial) = runChoiceTrial( ...
        window, ...
        textures, ...
        ChoiceSets{trial}, ...
        Layout, ...
        maskTexture);

end

end