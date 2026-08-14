function [response, RT] = collectChoiceResponse( ...
    window, Layout, stimulusLocations)

% collectChoiceResponse  Collect a mouse click on a stimulus.
%
%   [response, RT] = collectChoiceResponse( ...
%       window, Layout, stimulusLocations)
%
%   Waits for the participant to click one of the stimulus locations.
%   Clicks on masked locations are ignored.
%
%   Inputs:
%       window           - Psychtoolbox window pointer.
%       Layout           - Pixel-based choice-task layout.
%       stimulusLocations - Indices of locations containing stimuli.
%
%   Outputs:
%       response - Index of the clicked stimulus location.
%       RT       - Response time in seconds.
%
%   The function only collects the mouse response. It does not determine
%   which stimulus occupies the selected location or modify R.


startTime = GetSecs;

response = [];


while isempty(response)

    [x, y, buttons] = GetMouse(window);

    if any(buttons)

        for i = stimulusLocations

            if IsInRect(x, y, Layout.rect(i, :))

                response = i;
                break

            end

        end

    end

end


RT = GetSecs - startTime;

end