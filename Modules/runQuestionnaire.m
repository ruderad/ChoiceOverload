function [response, RT] = runQuestionnaire( ...
    P, T, Layout, questionFiles)

% runQuestionnaire
%
% Run the sequential questionnaire.
%
% Each question is presented on a separate screen:
%
%       Q0 instruction
%             ↓
%       current question
%             ↓
%       rating scale
%
% One response and one RT are collected per question.


%% ==============================================================
% Initialize Results
% ==============================================================

nQuestions = P.Questionnaire.nQuestions;

response = nan(1, nQuestions);
RT       = nan(1, nQuestions);


%% ==============================================================
% Run Questions Sequentially
% ==============================================================

for question = 1:nQuestions


    %% ----------------------------------------------------------
    % Create Clean-Screen Cache
    % -----------------------------------------------------------

    responseBuffer = Screen( ...
        'OpenOffscreenWindow', ...
        T.window, ...
        P.Screen.backgroundColor);


    %% ----------------------------------------------------------
    % Draw Current Question
    % -----------------------------------------------------------

    % Draw using the real onscreen window so image textures
    % are created against T.window.

    drawQuestionnaire( ...
        P, ...
        T, ...
        Layout, ...
        questionFiles, ...
        question);


    %% ----------------------------------------------------------
    % Cache Clean Questionnaire Screen
    % -----------------------------------------------------------

    Screen( ...
        'CopyWindow', ...
        T.window, ...
        responseBuffer);


    % %% ----------------------------------------------------------
    % % Reset Cursor
    % % -----------------------------------------------------------
    % 
    % % Start every questionnaire question from the center of
    % % the screen so the cursor cannot begin on a response button.
    % 
    % mouseStartX = round( ...
    %     mean(T.windowRect([1 3])));
    % 
    % mouseStartY = round( ...
    %     mean(T.windowRect([2 4])));
    % 
    % 
    % SetMouse( ...
    %     mouseStartX, ...
    %     mouseStartY, ...
    %     T.window);


    %% ----------------------------------------------------------
    % Question Onset
    % -----------------------------------------------------------

    questionOnset = Screen('Flip', T.window);


    %% ----------------------------------------------------------
    % Collect One Response
    % -----------------------------------------------------------

    [response(question), RT(question)] = ...
        collectQuestionnaireResponse( ...
            T.window, ...
            responseBuffer, ...
            Layout, ...
            questionOnset, ...
            P.Questionnaire.duration, ...
            P.Questionnaire.Highlight);


    %% ----------------------------------------------------------
    % Close Cache
    % -----------------------------------------------------------

    Screen( ...
        'Close', ...
        responseBuffer);


end


end