function T = initializeTask(P)

%% ==============================================================
%  Psychtoolbox Setup
%  ==============================================================

PsychDefaultSetup(2);
KbName('UnifyKeyNames');

if P.Debug.enabled
    Screen('Preference', 'SkipSyncTests', 1);
end

Screen('Preference', 'VisualDebugLevel', 3);

%% ==============================================================
%  Open Window
%  ==============================================================

screens = Screen('Screens');
screenNumber = max(screens);

[T.window, T.windowRect] = Screen( ...
    'OpenWindow', ...
    screenNumber, ...
    P.Screen.backgroundColor);

%% ==============================================================
%  Screen Properties
%  ==============================================================

[T.width, T.height] = Screen('WindowSize', T.window);

T.centerX = T.width / 2;
T.centerY = T.height / 2;

T.ifi = Screen('GetFlipInterval', T.window);

T.frameRate = 1 / T.ifi;

%% ==============================================================
%  Keyboard
%  ==============================================================

ListenChar(2);

%% ==============================================================
%  Cursor
%  ==============================================================

HideCursor;

%% ==============================================================
%  Progress
%  ==============================================================

T.progress = 0;

end