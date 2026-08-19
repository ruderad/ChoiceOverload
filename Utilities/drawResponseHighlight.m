function drawResponseHighlight( ...
    window, rect, color, borderWidth)

% drawResponseHighlight  Draw a response-state border.
%
%   drawResponseHighlight(window, rect, color, borderWidth)
%
%   Draws a rectangular border used to indicate:
%
%       Yellow = current hover / available response
%       Green  = confirmed response
%
%   The function is intentionally task-independent so it can also
%   be reused by the questionnaire response screens.
%
%   Inputs:
%       window      - Psychtoolbox window pointer.
%       rect        - Rectangle [left top right bottom].
%       color       - RGB border color.
%       borderWidth - Border thickness in pixels.


if isempty(rect)
    return;
end


% Ensure a standard 1 x 4 rectangle.
rect = rect(:)';


Screen( ...
    'FrameRect', ...
    window, ...
    color, ...
    rect, ...
    borderWidth);


end