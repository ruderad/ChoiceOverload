function block = runChoiceBlock( ...
    P, T, ChoiceSets, ChoiceLayout, ...
    QuestionnaireLayout, questionFiles)

% runChoiceBlock  Run all trials in one choice-task block.
%
%   block = runChoiceBlock( ...
%       P, T, ChoiceSets, ChoiceLayout, ...
%       QuestionnaireLayout, questionFiles)
%
%   Runs every choice trial in the supplied block.
%
%   Inputs:
%       P                   - Parameter structure.
%       T                   - Task structure.
%       ChoiceSets          - Struct array containing the choice sets
%                             for the current block.
%       ChoiceLayout        - Pixel-based choice-task layout.
%       QuestionnaireLayout - Pixel-based questionnaire layout.
%       questionFiles       - Cell array containing questionnaire
%                             image file paths.
%
%   Output:
%       block               - Structure containing all trial results.


%% ==============================================================
% Number of Trials
% ==============================================================

nTrials = numel(ChoiceSets);


%% ==============================================================
% Preallocate Trial Structure
% ==============================================================

emptyQuestion = struct( ...
    'response', nan(1, P.Questionnaire.nQuestions), ...
    'RT',       nan(1, P.Questionnaire.nQuestions));


emptyTrial = struct( ...
    'choiceSet',     [], ...
    'condition',     "", ...
    'positions',     [], ...
    'response',      [], ...
    'selectedImage', NaN, ...
    'RT',            NaN, ...
    'question',      emptyQuestion);


block.trial = repmat( ...
    emptyTrial, ...
    1, ...
    nTrials);


%% ==============================================================
% Run Trials
% ==============================================================

for trial = 1:nTrials

    block.trial(trial) = runChoiceTrial( ...
        P, ...
        T, ...
        ChoiceSets(trial).imageIDs, ...
        ChoiceSets(trial).condition, ...
        ChoiceLayout, ...
        QuestionnaireLayout, ...
        questionFiles);

end


end