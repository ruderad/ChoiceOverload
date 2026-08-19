function R = taskChoice(R, P, T, ChoiceSets)

% taskChoice  Run the complete choice task.
%
%   R = taskChoice(R, P, T, ChoiceSets)
%
%   Creates the choice-task and questionnaire layouts and runs all
%   configured choice blocks.
%
%   Inputs:
%       R          - Results structure.
%       P          - Parameter structure.
%       T          - Task structure.
%       ChoiceSets - Cell array containing choice sets for each
%                    set-size block.
%
%   Output:
%       R          - Updated results structure.


ShowCursor('Arrow');


%% ==============================================================
% Choice Layout
% ==============================================================

ChoiceLayout = makeChoiceLayout(P);

ChoiceLayout = convertChoiceLayout( ...
    ChoiceLayout, ...
    T.windowRect);


%% ==============================================================
% Questionnaire Layout
% ==============================================================

QuestionnaireLayout = makeQuestionnaireLayout(P);

QuestionnaireLayout = convertQuestionnaireLayout( ...
    QuestionnaireLayout, ...
    T.windowRect);


%% ==============================================================
% Questionnaire Files
% ==============================================================

questionFiles = P.Questionnaire.questionFiles;


% Check expected number of files.
expectedFileCount = P.Questionnaire.nQuestions + 1;

if numel(questionFiles) ~= expectedFileCount

    error( ...
        ['Expected %d questionnaire image files, ' ...
         'but P.Questionnaire.questionFiles contains %d.'], ...
        expectedFileCount, ...
        numel(questionFiles));

end


% Check that every questionnaire image exists.
for q = 1:numel(questionFiles)

    if ~isfile(questionFiles{q})

        error( ...
            'Questionnaire image not found: %s', ...
            questionFiles{q});

    end

end


%% ==============================================================
% Run Blocks
% ==============================================================

blockOrder = P.Choice.blockOrder;

R.Choice.blockOrder = blockOrder;


for block = 1:numel(blockOrder)

    setSizeIndex = blockOrder(block);


    R.Choice.block(block) = runChoiceBlock( ...
        P, ...
        T, ...
        ChoiceSets{setSizeIndex}, ...
        ChoiceLayout, ...
        QuestionnaireLayout, ...
        questionFiles);

end


%% ==============================================================
% Finish
% ==============================================================

HideCursor;


end