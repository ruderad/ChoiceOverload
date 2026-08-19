function Layout = makeQuestionnaireLayout(P)

% makeQuestionnaireLayout
%
% Generate the normalized spatial layout for one questionnaire trial.
%
% Each questionnaire trial contains:
%
%       Q0 instruction image
%
%       current question image
%
%       rating buttons: 1 ... nScalePoints
%
% The same layout is reused for every questionnaire question.
%
% All coordinates are normalized relative to screen center:
%
%       x = -0.5 ... +0.5
%       y = -0.5 ... +0.5
%
% The number of response buttons is determined entirely by:
%
%       P.Questionnaire.nScalePoints
%
% Therefore the layout supports 7-point, 9-point, or other scale
% lengths without changing this function.


L = P.Questionnaire.Layout;

nScalePoints = P.Questionnaire.nScalePoints;


%% ==============================================================
% Validate Scale
% ==============================================================

if nScalePoints < 2

    error( ...
        'P.Questionnaire.nScalePoints must be at least 2.');

end


%% ==============================================================
% Question Image Aspect Ratio
% ==============================================================

imageAspectRatio = ...
    P.Questionnaire.imageWidth / ...
    P.Questionnaire.imageHeight;


questionHeight = ...
    L.questionWidth / imageAspectRatio;


%% ==============================================================
% General Instruction Region
% ==============================================================

Layout.instruction = [ ...
    -L.instructionWidth / 2, ...
     L.instructionY - L.instructionHeight / 2, ...
     L.instructionWidth / 2, ...
     L.instructionY + L.instructionHeight / 2];


%% ==============================================================
% Current Question Region
% ==============================================================

Layout.question = [ ...
    -L.questionWidth / 2, ...
     L.questionY - questionHeight / 2, ...
     L.questionWidth / 2, ...
     L.questionY + questionHeight / 2];


%% ==============================================================
% Rating Buttons
% ==============================================================

% One rectangle per possible response:
%
%       Layout.button(1, :) = response 1
%       Layout.button(2, :) = response 2
%       ...
%       Layout.button(N, :) = response N

Layout.button = zeros( ...
    nScalePoints, ...
    4);


%% --------------------------------------------------------------
% Check Available Horizontal Space
% ---------------------------------------------------------------

% Button centers are evenly distributed across scaleWidth.
%
% Ensure that the requested number of buttons can physically fit
% without overlap.

minimumRequiredWidth = ...
    nScalePoints * L.buttonWidth;


if minimumRequiredWidth > L.scaleWidth

    error( ...
        ['Questionnaire scale is too narrow for %d buttons. ' ...
         'Increase P.Questionnaire.Layout.scaleWidth or reduce ' ...
         'buttonWidth.'], ...
        nScalePoints);

end


%% --------------------------------------------------------------
% Button Centers
% ---------------------------------------------------------------

firstButtonX = ...
    -L.scaleWidth / 2 + ...
    L.buttonWidth / 2;


lastButtonX = ...
     L.scaleWidth / 2 - ...
     L.buttonWidth / 2;


buttonCentersX = linspace( ...
    firstButtonX, ...
    lastButtonX, ...
    nScalePoints);


%% --------------------------------------------------------------
% Construct Button Rectangles
% ---------------------------------------------------------------

for scalePoint = 1:nScalePoints

    buttonX = buttonCentersX(scalePoint);


    Layout.button(scalePoint, :) = [ ...
        buttonX - L.buttonWidth / 2, ...
        L.buttonY - L.buttonHeight / 2, ...
        buttonX + L.buttonWidth / 2, ...
        L.buttonY + L.buttonHeight / 2];

end


end