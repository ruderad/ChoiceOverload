function [response, RT] = collectChoiceResponse( ...
    window, Layout, stimulusLocations, ...
    choiceOnset, choiceDuration)

% collectChoiceResponse  Collect a mouse response during the choice period.
%
%   [response, RT] = collectChoiceResponse( ...
%       window, Layout, stimulusLocations, ...
%       choiceOnset, choiceDuration)
%
%   Only clicks on locations that contain stimuli are accepted.
%
%   If no valid response occurs before choiceDuration expires:
%
%       response = []
%       RT       = NaN
%
%   Inputs:
%       window            - Psychtoolbox window pointer.
%       Layout            - Pixel-based choice-task layout.
%       stimulusLocations - Indices of locations containing stimuli.
%       choiceOnset       - Choice-screen onset timestamp.
%       choiceDuration    - Maximum choice-response duration.
%
%   Outputs:
%       response          - Selected spatial location index.
%       RT                - Response time in seconds.


%% ==============================================================
% Initialize
% ==============================================================

response = [];
RT = NaN;


%% ==============================================================
% Collect Response
% ==============================================================

while isempty(response)

    % Check timeout before reading another response.
    if GetSecs - choiceOnset >= choiceDuration
        break;
    end


    [x, y, buttons] = GetMouse(window);


    if any(buttons)

        % Only occupied stimulus locations are valid choices.
        for i = stimulusLocations

            if IsInRect( ...
                    x, ...
                    y, ...
                    Layout.rect(i, :))

                response = i;
                RT = GetSecs - choiceOnset;

                break;

            end

        end

    end

end


%% ==============================================================
% Wait for Mouse Release
% ==============================================================

% Prevent the choice click from carrying into the questionnaire.
if ~isempty(response)

    [~, ~, buttons] = GetMouse(window);

    while any(buttons)

        WaitSecs(0.001);

        [~, ~, buttons] = GetMouse(window);

    end

end


end