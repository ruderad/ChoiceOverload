function output = eventLogger(action, varargin)

% eventLogger
%
% Persistent development event logger.
%
% The logger records every event routed through sendEvent(...)
% without requiring EEG or eye-tracking hardware.
%
%
% Usage:
%
%   filepath = eventLogger( ...
%       "initialize", ...
%       P, ...
%       Subject);
%
%
%   eventLogger( ...
%       "write", ...
%       taskName, ...
%       eventName, ...
%       eventCode);
%
%
%   eventLogger("close");
%
%
% Output format:
%
%   timestamp_sec    task    code    event
%
%
% The timestamp is generated using Psychtoolbox GetSecs at the
% moment sendEvent routes the event to the logger.
%
% NOTE:
%
% This timestamp represents event-routing time.
%
% It does NOT replace the Screen('Flip') timestamps used internally
% by the behavioral task for RT and stimulus timing.


persistent Logger


output = [];


action = ...
    string(action);


%% ==============================================================
% Action
% ==============================================================

switch action


    %% ----------------------------------------------------------
    % Initialize
    % -----------------------------------------------------------

    case "initialize"


        P = ...
            varargin{1};


        Subject = ...
            varargin{2};


        %% Close Any Stale Logger

        if ~isempty(Logger) && ...
                isfield(Logger, 'fid') && ...
                Logger.fid > 0

            fclose( ...
                Logger.fid);

        end


        Logger = [];


        %% ------------------------------------------------------
        % Log Folder
        % -------------------------------------------------------

        logFolder = ...
            P.Acquisition.EventLog.folder;


        if ~isfolder(logFolder)

            mkdir( ...
                logFolder);

        end


        %% ------------------------------------------------------
        % Safe Subject ID
        % -------------------------------------------------------

        subjectID = ...
            char(string(Subject.ID));


        subjectID = ...
            strtrim(subjectID);


        subjectID = regexprep( ...
            subjectID, ...
            '[^A-Za-z0-9_-]', ...
            '_');


        if isempty(subjectID)

            subjectID = ...
                'unknown';

        end


        %% ------------------------------------------------------
        % Session Timestamp
        % -------------------------------------------------------

        sessionStamp = char( ...
            datetime( ...
                'now', ...
                'Format', ...
                'yyyyMMdd_HHmmss_SSS'));


        %% ------------------------------------------------------
        % File Path
        % -------------------------------------------------------

        fileName = sprintf( ...
            '%s_events_%s.tsv', ...
            subjectID, ...
            sessionStamp);


        filePath = ...
            fullfile( ...
                logFolder, ...
                fileName);


        %% ------------------------------------------------------
        % Open File
        % -------------------------------------------------------

        [fid, message] = fopen( ...
            filePath, ...
            'w');


        if fid == -1

            error( ...
                'Could not create event log: %s', ...
                message);

        end


        %% ------------------------------------------------------
        % Metadata
        % -------------------------------------------------------

        fprintf( ...
            fid, ...
            '# Choice Overload Event Log\n');


        fprintf( ...
            fid, ...
            '# experiment_version\t%s\n', ...
            P.Experiment.version);


        fprintf( ...
            fid, ...
            '# event_codebook_version\t%s\n', ...
            P.Events.version);


        fprintf( ...
            fid, ...
            '# subject_id\t%s\n', ...
            subjectID);


        fprintf( ...
            fid, ...
            '# session_started\t%s\n', ...
            char(datetime( ...
                'now', ...
                'Format', ...
                'yyyy-MM-dd HH:mm:ss.SSS')));


        fprintf( ...
            fid, ...
            '\n');


        %% ------------------------------------------------------
        % Column Header
        % -------------------------------------------------------

        fprintf( ...
            fid, ...
            'timestamp_sec\ttask\tcode\tevent\n');


        %% ------------------------------------------------------
        % Store Logger State
        % -------------------------------------------------------

        Logger.fid = ...
            fid;


        Logger.filepath = ...
            filePath;


        Logger.active = ...
            true;


        output = ...
            filePath;


    %% ----------------------------------------------------------
    % Write Event
    % -----------------------------------------------------------

    case "write"


        if isempty(Logger) || ...
                ~isfield(Logger, 'active') || ...
                ~Logger.active

            error( ...
                'eventLogger received an event before initialization.');

        end


        taskName = ...
            char(string(varargin{1}));


        eventName = ...
            char(string(varargin{2}));


        eventCode = ...
            varargin{3};


        %% ------------------------------------------------------
        % Sanitize Text for TSV
        % -------------------------------------------------------

        taskName = regexprep( ...
            taskName, ...
            '[\t\r\n]+', ...
            ' ');


        eventName = regexprep( ...
            eventName, ...
            '[\t\r\n]+', ...
            ' ');


        %% ------------------------------------------------------
        % Event Timestamp
        % -------------------------------------------------------

        eventTime = ...
            GetSecs;


        %% ------------------------------------------------------
        % Write Event
        % -------------------------------------------------------

        fprintf( ...
            Logger.fid, ...
            '%.9f\t%s\t%d\t%s\n', ...
            eventTime, ...
            taskName, ...
            eventCode, ...
            eventName);


    %% ----------------------------------------------------------
    % Current File Path
    % -----------------------------------------------------------

    case "filepath"


        if isempty(Logger) || ...
                ~isfield(Logger, 'filepath')

            output = ...
                '';

        else

            output = ...
                Logger.filepath;

        end


    %% ----------------------------------------------------------
    % Close
    % -----------------------------------------------------------

    case "close"


        if ~isempty(Logger) && ...
                isfield(Logger, 'fid') && ...
                Logger.fid > 0

            fclose( ...
                Logger.fid);

        end


        Logger = [];


    %% ----------------------------------------------------------
    % Unknown Action
    % -----------------------------------------------------------

    otherwise

        error( ...
            'Unknown eventLogger action: %s', ...
            char(action));


end


end