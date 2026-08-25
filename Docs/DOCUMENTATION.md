# Choice Overload Experiment

Version: **0.4.0**

A modular MATLAB/Psychtoolbox experiment for personalized choice-overload research with behavioral, EEG, and EyeLink acquisition.

## Requirements

- MATLAB
- Psychtoolbox
- Instrument Control Toolbox or compatible legacy serial support for EEG triggers
- EyeLink Toolbox and an EyeLink host for eye tracking
- Experiment instruction images and mug stimuli included in the repository

Hardware is bypassed when `P.Debug.enabled = true`. The TSV event logger can remain active in debug mode.

## Project structure

| Path | Purpose |
|---|---|
| `main.m` | Experiment entry point and lifecycle |
| `Initialize/` | Parameters, results, Psychtoolbox, acquisition, and cleanup |
| `Acquisition/` | EEG and EyeLink backend functions |
| `Tasks/` | Preference-rating and choice task controllers |
| `Modules/` | Task, layout, drawing, response, and result modules |
| `Utilities/` | Event routing, logging, parsing, validation, and helpers |
| `Tests/` | Validation, trigger, and acquisition-contract tests |
| `Docs/` | Changelog, codebook, validation guide, and this document |
| `Stimuli/` | Mug images |
| `Instructions/` | Experiment and questionnaire images |
| `Data/` | Behavioral MAT files and transferred EDF files |
| `Logs/` | Session event logs when enabled |

## Core data structures

- `P`: immutable experiment parameters and the event codebook.
- `R`: participant metadata, task results, and a copy of `P.Events`.
- `T`: runtime Psychtoolbox and acquisition state.

## Experiment lifecycle

1. `initializeParameters` creates configuration and event codes.
2. `initializeResults` creates the result structure.
3. `collectSubjectInfo` collects participant metadata and block order.
4. `initializeTask` opens Psychtoolbox.
5. `initializeAcquisition` starts requested hardware and the event logger.
6. EyeLink calibration and recording start after the display is available.
7. The acquisition synchronization marker (`55`) is sent.
8. `taskPreferenceRating` collects personalized preference ratings.
9. `makeChoiceSets` creates participant-specific choice sets.
10. `taskChoice` runs choice trials and sequential questionnaires.
11. `cleanupAcquisition` stops EyeLink, transfers the EDF, closes EEG, and closes the logger.
12. `cleanupTask` restores the display and input state.
13. `saveResults` writes behavioral results to `Data/`.

The error path also calls acquisition and Psychtoolbox cleanup before it rethrows the error.

## Configuration

Edit `Initialize/initializeParameters.m` before a session.

### Debug mode

```matlab
P.Debug.enabled = true;
```

Debug mode bypasses EEG and EyeLink. It does not disable the event logger.

### Event logging

```matlab
P.Acquisition.EventLog.enabled = true;
P.Acquisition.EventLog.folder = fullfile(P.Experiment.root, 'Logs');
```

### EEG

```matlab
P.Acquisition.EEG.enabled = true;
P.Acquisition.EEG.port = '/dev/ttyUSB0';
P.Acquisition.EEG.BaudRate = 57600;
P.Acquisition.EEG.DataBits = 8;
```

Route selection is controlled by `Acquisition`, `PreferenceRating`, and `Choice` fields under `P.Acquisition.EEG`.

### EyeLink

```matlab
P.Acquisition.EyeTracker.enabled = true;
```

EyeLink initialization, calibration, recording, messaging, shutdown, and EDF transfer are separate lifecycle operations. EDF stems are normalized to EyeLink-compatible eight-character names. Transferred files go to `P.Results.path` (`Data/`).

## Event system

All events use:

```matlab
sendEvent(P, T, taskName, eventName, eventCode)
```

The logger records every routed event when active. EEG receives the numeric code. EyeLink receives the descriptive event name while recording. `P.Events` is the only code-definition source, and `R.Events` preserves the session codebook.

The valid EEG trigger range is 1–63. Code 0 is the idle value. Initialization rejects duplicate codes and codes above 63. See [EVENT_CODEBOOK.md](EVENT_CODEBOOK.md).

## Validation

```matlab
Log = parseEventLog(logPath);
Report = validateEventLog(P, Log);
```

The parser reconstructs metadata, rating trials, choice blocks, choice trials, exposure metadata, and questionnaires. The validator checks event integrity, trial structure, exposure-code mapping, questionnaire structure, and timing.

See [Validation_Documentation.md](Validation_Documentation.md).

## Tests

From the repository root in MATLAB:

```matlab
addpath(genpath(pwd));
runValidationTests;
testAcquisitionContracts;
```

`minimalTriggerTest` requires the EEG trigger hardware. Full EyeLink and cross-device synchronization checks require the acquisition hardware.

## Release status

- Behavioral experiment: implemented.
- Event parser and validator: implemented with synthetic PASS/FAIL tests.
- EEG serial triggers: implemented and tested with hardware.
- EyeLink backend: implemented.
- Acquisition lifecycle regression test: implemented without hardware.
- EyeLink hardware recording, EDF transfer, and EEG/EyeLink/behavioral synchronization: pending an on-hardware validation run.
