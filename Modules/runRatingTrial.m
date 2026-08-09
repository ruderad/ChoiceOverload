function [rating, RT] = runRatingTrial(filepath, P, T)

% Load image
[textureID, imageWidth, imageHeight] = readimg(filepath, T.window);

% Compute destination rectangle
scale = min( ...
    P.Screen.imageWidth / imageWidth, ...
    P.Screen.imageHeight / imageHeight);

drawWidth  = imageWidth  * scale;
drawHeight = imageHeight * scale;

imageRect = CenterRectOnPoint( ...
    [0 0 drawWidth drawHeight], ...
    T.centerX, ...
    T.height * P.Preference.Layout.imageCenterYFraction);

% Collect response
[rating, RT] = collectSliderResponse(textureID, imageRect, P, T);

% Free texture
Screen('Close', textureID);

% blank ITI
showBlankScreen(P.Timing.blankITI, P, T);

end