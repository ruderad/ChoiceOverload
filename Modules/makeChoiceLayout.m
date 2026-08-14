function Layout = makeChoiceLayout(P)

% makeChoiceLayout  Generate the fixed spatial layout for the choice task.
%
%   Layout = makeChoiceLayout(P)
%
%   Generates the fixed 30-location spatial layout used by the choice
%   task. The layout consists of 6 columns and 5 rows, with the stimulus
%   regions symmetrically distributed around a central fixation region.
%
%   All coordinates are normalized to the screen:
%       x = -0.5 ... +0.5
%       y = -0.5 ... +0.5
%
%   Inputs:
%       P       - Parameter structure containing Choice.Layout settings.
%
%   Output:
%       Layout  - Structure containing:
%                   .rect      30 × 4 matrix of stimulus rectangles
%                   .fixation  1 × 4 fixation rectangle
%
%   Rectangle format:
%       [left top right bottom]
%
%   The function only defines spatial geometry. It does not assign
%   stimuli, conditions, set sizes, or masks to locations.


L = P.Choice.Layout;


%% Screen regions

screenLeft  = -0.5;
screenRight =  0.5;

leftEdge   = screenLeft;
leftCenter  = -L.centerWidth / 2;

rightCenter = L.centerWidth / 2;
rightEdge   = screenRight;


%% Horizontal positions

nColumnsPerSide = L.nColumns / 2;

leftCenters = linspace( ...
    leftEdge + L.imageWidth / 2, ...
    leftCenter - L.imageWidth / 2, ...
    nColumnsPerSide);

rightCenters = linspace( ...
    rightCenter + L.imageWidth / 2, ...
    rightEdge - L.imageWidth / 2, ...
    nColumnsPerSide);

x = [leftCenters, rightCenters];


%% Vertical positions

screenTop    =  0.5;
screenBottom = -0.5;

y = linspace( ...
    screenTop - L.imageHeight / 2, ...
    screenBottom + L.imageHeight / 2, ...
    L.nRows);


%% Stimulus rectangles

nLocations = L.nColumns * L.nRows;

Layout.rect = zeros(nLocations, 4);

index = 1;

for row = 1:L.nRows

    for column = 1:L.nColumns

        Layout.rect(index, :) = [ ...
            x(column) - L.imageWidth / 2, ...
            y(row)    - L.imageHeight / 2, ...
            x(column) + L.imageWidth / 2, ...
            y(row)    + L.imageHeight / 2];

        index = index + 1;

    end

end

%% Fixation tile

fixationSize = L.imageWidth;

Layout.fixation = [ ...
    -fixationSize / 2, ...
    -fixationSize / 2, ...
     fixationSize / 2, ...
     fixationSize / 2];


%% Fixation cross

crossSize = L.fixationCrossSize;

Layout.fixationCross.horizontal = [ ...
    -crossSize / 2, ...
     0, ...
     crossSize / 2, ...
     0];

Layout.fixationCross.vertical = [ ...
     0, ...
    -crossSize / 2, ...
     0, ...
     crossSize / 2];


end