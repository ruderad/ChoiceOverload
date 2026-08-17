function trial = runChoiceTrial( ...
    P, T, ChoiceSet, ChoiceLayout, QuestionnaireLayout, questionFiles)

% runChoiceTrial  Run one complete choice-task trial.
%
%   trial = runChoiceTrial(P, T, ChoiceSet, Layout, questionFiles)
%
%   Trial sequence:
%
%       Fixation          1.0 s
%       Exposure          8.0 s
%       Mask              0.5 s
%       Choice fixation   1.0 s
%       Choice            3.0 s
%       Questionnaire     6.0 s
%
%   A trial with no choice response within the choice window is considered
%   missed. In that case the questionnaire is skipped.
%
%   Output:
%       trial.choiceSet
%       trial.condition
%       trial.positions
%       trial.response
%       trial.selectedImage
%       trial.RT
%       trial.question.response
%       trial.question.RT


%% ==============================================================
% Trial Information
% ==============================================================

trial.choiceSet = ChoiceSet;
trial.condition = ChoiceSet.condition;

stimulusIDs = ChoiceSet.imageIDs;

positions = randomizeChoicePositions( ...
    Layout, ...
    numel(stimulusIDs));

trial.positions = positions;


%% ==============================================================
% Fixation
% ==============================================================

Screen('FillRect', ...
    T.window, ...
    P.Screen.backgroundColor);

Screen('FillRect', ...
    T.window, ...
    P.Choice.Layout.maskColor, ...
    Layout.fixation);

Screen('DrawLines', ...
    T.window, ...
    [-P.Choice.Layout.fixationCrossSize ...
      P.Choice.Layout.fixationCrossSize; ...
      0 0], ...
    P.Choice.Layout.fixationCrossWidth, ...
    P.Choice.Layout.fixationColor, ...
    [T.centerX T.centerY]);

Screen('DrawLines', ...
    T.window, ...
    [0 0; ...
    -P.Choice.Layout.fixationCrossSize ...
     P.Choice.Layout.fixationCrossSize], ...
    P.Choice.Layout.fixationCrossWidth, ...
    P.Choice.Layout.fixationColor, ...
    [T.centerX T.centerY]);

Screen('Flip', T.window);

WaitSecs(P.Choice.fixationDuration);


%% ==============================================================
% Exposure
% ==============================================================

drawChoiceSet( ...
    P, ...
    T, ...
    stimulusIDs, ...
    ChoiceLayout, ...
    positions);

Screen('Flip', T.window);

WaitSecs(P.Choice.exposureDuration);


%% ==============================================================
% Mask
% ==============================================================

Screen('FillRect', ...
    T.window, ...
    P.Choice.Layout.maskColor, ...
    Layout.rect);

Screen('Flip', T.window);

WaitSecs(P.Choice.maskDuration);


%% ==============================================================
% Choice Fixation
% ==============================================================

Screen('FillRect', ...
    T.window, ...
    P.Screen.backgroundColor);

Screen('FrameRect', ...
    T.window, ...
    P.Choice.Layout.fixationColor, ...
    Layout.fixation, ...
    P.Choice.Layout.fixationBorderWidth);

Screen('DrawLines', ...
    T.window, ...
    [-P.Choice.Layout.fixationCrossSize ...
      P.Choice.Layout.fixationCrossSize; ...
      0 0], ...
    P.Choice.Layout.fixationCrossWidth, ...
    P.Choice.Layout.fixationColor, ...
    [T.centerX T.centerY]);

Screen('DrawLines', ...
    T.window, ...
    [0 0; ...
    -P.Choice.Layout.fixationCrossSize ...
     P.Choice.Layout.fixationCrossSize], ...
    P.Choice.Layout.fixationCrossWidth, ...
    P.Choice.Layout.fixationColor, ...
    [T.centerX T.centerY]);

Screen('Flip', T.window);

WaitSecs(P.Choice.choiceFixationDuration);


%% ==============================================================
% Choice Screen
% ==============================================================

drawChoiceSet( ...
    P, ...
    T, ...
    stimulusIDs, ...
    Layout, ...
    positions);

Screen('Flip', T.window);

choiceOnset = GetSecs;


%% ==============================================================
% Collect Choice
% ==============================================================

[response, RT] = collectChoiceResponse( ...
    T.window, ...
    ChoiceLayout, ...
    choiceOnset, ...
    P.Choice.choiceDuration);


trial.response = response;
trial.RT = RT;


%% ==============================================================
% Missed Trial
% ==============================================================

if isempty(response)

    trial.selectedImage = NaN;
    trial.question.response = nan(1, P.Questionnaire.nQuestions);
    trial.question.RT = nan(1, P.Questionnaire.nQuestions);

    return;

end


%% ==============================================================
% Determine Selected Image
% ==============================================================

trial.selectedImage = stimulusIDs( ...
    find(positions.stimulus == response));


%% ==============================================================
% Questionnaire
% ==============================================================

[questionResponse, questionRT] = runQuestionnaire( ...
    P, ...
    T, ...
    QuestionnaireLayout, ...
    questionFiles);

trial.question.response = questionResponse;
trial.question.RT = questionRT;


end