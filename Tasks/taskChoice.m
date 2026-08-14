function R = taskChoice(P, R, window, textures, ChoiceSets, maskTexture)

% taskChoice  Run the choice task.
%
%   R = taskChoice(P, R, window, textures, ChoiceSets, maskTexture)
%
%   Runs the three choice-task blocks in the order specified by
%   P.Choice.blockOrder and stores the results in R.Choice.
%
%   Inputs:
%       P           - Parameter structure.
%       R           - Results structure.
%       window      - Psychtoolbox window pointer.
%       textures    - PTB textures indexed by image ID.
%       ChoiceSets  - Cell array containing the prepared choice sets
%                     for each set size.
%       maskTexture - PTB texture used for empty locations.
%
%   Output:
%       R           - Updated results structure.
%
%   ChoiceSets are organized by set-size index:
%
%       ChoiceSets{1} -> 6-item trials
%       ChoiceSets{2} -> 12-item trials
%       ChoiceSets{3} -> 24-item trials
%
%   The function only handles block execution and result storage.


%% Create choice layout

Layout = makeChoiceLayout(P);

screenRect = Screen('Rect', window);

Layout = convertChoiceLayout(Layout, screenRect);


%% Run blocks

blockOrder = P.Choice.blockOrder;

R.Choice.blockOrder = blockOrder;

for block = 1:numel(blockOrder)

    setSizeIndex = blockOrder(block);

    R.Choice.block(block) = ...
        runChoiceBlock( ...
            window, ...
            textures, ...
            ChoiceSets{setSizeIndex}, ...
            Layout, ...
            maskTexture);

end

end