function saveResults(R, resultsPath)
% saveResults
%
% Saves the complete results structure for one participant.
%
% INPUT
%   R       - Results structure
%   resultsPath - Canonical results directory
%
% Results are saved as:
%
%   <resultsPath>/<SubjectID>.mat
%
% -------------------------------------------------------------------------

%% Data directory

dataDir = resultsPath;

if ~exist(dataDir, 'dir')
    mkdir(dataDir);
end

%% File name

filename = [R.Subject.ID '.mat'];

filepath = fullfile(dataDir, filename);

%% Save

save(filepath, 'R');

end

