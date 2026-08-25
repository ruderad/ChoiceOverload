function testAcquisitionContracts()
% testAcquisitionContracts
%
% Verify acquisition state and debug cleanup without hardware.

root = tempname;
mkdir(root);

cleanupObject = onCleanup(@() cleanupTestFiles(root));

P = struct();

P.Debug.enabled = true;
P.Experiment.root = root;
P.Results.path = fullfile(root, 'Data');

P.Acquisition.EventLog.enabled = true;
P.Acquisition.EventLog.folder = fullfile(root, 'Logs');

P.Acquisition.EEG.enabled = true;
P.Acquisition.EEG.Acquisition = true;
P.Acquisition.EEG.PreferenceRating = false;
P.Acquisition.EEG.Choice = true;

P.Acquisition.EyeTracker.enabled = true;
P.Acquisition.EyeTracker.Acquisition = true;
P.Acquisition.EyeTracker.PreferenceRating = true;
P.Acquisition.EyeTracker.Choice = true;

Subject.ID = 'TEST01';

T = struct();

T = initializeAcquisition(P, T, Subject);

assert(~T.Acquisition.enabled);
assert(T.Acquisition.EventLog.active);
assert(~T.Acquisition.EEG.active);
assert(~T.Acquisition.EyeTracker.connected);
assert(~T.Acquisition.EyeTracker.calibrated);
assert(~T.Acquisition.EyeTracker.recording);

sendEvent(P, T, "Acquisition", "ACQUISITION_SYNC", 55);

logPath = T.Acquisition.EventLog.filepath;
assert(isfile(logPath));

T = cleanupAcquisition(P, T);

assert(~T.Acquisition.EventLog.active);
assert(isempty(eventLogger("filepath")));

logText = fileread(logPath);
assert(contains(logText, sprintf('\tAcquisition\t55\tACQUISITION_SYNC')));

clear cleanupObject;

end


function cleanupTestFiles(root)

eventLogger("close");

if isfolder(root)

    rmdir(root, 's');

end

end
