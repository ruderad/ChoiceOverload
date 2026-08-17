function [response, RT] = collectChoiceResponse( ...
    window, Layout, choiceOnset, choiceDuration)

% collectChoiceResponse  Collect a mouse click during the choice period.
%
%   [response, RT] = collectChoiceResponse( ...
%       window, Layout, choiceOnset, choiceDuration)
%
%   Waits for a mouse click on one of the choice cells.
%
%   If no valid response is made before choiceDuration expires,
%   response is returned as [] and RT as NaN.


response = [];
RT = NaN;


%% Collect response

while isempty(response)

    [x, y, buttons] = GetMouse(window);

    if any(buttons)

        for i = 1:size(Layout.rect, 1)

            if IsInRect(x, y, Layout.rect(i, :))

                response = i;
                RT = GetSecs - choiceOnset;

                break;

            end

        end

    end


    %% Timeout

    if GetSecs - choiceOnset >= choiceDuration
        break;
    end

end

end