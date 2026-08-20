function R = initializeResults(P)

%% ==============================================================
% Event Codebook
% ==============================================================

% Store the exact event-marker configuration used for this
% participant so EEG / eye-tracking data can always be decoded
% against the correct codebook.

R.Events = P.Events;

%% ==============================================================
%  Preference Rating Task
%  ==============================================================

for round = 1:P.Preference.nRounds

    R.Preference.round(round).rating = ...
        nan(1, P.Images.nImages);

    R.Preference.round(round).RT = ...
        nan(1, P.Images.nImages);

    R.Preference.round(round).order = ...
        nan(1, P.Preference.nTrialsPerRound);

end

R.Preference.average = ...
    nan(1, P.Images.nImages);

%% ==============================================================
%  Choice Task
%  ==============================================================

nBlocks = numel(P.Choice.setSizes);

R.Choice.blockOrder = ...
    nan(1, nBlocks);

R.Choice.block = ...
    repmat(struct('trial', []), 1, nBlocks);

end