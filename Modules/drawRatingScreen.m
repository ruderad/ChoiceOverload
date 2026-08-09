function drawRatingScreen(textureID, imageRect, rating, P, T)

%% ==============================================================
%  Clear Screen
%  ==============================================================

Screen('FillRect', T.window, P.Screen.backgroundColor);

%% ==============================================================
%  Draw Image
%  ==============================================================

Screen('DrawTexture', T.window, textureID, [], imageRect);

%% ==============================================================
%  Layout Geometry
%  ==============================================================

lineY = round(P.Preference.Layout.scaleYFraction * T.height);

scaleWidth = round(P.Preference.Layout.scaleWidthFraction * T.width);

x0 = round((T.width - scaleWidth) / 2);
x1 = x0 + scaleWidth;

majorTickHeight = round(P.Preference.Layout.majorTickHeightFraction * T.height);
minorTickHeight = round(P.Preference.Layout.minorTickHeightFraction * T.height);

labelOffset = round(P.Preference.Layout.labelOffsetFraction * T.height);

Screen('TextSize', T.window, P.Preference.Layout.fontSize);

%% ==============================================================
%  Draw Scale
%  ==============================================================

Screen('DrawLine', ...
    T.window, ...
    P.Preference.Layout.scaleColor, ...
    x0, lineY, ...
    x1, lineY, ...
    2);

%% ==============================================================
%  Draw Ruler
%  ==============================================================
values = P.Preference.min : ...
         P.Preference.step : ...
         P.Preference.max;

majorTickEvery = round( ...
    P.Preference.majorTickInterval / ...
    P.Preference.step);

for tickIndex = 1:numel(values)

    value = values(tickIndex);

    %----------------------------------------------------------
    % Position
    %----------------------------------------------------------

    tickPosition = normalizeScaleValue(value, P);

    x = x0 + tickPosition * scaleWidth;

    %----------------------------------------------------------
    % Major / Minor Tick
    %----------------------------------------------------------

    isMajorTick = mod(tickIndex - 1, majorTickEvery) == 0;

    if isMajorTick

        tickHeight = majorTickHeight;
        tickWidth  = P.Preference.Layout.majorTickWidth;

    else

        tickHeight = minorTickHeight;
        tickWidth  = P.Preference.Layout.minorTickWidth;

    end

    %----------------------------------------------------------
    % Draw Tick
    %----------------------------------------------------------

    Screen('DrawLine', ...
        T.window, ...
        P.Preference.Layout.tickColor, ...
        x, lineY - tickHeight, ...
        x, lineY + tickHeight, ...
        tickWidth);

    %----------------------------------------------------------
    % Draw Label
    %----------------------------------------------------------

    if isMajorTick

        label = sprintf('%g', value);

        bounds = Screen('TextBounds', ...
            T.window, ...
            label);

        textX = round(x - RectWidth(bounds) / 2);

        DrawFormattedText( ...
            T.window, ...
            label, ...
            textX, ...
            lineY + labelOffset, ...
            P.Screen.textColor);

    end

end

%% ==============================================================
%  Draw Slider
%  ==============================================================

sliderPosition = normalizeScaleValue(rating, P);
sliderX = x0 + sliderPosition * scaleWidth;

sliderHeight = round(P.Preference.Layout.sliderHeightFraction * T.height);

Screen('FillRect', ...
    T.window, ...
    P.Preference.Layout.sliderColor, ...
    [sliderX - P.Preference.Layout.sliderWidth/2,...
     lineY - sliderHeight,...
     sliderX + P.Preference.Layout.sliderWidth/2,...
     lineY + sliderHeight]);

%% ==============================================================
%  Instructions
%  ==============================================================
% instructionText = sprintf('LEFT / RIGHT     Move Slider\nSPACE           Confirm');
% 
% DrawFormattedText( ...
%     T.window, ...
%     instructionText, ...
%     'center', ...
%     round(P.Preference.Layout.instructionsYFraction * T.height), ...
%     P.Screen.textColor);

%% ==============================================================
%  Progress Bar
%  ==============================================================

progressWidth = round(P.Preference.Layout.progressWidthFraction * T.width);

progressX = round((T.width - progressWidth) / 2);

progressY = round(P.Preference.Layout.progressYFraction * T.height);

% Screen('FrameRect', ...
%     T.window, ...
%     P.Screen.textColor, ...
%     [progressX ...
%      progressY ...
%      progressX + progressWidth ...
%      progressY + P.Preference.Layout.progressHeight], ...
%     2);
% 
% Screen('FillRect', ...
%     T.window, ...
%     P.Preference.Layout.progressColor, ...
%     [progressX ...
%      progressY ...
%      progressX + progressWidth * T.progress ...
%      progressY + P.Preference.Layout.progressHeight]);

DrawFormattedText( ...
    T.window, ...
    sprintf('%d%% Completed', round(T.progress * 100)), ...
    'center', ...
    progressY - 15, ...
    P.Screen.textColor);

%% ==============================================================
%  Flip
%  ==============================================================

Screen('Flip', T.window);

end