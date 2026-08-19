function Layout = convertQuestionnaireLayout(Layout, screenRect)

% convertQuestionnaireLayout
%
% Convert the normalized geometry produced by
% makeQuestionnaireLayout into Psychtoolbox pixel coordinates.
%
% Input:
%
%       Layout.instruction   1 x 4
%       Layout.question      1 x 4
%       Layout.button        N x 4
%
% Rectangle format:
%
%       [left top right bottom]
%
% Output:
%
%       Same structure converted to pixels.
%
% This function is independent of the number of questionnaire
% scale points.


%% ==============================================================
% Screen Geometry
% ==============================================================

screenLeft   = screenRect(1);
screenTop    = screenRect(2);

screenWidth  = ...
    screenRect(3) - screenRect(1);

screenHeight = ...
    screenRect(4) - screenRect(2);


screenCenterX = ...
    screenLeft + screenWidth / 2;

screenCenterY = ...
    screenTop + screenHeight / 2;


%% ==============================================================
% Instruction Region
% ==============================================================

Layout.instruction([1 3]) = ...
    Layout.instruction([1 3]) * ...
    screenWidth + ...
    screenCenterX;


Layout.instruction([2 4]) = ...
    Layout.instruction([2 4]) * ...
    screenHeight + ...
    screenCenterY;


%% ==============================================================
% Question Region
% ==============================================================

Layout.question([1 3]) = ...
    Layout.question([1 3]) * ...
    screenWidth + ...
    screenCenterX;


Layout.question([2 4]) = ...
    Layout.question([2 4]) * ...
    screenHeight + ...
    screenCenterY;


%% ==============================================================
% Rating Buttons
% ==============================================================

Layout.button(:, [1 3]) = ...
    Layout.button(:, [1 3]) * ...
    screenWidth + ...
    screenCenterX;


Layout.button(:, [2 4]) = ...
    Layout.button(:, [2 4]) * ...
    screenHeight + ...
    screenCenterY;


end