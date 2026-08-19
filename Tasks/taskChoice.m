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


showInstructionImage( ...
    P.Instructions.choiceInstruction, ...
    P, ...
    T);

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

%% ==============================================================
% Resolve Block Order
% ==============================================================

% Derive ascending and descending orders directly from the
% configured set sizes.

[~, ascendingOrder] = sort( ...
    P.Choice.setSizes, ...
    'ascend');

[~, descendingOrder] = sort( ...
    P.Choice.setSizes, ...
    'descend');


requestedOrder = string(R.Subject.BlockOrder);


switch requestedOrder

    case "Ascending"

        blockOrder = ascendingOrder;
        resolvedOrder = "Ascending";


    case "Descending"

        blockOrder = descendingOrder;
        resolvedOrder = "Descending";


    case "Auto"

        % Auto counterbalancing uses the numeric part at the end
        % of the participant ID.
        %
        % Examples:
        %
        %   1     -> Ascending
        %   2     -> Descending
        %   S003  -> Ascending
        %   S004  -> Descending

        participantNumberText = regexp( ...
            R.Subject.ID, ...
            '\d+$', ...
            'match', ...
            'once');


        if isempty(participantNumberText)

            error( ...
                ['Automatic block counterbalancing requires the ' ...
                 'Subject ID to end with a number.']);

        end


        participantNumber = ...
            str2double(participantNumberText);


        if mod(participantNumber, 2) == 1

            blockOrder = ascendingOrder;
            resolvedOrder = "Ascending";

        else

            blockOrder = descendingOrder;
            resolvedOrder = "Descending";

        end


    otherwise

        error( ...
            'Unknown block-order setting: %s', ...
            requestedOrder);

end


%% Store Actual Order

R.Choice.blockOrderCondition = resolvedOrder;
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

%% ==============================================================
% Experiment Finished
% ==============================================================

showInstructionImage( ...
    P.Instructions.experimentFinished, ...
    P, ...
    T);


HideCursor;


end