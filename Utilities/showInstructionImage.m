function showInstructionImage(imageFile, P, T)

% showInstructionImage
%
% Display an instruction image centered on screen and wait
% for a fresh mouse click anywhere on the screen.
%
% The image is scaled automatically while preserving aspect ratio.
%
% ESCAPE terminates the experiment.


%% ==============================================================
% Validate File
% ==============================================================

if ~isfile(imageFile)

    error( ...
        'Instruction image not found: %s', ...
        imageFile);

end


%% ==============================================================
% Load Image
% ==============================================================

[textureID, imageWidth, imageHeight] = ...
    readimg(imageFile, T.window);


%% ==============================================================
% Screen Geometry
% ==============================================================

screenWidth = ...
    T.windowRect(3) - T.windowRect(1);

screenHeight = ...
    T.windowRect(4) - T.windowRect(2);


screenCenterX = ...
    mean(T.windowRect([1 3]));

screenCenterY = ...
    mean(T.windowRect([2 4]));


%% ==============================================================
% Scale Image
% ==============================================================

scale = min( ...
    screenWidth / imageWidth, ...
    screenHeight / imageHeight);


drawWidth = ...
    imageWidth * scale;

drawHeight = ...
    imageHeight * scale;


destinationRect = ...
    CenterRectOnPoint( ...
        [0 0 drawWidth drawHeight], ...
        screenCenterX, ...
        screenCenterY);


%% ==============================================================
% Draw
% ==============================================================

Screen( ...
    'FillRect', ...
    T.window, ...
    P.Screen.backgroundColor);


Screen( ...
    'DrawTexture', ...
    T.window, ...
    textureID, ...
    [], ...
    destinationRect);


ShowCursor('Arrow');

Screen('Flip', T.window);


Screen( ...
    'Close', ...
    textureID);


%% ==============================================================
% Ignore Any Existing Mouse Press
% ==============================================================

[~, ~, buttons] = GetMouse(T.window);


while any(buttons)

    WaitSecs(0.001);

    [~, ~, buttons] = GetMouse(T.window);

end


%% ==============================================================
% Wait for Fresh Mouse Click
% ==============================================================

while true

    [~, ~, buttons] = GetMouse(T.window);


    if any(buttons)

        % Wait for release so this click cannot carry into
        % the following task.

        while any(buttons)

            WaitSecs(0.001);

            [~, ~, buttons] = GetMouse(T.window);

        end

        break;

    end


    %% Emergency Escape

    [keyIsDown, ~, keyCode] = KbCheck;


    if keyIsDown && keyCode(KbName('ESCAPE'))

        Screen('CloseAll');

        error( ...
            'Experiment terminated by user.');

    end


    WaitSecs(0.001);

end


HideCursor;


end