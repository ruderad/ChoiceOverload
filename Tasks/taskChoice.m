function R = taskChoice(R, P, T, ChoiceSets)

% taskChoice  Run the complete choice task.
%
%   R = taskChoice(R, P, T, ChoiceSets)
%
%   Creates the choice-task and questionnaire layouts, loads the
%   questionnaire file paths, and runs all choice blocks.
%
%   Inputs:
%       R          - Results structure.
%       P          - Parameter structure.
%       T          - Task structure.
%       ChoiceSets - Cell array containing the choice sets for each
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

questionFiles = cell( ...
    1, ...
    P.Questionnaire.nQuestions + 1);


for q = 0:P.Questionnaire.nQuestions

    questionFiles{q + 1} = fullfile( ...
        P.Experiment.root, ...
        'Instrctions', ...
        sprintf('Q%d.png', q));


    % Check that the questionnaire image exists.
    if ~isfile(questionFiles{q + 1})

        error( ...
            'Questionnaire image not found: %s', ...
            questionFiles{q + 1});

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