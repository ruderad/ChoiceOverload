function [rating, RT] = collectSliderResponse(textureID, imageRect, P, T)

%% Initial slider position

rating = P.Preference.start;

% Draw initial screen
drawRatingScreen(textureID, imageRect, rating, P, T);

startTime = GetSecs;

%% Response loop

while true

    [keyIsDown, ~, keyCode] = KbCheck;

    if ~keyIsDown
        continue;
    end

    if keyCode(KbName('LeftArrow'))

        rating = max(P.Preference.min, ...
             rating - P.Preference.step);

        drawRatingScreen(textureID, imageRect, rating, P, T);

        KbReleaseWait;

    elseif keyCode(KbName('RightArrow'))

        rating = min(P.Preference.max, ...
             rating + P.Preference.step);

        drawRatingScreen(textureID, imageRect, rating, P, T);

        KbReleaseWait;

    elseif keyCode(KbName('space'))

        RT = GetSecs - startTime;

        KbReleaseWait;

        break;

    elseif keyCode(KbName('ESCAPE'))

        Screen('CloseAll');
        error('Experiment terminated by user.');

    end

end

end