function drawQuestionnaire(P, T, Layout, questionFiles, response)

% drawQuestionnaire  Draw the questionnaire screen.
%
%   drawQuestionnaire(P, T, Layout, questionFiles, response)
%
%   Draws:
%       - General questionnaire instruction
%       - Question images
%       - Likert response buttons
%       - Selected-response highlights
%
%   Inputs:
%       P             - Parameter structure.
%       T             - Task structure.
%       Layout        - Pixel-based questionnaire layout.
%       questionFiles - Cell array containing:
%                           Q0 = general instruction
%                           Q1...Qn = question images
%       response      - 1 x nQuestions vector.
%                       NaN indicates no response yet.


%% ==============================================================
% Background
% ==============================================================

Screen( ...
    'FillRect', ...
    T.window, ...
    P.Screen.backgroundColor);


%% ==============================================================
% General Instruction
% ==============================================================

[textureID, imageWidth, imageHeight] = ...
    readimg( ...
        questionFiles{1}, ...
        T.window);


% Determine the largest scale that fits the image inside the
% instruction rectangle while preserving its aspect ratio.
scale = min( ...
    (Layout.instruction(3) - Layout.instruction(1)) / imageWidth, ...
    (Layout.instruction(4) - Layout.instruction(2)) / imageHeight);


drawWidth  = imageWidth  * scale;
drawHeight = imageHeight * scale;


instructionRect = CenterRectOnPoint( ...
    [0 0 drawWidth drawHeight], ...
    mean(Layout.instruction([1 3])), ...
    mean(Layout.instruction([2 4])));


Screen( ...
    'DrawTexture', ...
    T.window, ...
    textureID, ...
    [], ...
    instructionRect);


% Texture is no longer needed after it has been queued for drawing.
Screen('Close', textureID);


%% ==============================================================
% Questions
% ==============================================================

for question = 1:P.Questionnaire.nQuestions


    %% ----------------------------------------------------------
    % Question Image
    % -----------------------------------------------------------

    [textureID, imageWidth, imageHeight] = ...
        readimg( ...
            questionFiles{question + 1}, ...
            T.window);


    scale = min( ...
        (Layout.question(question, 3) - ...
         Layout.question(question, 1)) / imageWidth, ...
        ...
        (Layout.question(question, 4) - ...
         Layout.question(question, 2)) / imageHeight);


    drawWidth  = imageWidth  * scale;
    drawHeight = imageHeight * scale;


    questionRect = CenterRectOnPoint( ...
        [0 0 drawWidth drawHeight], ...
        mean(Layout.question(question, [1 3])), ...
        mean(Layout.question(question, [2 4])));


    Screen( ...
        'DrawTexture', ...
        T.window, ...
        textureID, ...
        [], ...
        questionRect);


    Screen('Close', textureID);


    %% ----------------------------------------------------------
    % Response Buttons
    % -----------------------------------------------------------

    for scalePoint = 1:P.Questionnaire.nScalePoints


        % Layout.button is stored as:
        %
        %   question x scalePoint x rectangleCoordinate
        %
        % Convert the selected rectangle into a 1 x 4 vector.
        rect = Layout.button( ...
            question, ...
            scalePoint, ...
            :);

        rect = rect(:)';


        %% ------------------------------------------------------
        % Normal Button Border
        % -------------------------------------------------------

        Screen( ...
            'FrameRect', ...
            T.window, ...
            P.Screen.textColor, ...
            rect, ...
            P.Questionnaire.Layout.buttonBorderWidth);


        %% ------------------------------------------------------
        % Button Number
        % -------------------------------------------------------

        % DrawFormattedText argument order:
        %
        %   win
        %   text
        %   sx
        %   sy
        %   color
        %   wrapat
        %   flipHorizontal
        %   flipVertical
        %   vSpacing
        %   righttoleft
        %   winRect
        %
        % The empty righttoleft argument is important.
        % Without it, rect is interpreted as the righttoleft flag.

        DrawFormattedText( ...
            T.window, ...
            num2str(scalePoint), ...
            'center', ...
            'center', ...
            P.Screen.textColor, ...
            [], ...    % wrapat
            [], ...    % flipHorizontal
            [], ...    % flipVertical
            [], ...    % vSpacing
            [], ...    % righttoleft
            rect);     % winRect


        %% ------------------------------------------------------
        % Highlight Selected Response
        % -------------------------------------------------------

        if ~isnan(response(question)) && ...
                response(question) == scalePoint


            Screen( ...
                'FrameRect', ...
                T.window, ...
                P.Questionnaire.Layout.selectedColor, ...
                rect, ...
                P.Questionnaire.Layout.selectedBorderWidth);


        end


    end


end


end