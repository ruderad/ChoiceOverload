function eventCode = getChoiceExposureCode(P, setSize, condition)

% getChoiceExposureCode
%
% Return the EEG event code corresponding to a specific
% Choice Set Size x Condition combination.
%
% Inputs:
%
%   P
%       Parameter structure containing:
%
%           P.Choice.setSizes
%           P.Events.Choice.conditions
%           P.Events.Choice.exposure
%
%   setSize
%       Current choice-set size.
%
%   condition
%       Current experimental condition:
%
%           UL
%           UM
%           UH
%           CF
%           RS
%
% Output:
%
%   eventCode
%       Numeric EEG event code for the current choice exposure.


%% ==============================================================
% Resolve Set Size
% ==============================================================

setSizeIndex = find( ...
    P.Choice.setSizes == setSize, ...
    1);


if isempty(setSizeIndex)

    error( ...
        'Unknown choice set size: %g', ...
        setSize);

end


%% ==============================================================
% Resolve Condition
% ==============================================================

condition = string(condition);


conditionIndex = find( ...
    P.Events.Choice.conditions == condition, ...
    1);


if isempty(conditionIndex)

    error( ...
        'Unknown choice condition: %s', ...
        condition);

end


%% ==============================================================
% Return Event Code
% ==============================================================

eventCode = ...
    P.Events.Choice.exposure( ...
        setSizeIndex, ...
        conditionIndex);


end