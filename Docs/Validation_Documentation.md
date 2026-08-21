# Choice Overload Validation System Documentation

## Overview

The validation system was built to verify that the recorded experiment
execution matches the expected Choice Overload experiment behavior.

The system does not validate the experiment source code itself. It
validates the output produced by the experiment:

    Event Log
        |
        v
    parseEventLog()
        |
        v
    Structured Log Object
        |
        v
    validateEventLog()
        |
        v
    Validation Report

The main purpose is to detect corrupted, incomplete, or inconsistent
experiment recordings before EEG/behavioral analysis.

------------------------------------------------------------------------

# Architecture

## 1. Event Parsing Layer

Function:

    parseEventLog.m

Responsibilities:

-   Read raw event logs.
-   Extract metadata.
-   Convert raw events into structured experiment objects.
-   Reconstruct:

```{=html}
<!-- -->
```
    Log
     |
     +-- Metadata
     |
     +-- Events
     |
     +-- Rating
     |
     +-- Choice
          |
          +-- Blocks
               |
               +-- Trials

Choice trials now contain:

-   fixation event
-   exposure event
-   mask event
-   response onset
-   response/miss
-   questionnaire events
-   set size
-   condition

The trial-level metadata allows validation of stimulus trigger
correctness.

------------------------------------------------------------------------

# 2. Validation Layer

Function:

    validateEventLog.m

Input:

    Report = validateEventLog(P, Log)

The validator uses:

    P.Events

as the single source of truth for event definitions.

------------------------------------------------------------------------

# Implemented Validation Checks

## Event Integrity

Checks:

-   Unknown event codes.
-   Invalid events that are not defined in the experiment parameters.

------------------------------------------------------------------------

## Preference Rating Validation

Checks:

-   Missing stimulus events.
-   Missing responses.
-   Trial structural integrity.

------------------------------------------------------------------------

## Choice Trial Validation

Checks:

-   Fixation exists.
-   Exposure exists.
-   Mask exists.
-   Response onset exists.
-   Response exists.

------------------------------------------------------------------------

## Exposure Trigger Validation

Checks that:

    setSize + condition
              |
              v
    Expected EEG event code

matches:

    Observed exposure trigger

using:

    getChoiceExposureCode()

This ensures EEG triggers represent the intended experimental condition.

------------------------------------------------------------------------

## Questionnaire Validation

Checks:

-   Questionnaire events use valid event codes.
-   Questionnaire events are associated with valid trials.

------------------------------------------------------------------------

## Timing Validation

Checks:

-   Response does not occur before response onset.
-   Reaction time is not negative.

------------------------------------------------------------------------

# Automated Testing Framework

Folder:

    Tests/

Purpose:

Prevent future changes from silently breaking validation.

Testing workflow:

    generateFakeLog()
            |
            v
    parseEventLog()
            |
            v
    validateEventLog()
            |
            v
    PASS / FAIL

The test suite creates:

-   valid experiment logs
-   intentionally corrupted logs

and confirms that:

-   valid logs pass
-   invalid logs fail

Example corruption tests:

-   unknown event code
-   incorrect exposure trigger
-   invalid timing order

------------------------------------------------------------------------

# Development Milestones

## Commit 1

Refactored validator to consume parsed logs instead of reading TSV files
directly.

## Commit 2

Migrated Preference Rating validation to structured objects.

## Commit 3

Migrated Choice validation to structured block/trial objects.

## Commit 4

Removed duplicated event assumptions and moved event definitions to
`P.Events`.

## Commit 5

Added exposure validation.

## Commit 6

Fixed report propagation and improved validator reliability.

## Commit 7-8

Added questionnaire and timing validation.

## Commit 9+

Added automated PASS/FAIL testing infrastructure.

------------------------------------------------------------------------

# Design Principles

## Separation of Responsibilities

Parser:

    What happened?

Validator:

    Was what happened correct?

Experiment parameters:

    What was expected?

------------------------------------------------------------------------

## Avoid Duplicate Experiment Logic

The validator should not recreate experiment generation logic.

It should only compare:

Expected:

    P

against:

Observed:

    Log

------------------------------------------------------------------------

# Future Improvements

Possible future additions:

-   GitHub Actions automated validation.
-   More extensive synthetic log generation.
-   EEG trigger synchronization validation.
-   Eye-tracking event validation.
-   Statistical completeness checks.
