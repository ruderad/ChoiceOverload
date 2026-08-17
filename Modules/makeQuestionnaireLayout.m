function Layout = makeQuestionnaireLayout(P)

% makeQuestionnaireLayout  Generate the normalized questionnaire layout.
%
%   Layout = makeQuestionnaireLayout(P)
%
%   Defines the spatial geometry of the questionnaire screen.
%
%   The questionnaire contains:
%       - One general instruction image at the top
%       - Three vertically arranged question images
%       - A parametrically sized Likert response scale beneath each
%         question
%
%   All coordinates are normalized:
%       x = -0.5 ... +0.5
%       y = -0.5 ... +0.5
%
%   The question-image height is derived from the known image aspect
%   ratio, so the image dimensions themselves never enter the spatial
%   coordinate system.
%
%   The function only defines spatial geometry. It does not load images,
%   draw anything, or collect responses.


L = P.Questionnaire.Layout;


%% ==============================================================
% Image Aspect Ratio
% ==============================================================

imageAspectRatio = ...
    P.Questionnaire.imageWidth / ...
    P.Questionnaire.imageHeight;

questionHeight = ...
    L.questionWidth / imageAspectRatio;


%% ==============================================================
% General Instruction
% ==============================================================

Layout.instruction = [ ...
    -L.instructionWidth / 2, ...
     L.instructionY - L.instructionHeight / 2, ...
     L.instructionWidth / 2, ...
     L.instructionY + L.instructionHeight / 2];


%% ==============================================================
% Question Rows
% ==============================================================

Layout.question = zeros( ...
    P.Questionnaire.nQuestions, 4);

Layout.button = zeros( ...
    P.Questionnaire.nQuestions, ...
    P.Questionnaire.nScalePoints, 4);


for question = 1:P.Questionnaire.nQuestions

    %% Question image

    questionY = ...
        L.firstQuestionY - ...
        (question - 1) * L.rowSpacing;

    Layout.question(question, :) = [ ...
        -L.questionWidth / 2, ...
        questionY - questionHeight / 2, ...
         L.questionWidth / 2, ...
        questionY + questionHeight / 2];


    %% Response buttons

    buttonY = ...
        questionY - questionHeight / 2 - ...
        L.questionResponseGap - ...
        L.buttonHeight / 2;

    totalWidth = ...
        P.Questionnaire.nScalePoints * L.buttonWidth + ...
        (P.Questionnaire.nScalePoints - 1) * L.buttonGap;

    firstButtonX = ...
        -totalWidth / 2 + L.buttonWidth / 2;


    for scalePoint = 1:P.Questionnaire.nScalePoints

        buttonX = ...
            firstButtonX + ...
            (scalePoint - 1) * ...
            (L.buttonWidth + L.buttonGap);

        Layout.button(question, scalePoint, :) = [ ...
            buttonX - L.buttonWidth / 2, ...
            buttonY - L.buttonHeight / 2, ...
            buttonX + L.buttonWidth / 2, ...
            buttonY + L.buttonHeight / 2];

    end

end

end