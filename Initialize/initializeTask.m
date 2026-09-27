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
%% ==============================================================

screens = Screen('Screens');
screenNumber = max(screens);

[T.window, T.windowRect] = Screen( ...
    'OpenWindow', ...
    screenNumber, ...
    P.Screen.backgroundColor);

%% ==============================================================
%  Screen Properties
%% ==============================================================

[T.width, T.height] = Screen('WindowSize', T.window);

T.centerX = T.width / 2;
T.centerY = T.height / 2;

T.ifi = Screen('GetFlipInterval', T.window);

T.frameRate = 1 / T.ifi;

%% ==============================================================
%  Audio (PsychPortAudio)
%% ==============================================================

T.audio.enabled = false;   % flipped to true only if setup succeeds

try
    InitializePsychSound(1);   % 1 = low-latency mode

    T.audio.freq     = P.Audio.freq;
    T.audio.channels = 1;      % mono

    T.audio.handle = PsychPortAudio('Open', ...
        [], ...                % [] = default output device
        1, ...                 % mode: 1 = playback only
        1, ...                 % low-latency requested
        T.audio.freq, ...
        T.audio.channels);

    % --- Pre-generate the beep waveform (once per session) ---
    beepDur  = P.Audio.beepDuration;
    beepFreq = P.Audio.beepFrequency;

    t = 0 : 1/T.audio.freq : beepDur - 1/T.audio.freq;

    % Hann envelope: smooth 0 -> 1 -> 0, no clicks
    envelope = 0.5 * (1 - cos(2*pi*t / beepDur));

    tone = P.Audio.beepAmplitude * envelope .* sin(2*pi*beepFreq*t);

    T.audio.beepBuffer = tone;   % mono: 1 x N

    PsychPortAudio('FillBuffer', T.audio.handle, T.audio.beepBuffer);

    T.audio.enabled = true;

catch ME
    warning('initializeTask:audioFailed', ...
        'Audio setup failed (%s). Task will run silently.', ME.message);
    T.audio.enabled = false;
    if isfield(T.audio, 'handle') && ~isempty(T.audio.handle)
        try
            PsychPortAudio('Close', T.audio.handle);
        catch
        end
        T.audio.handle = [];
    end
end

%% ==============================================================
%  Keyboard
%% ==============================================================

ListenChar(2);

%% ==============================================================
%  Cursor
%% ==============================================================

HideCursor;

%% ==============================================================
%  Progress
%% ==============================================================

T.progress = 0;

end