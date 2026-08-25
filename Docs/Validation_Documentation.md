# Choice Overload Validation System

Version: **0.4.0**

## Purpose

The validation system checks whether a recorded event log matches the expected experiment sequence. It detects incomplete, corrupted, or inconsistent sessions before behavioral, EEG, or eye-tracking analysis.

It validates recorded output. It does not prove that hardware timestamps are synchronized.

## Workflow

```matlab
Log = parseEventLog(logPath);
Report = validateEventLog(P, Log);
```

`P.Events` is the only source of expected event codes.

## Parser

`Utilities/parseEventLog.m` reads a TSV event log and reconstructs:

- session metadata;
- raw events;
- preference-rating trials;
- choice blocks and trials;
- set size and condition for each choice trial;
- questionnaire events.

The parser determines what happened. It does not decide whether the session is valid.

## Validator

`Utilities/validateEventLog.m` evaluates the parsed structure and returns a report.

Checks include:

- unknown or invalid event codes;
- missing rating stimuli or responses;
- missing choice fixation, exposure, mask, response-onset, or response events;
- exposure-code mismatch for the recorded set size and condition;
- invalid questionnaire codes or trial associations;
- impossible or invalid response timing.

Exposure validation resolves the expected code through `getChoiceExposureCode`.

## Event-log operation

The event logger is independent of the hardware bypass. Set:

```matlab
P.Debug.enabled = true;
P.Acquisition.EventLog.enabled = true;
```

to exercise event routing without opening EEG or EyeLink hardware. Logs are written to the configured `Logs/` directory and closed during normal or emergency cleanup.

## Automated tests

Run:

```matlab
addpath(genpath(pwd));
runValidationTests;
testAcquisitionContracts;
```

`runValidationTests` generates synthetic logs and covers valid execution, unknown codes, incorrect exposure triggers, and invalid timing.

`testAcquisitionContracts` checks debug-mode acquisition state, synchronization-event logging, logger cleanup, and idempotent state transitions without hardware.

`minimalTriggerTest` is a separate EEG hardware test.

## Interpretation

A passing validation report means that the logged sequence is internally consistent with `P.Events` and the validator rules. It does not confirm:

- EEG electrical pulse timing;
- EyeLink connection or sample recording;
- successful EDF transfer;
- clock alignment between behavioral, EEG, and EyeLink systems.

Complete release qualification therefore requires both automated log validation and an on-hardware synchronization run.
