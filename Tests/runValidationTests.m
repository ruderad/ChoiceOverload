function runValidationTests(P)


fprintf("\nRunning validation tests...\n\n");


%% Test 1
fprintf("Test 1: Valid log... ");

Log = generateFakeLog(P);

Report = validateEventLog(P,Log);


assert(Report.pass==true);

fprintf("PASS\n");



%% Test 2
fprintf("Test 2: Unknown event code... ");

BadLog = Log;

BadLog.Events.code(1)=999;


Report = validateEventLog(P,BadLog);


assert(Report.pass==false);

fprintf("PASS\n");



%% Test 3
fprintf("Test 3: Wrong exposure trigger... ");

BadLog = Log;

BadLog.Choice.blocks(1).trials(1).exposure.code = 999;


Report = validateEventLog(P,BadLog);


assert(Report.pass==false);

fprintf("PASS\n");



%% Test 4
fprintf("Test 4: Response before onset... ");

BadLog = Log;

BadLog.Choice.blocks(1).trials(1).response.timestamp = ...
BadLog.Choice.blocks(1).trials(1).responseOnset.timestamp - 1;


Report = validateEventLog(P,BadLog);


assert(Report.pass==false);

fprintf("PASS\n");



fprintf("\nAll validation tests passed.\n\n");


end