function runValidationTests(P)

fprintf("\n============================\n");
fprintf("Choice Overload Validation Tests\n");
fprintf("============================\n\n");



%% --------------------------------------------------------------
% Test 1
% Valid experiment
% --------------------------------------------------------------

fprintf("Test 1: Valid log ........ ");


file = generateFakeEventLog(P);


Log = parseEventLog(file);


Report = validateEventLog(P,Log);



assert(Report.pass==true,...
    "Valid log failed validation");


fprintf("PASS\n");





%% --------------------------------------------------------------
% Test 2
% Unknown event code
% --------------------------------------------------------------

fprintf("Test 2: Unknown event .... ");


BadLog = Log;


BadLog.Events.code(1)=999;



Report = validateEventLog(P,BadLog);



assert(Report.pass==false,...
    "Unknown event was not detected");


fprintf("PASS\n");





%% --------------------------------------------------------------
% Test 3
% Wrong exposure trigger
% --------------------------------------------------------------

fprintf("Test 3: Exposure trigger . ");



BadLog = Log;


BadLog.Choice.blocks(1).trials(1).exposure.code = 999;



Report = validateEventLog(P,BadLog);



assert(Report.pass==false,...
    "Wrong exposure was not detected");


fprintf("PASS\n");





%% --------------------------------------------------------------
% Test 4
% Response before onset
% --------------------------------------------------------------

fprintf("Test 4: Timing error ..... ");


BadLog = Log;


BadLog.Choice.blocks(1).trials(1).response.timestamp = ...
BadLog.Choice.blocks(1).trials(1).responseOnset.timestamp - 1;



Report = validateEventLog(P,BadLog);



assert(Report.pass==false,...
    "Timing error was not detected");


fprintf("PASS\n");





%% --------------------------------------------------------------
% Test 5
% Acquisition state and debug cleanup
% --------------------------------------------------------------

fprintf("Test 5: Acquisition state  ");

testAcquisitionContracts();

fprintf("PASS\n");


fprintf("\n============================\n");
fprintf("ALL TESTS PASSED\n");
fprintf("============================\n\n");


end