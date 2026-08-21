function filepath = generateFakeEventLog(P)

% generateFakeEventLog
%
% Creates a minimal valid raw event log.
% The parser should be able to reconstruct it.


filepath = "fake_validation_log.tsv";


fid = fopen(filepath,'w');


% Metadata

fprintf(fid,...
"# subject\tTEST\n");


fprintf(fid,...
"# session\t001\n");


% Header

fprintf(fid,...
"timestamp\ttask\tcode\tevent\n");



time = 0;



%% Experiment start

time=time+1;

fprintf(fid,...
"%f\tExperiment\t%d\tEXP_START\n",...
time,...
P.Events.Experiment.start);



%% Choice block

time=time+1;

fprintf(fid,...
"%f\tChoice\t%d\tCHOICE_BLOCK_START block=1 setSize=24\n",...
time,...
P.Events.Choice.blockStart);



%% Choice trial

condition = "UL";

exposureCode = ...
    getChoiceExposureCode(P,24,condition);



% fixation

time=time+1;

fprintf(fid,...
"%f\tChoice\t%d\tFIXATION\n",...
time,...
P.Events.Choice.fixation);



% exposure

time=time+1;

fprintf(fid,...
"%f\tChoice\t%d\tCHOICE_EXPOSURE setSize=24 condition=%s\n",...
time,...
exposureCode,...
condition);



% mask

time=time+1;

fprintf(fid,...
"%f\tChoice\t%d\tMASK\n",...
time,...
P.Events.Choice.mask);



% response onset

time=time+1;

fprintf(fid,...
"%f\tChoice\t%d\tRESPONSE_ONSET\n",...
time,...
P.Events.Choice.responseOnset);



% response

time=time+1;

fprintf(fid,...
"%f\tChoice\t%d\tRESPONSE\n",...
time,...
P.Events.Choice.response);



%% End

time=time+1;

fprintf(fid,...
"%f\tChoice\t%d\tCHOICE_BLOCK_END\n",...
time,...
P.Events.Choice.blockEnd);



fclose(fid);


end