function trial = runChoiceTrial(P, T, ChoiceSet,condition, Layout)

% runChoiceTrial  Run one choice-task trial.
%
%   Presents one choice set, assigns its stimuli to spatial locations,
%   displays the choice screen, and collects the participant's mouse
%   response.
%
%   Inputs:
%       P         - Parameter structure.
%       T         - Task structure.
%       ChoiceSet - Image IDs belonging to the current trial.
%       Layout    - Pixel-based choice-task layout.
%
%   Output:
%       trial     - Structure containing:
%                       .choiceSet
%                       .positions
%                       .response
%                       .selectedImage
%                       .RT




%% Assign stimuli to spatial locations

setSize = numel(ChoiceSet);

positions = randomizeChoicePositions(Layout, setSize);


%% Draw choice set

drawChoiceSet( ...
    P, ...
    T, ...
    ChoiceSet, ...
    Layout, ...
    positions);


%% Present choice set

Screen('Flip', T.window);


%% Collect response

[response, RT] = collectChoiceResponse( ...
    T.window, ...
    Layout, ...
    positions.stimulus);


%% Determine selected image

selectedImage = ChoiceSet( ...
    find(positions.stimulus == response));


%% Store trial information

trial.choiceSet = ChoiceSet;
trial.condition = condition;
trial.positions = positions;
trial.response = response;
trial.selectedImage = selectedImage;
trial.RT = RT;

end