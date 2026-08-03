function showBlankScreen(duration, P, T)
%SHOWBLANKSCREEN Display a blank screen for a fixed duration.
%
%   showBlankScreen(duration, P, T)
%
%   Clears the display using the experiment background color,
%   flips the screen, and waits for the specified duration.
%
%   INPUTS
%       duration : Blank interval in seconds.
%       P        : Parameter structure.
%       T        : Task structure.
%
%   OUTPUTS
%       None.
%
%   EXAMPLE
%
%       showBlankScreen(P.Timing.blankITI, P, T);

if duration <= 0
    return;
end

Screen('FillRect', ...
    T.window, ...
    P.Screen.backgroundColor);

Screen('Flip', T.window);

WaitSecs(duration);

end