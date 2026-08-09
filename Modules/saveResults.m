function saveResults(R, root)
% saveResults
%
% Saves the complete results structure for one participant.
%
% INPUT
%   R       - Results structure
%   root    - Experiment root directory
%
% Results are saved as:
%
%   <root>/data/<SubjectID>.mat
%
% -------------------------------------------------------------------------

%% Data directory

dataDir = fullfile(root, 'data');

if ~exist(dataDir, 'dir')
    mkdir(dataDir);
end

%% File name

filename = [R.Subject.ID '.mat'];

filepath = fullfile(dataDir, filename);

%% Save

save(filepath, 'R');

end

