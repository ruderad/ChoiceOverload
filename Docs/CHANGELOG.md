# Changelog
## By Radmehr Bahrami (github.com/ruderad)

## v0.1.0 — First Executable Prototype

### Added

* Modular experiment architecture
* Three-structure design:

  * `P` — parameters
  * `R` — results
  * `T` — runtime task state
* Initialization framework
* Generic renderer
* Preference-rating task
* Psychtoolbox integration
* Image loading
* Slider-based rating interface
* Progress indicator
* Modular drawing and response collection

### Status

The preference-rating task executes from start to finish.

---

## v0.1.1 — Updated Stimulus Set

### Added

* Final mug stimulus set containing 130 images
* `.gitignore`

---

## v0.1.2 — Preference-Rating Task Interface

### Added

* `P.Preference.Layout` for configurable screen geometry
* Ruler-style rating scale
* `normalizeScaleValue.m`
* Image scaling
* `showMessageScreen.m`
* Instruction screens
* Round-complete screen
* Task-complete screen
* `showBlankScreen.m`
* Mouse response collection
* Emergency exit with `ESC`

### Changed

* Improved rating-screen appearance
* Removed the progress indicator after interface testing

---

## v0.1.3 — Result-Saving System

### Added

* `collectSubjectInfo.m`

  * Subject ID
  * Age
  * Sex
  * Handedness
* `saveResults.m`
* Participant results saved as:

```text
data/<SubjectID>.mat
```

---

## v0.1.4 — Practice Round and Rating Logic

### Added

* `runRatingPractice.m`
* `P.Preference.nPracticeTrials`
* `P.Preference.nTrialsPerRound`

### Changed

* Improved `initializeResults.m`
* Improved `computeAverageRating.m`
* `runRatingRound.m` now supports configurable trial counts
* `taskPreferenceRating.m` now includes a practice round
* Practice stimuli are excluded from the experimental rating pool

---

## v0.2.0 — Personalized Choice-Set Generation

### Added

* `makeChoiceSets.m`
* `selectClosestToRange.m`
* `getSetRating.m`

### Choice-set conditions

Each set-size block contains five conditions:

* `UL` — Uniform Least
* `UM` — Uniform Moderate
* `UH` — Uniform High
* `CF` — Clearly Favored
* `RS` — Random Set

Choice sets are generated from each participant's preference ratings.

---

## v0.2.1 — Choice Task

### Added

* `makeChoiceLayout.m`
* `convertChoiceLayout.m`
* `randomizeChoicePositions.m`
* `drawChoiceSet.m`
* `collectChoiceResponse.m`
* `runChoiceTrial.m`
* `runChoiceBlock.m`
* `taskChoice.m`

### Added behavior

* Configurable set sizes
* Random spatial assignment of stimuli
* Masked empty locations
* Mouse-based choice collection
* Choice reaction-time measurement
* Condition and selected-image storage

---

## v0.2.2 — Full Psychophysics Experiment

### Added

Questionnaire presentation after successful choice trials.

New questionnaire modules:

* `makeQuestionnaireLayout.m`
* `convertQuestionnaireLayout.m`
* `drawQuestionnaire.m`
* `collectQuestionnaireResponse.m`
* `runQuestionnaire.m`

### Changed

* Added the final temporal structure of the choice trial
* Added response timeouts
* Integrated questionnaire results into each choice trial
* Added questionnaire response and RT fields to the trial result structure

### Trial sequence

```text
Fixation
    ↓
Exposure
    ↓
Mask
    ↓
Choice fixation
    ↓
Choice response
    ↓
Questionnaire
```

Missed choice trials skip the questionnaire.

---

## v0.2.3 — Choice Task Stabilization and Response Feedback

### Fixed

- Repaired choice/questionnaire integration across:

    - `taskChoice.m`

    - `runChoiceBlock.m`

    - `runChoiceTrial.m`

    - `collectChoiceResponse.m`

- Fixed trial-structure compatibility by adding:

    - `trial.question.response`

    - `trial.question.RT`

- Standardized use of `ChoiceLayout` and `QuestionnaireLayout`.

- Restricted valid choices to occupied stimulus cells in positions.stimulus.

- Fixed questionnaire rating-number rendering in `drawQuestionnaire.m`.

- Prevented mouse-button carryover from registering accidental responses.

- Renamed questionnaire folder:

    Instrctions/ → Instructions/

- Centralized questionnaire image paths in `P.Questionnaire.questionFiles`.

### Added

- `drawResponseHighlight.m`

- Yellow hover feedback during the choice response phase.

- Green confirmation feedback after a valid click.

- Per-trial cursor reset to the center of fixation immediately before response onset.

- Cached response display for efficient hover updates.

### Final Choice Response Behavior

EXPOSURE
    no yellow highlight

RESPONSE PREPARATION
    cursor reset to fixation center

RESPONSE ONSET
    yellow fixation border

CURSOR REMAINS IN FIXATION
    yellow fixation remains

CURSOR LEAVES FIXATION
    no highlight

HOVER VALID STIMULUS
    yellow stimulus border

LEAVE VALID STIMULUS
    no highlight

CLICK VALID STIMULUS
    green stimulus border

The fixation highlight appears only at the beginning of the response phase and does not return after the cursor leaves it. This reduces unnecessary visual transients during EEG recording.

### Status

The Choice Task is now considered functionally complete.

### Next

Redesign the questionnaire from one simultaneous three-question screen into three sequential question screens with the same yellow-hover / green-selection interaction pattern.

## v0.2.4 — Sequential Questionnaire Redesign

### Changed
- Reworked the questionnaire from one multi-question screen into sequential single-question screens.
- Each questionnaire screen now contains:
  - `Q0` general instruction
  - one current question image
  - a configurable rating scale
- Questionnaire responses and RTs are now collected separately for each question.
- Added yellow hover and green selection feedback using `drawResponseHighlight.m`.
- Added a cached clean questionnaire display for efficient hover updates.
- Reset the mouse to screen center before each questionnaire question.
- Removed obsolete multi-row questionnaire layout parameters.

### Improved
- Questionnaire layout is now independent of scale length.
- `P.Questionnaire.nScalePoints` can be changed from 7 to 9 without modifying questionnaire modules.
- Questionnaire image paths are generated dynamically from `P.Questionnaire.nQuestions`.

### Status
The sequential questionnaire architecture is implemented and ready for testing.

## v0.2.5 - Final Psychophysics Experiment

### Changed
- removed magic numbers from `makeChoiceSets`. The ranges and the number of trial per condition are fully parametric.
- `CollectSubjectInfo` now has an `order` field.
- Persian instructions thanks to our new helper function `showInstructionImage`

### Added
- Automatic conterbalancing of block order with the option for experimenter to manually determine block order.

## V0.3.0 - EEG & Eye-Tracking Event Marker Architecture

### Added

- Acquisition architecture for future EEG and eye-tracking hardware integration.

- New acquisition lifecycle modules:

  - `initializeAcquisition.m`
  - `cleanupAcquisition.m`

- New task-aware event router:

  - `sendEvent.m`

- Debug mode now acts as the master acquisition bypass.

  When:

  ```matlab
  P.Debug.enabled = true;
  ```
  the behavioral experiment continues normally while EEG and eye-tracking initialization and event transmission are completely bypassed

- Independent acquisition configuration for EEG and eye tracking:

```
P.Acquisition.EEG.enabled
P.Acquisition.EEG.PreferenceRating
P.Acquisition.EEG.Choice

P.Acquisition.EyeTracker.enabled
P.Acquisition.EyeTracker.PreferenceRating
P.Acquisition.EyeTracker.Choice
```

- Centeralized event-marker codebook (`P.Events`)

- Event-codebook validation:
    - verifies all event codes remain within the 8-bit trigger range
    - detects duplicate EEG event codes

- Exact event-codebook configuration is now stored in participant results: `R.Events = P.Events`

- Added getChoiceExposureCode.m for dynamic resolution of Set Size × Condition exposure markers.

- Choice Timing Improvements

### Changed

- `main.m` now initializes acquisition after Psychtoolbox initialization and
performs acquisition cleanup during both normal completion and error handling.

- `drawRatingScreen.m` now returns the Psychtoolbox flip timestamp.

- `runRatingTrial.m` now distinguishes between practice
and main

- `collectSliderResponse.m`, `collectChoiceResponse.m`, and `collectQuestionnaireResponse.m` now separate behavioral response timing from visual-feedback timing.

- Questionnaire acquisition events are routed through the Choice task because the questionnaire is executed as part of successful Choice trials.

### Status

The behavioral experiment and task-level event-marker architecture are now considered frozen.

```
Completed:

Preference Rating markers    ✓
Choice Task markers          ✓
Questionnaire markers        ✓
Dynamic exposure codes       ✓
Dynamic questionnaire codes  ✓
Event-code validation        ✓
Event codebook saved         ✓
Debug acquisition bypass     ✓
```

Actual EEG and eye-tracker hardware communication has intentionally not yet
been implemented.

### Planned 

The event codebook currently reserves:

1  Experiment start
2  Experiment end

Experiment-level marker routing will be finalized together with the real acquisition lifecycle rather than forcing these events through a task-specific
route.

**Next development stage:**

- implement the actual EEG trigger backend
- implement the actual eye-tracker backend
- finalize experiment start/end acquisition lifecycle
- harden cleanup for partial hardware initialization
- validate real hardware timing
- perform synchronization testing


## V0.3.1 - Validation System Implementation + EEG Integration

### Added

- Added experiment validation framework for Choice Overload EEG/Eyetracking experiments.
- Implemented structured event parsing through `parseEventLog.m`.
- Refactored validator architecture to operate on parsed experiment objects instead of raw TSV files.
- Added validation reporting through `validateEventLog.m`.
- Implemented EEG serial trigger backend.
- Added configurable EEG acquisition parameters:
  - serial port
  - baud rate
  - data bits
- Added EEG trigger initialization and cleanup.
- Added hardware trigger validation using serial interface.
- Updated event codebook for 1–63 trigger range.


### Changed

- Questionnaire event markers remapped from 100–108 to 45–53.
- EEG trigger validation now reflects hardware limitations.
- Acquisition system now supports real EEG marker transmission.

### Validated

- EEG trigger transmission tested with real hardware.
- Preference Rating events verified.
- Choice events verified.
- Exposure condition markers verified.



### Validation Features

- Added event code integrity validation using `P.Events` as the single source of truth.
- Added Preference Rating trial validation.
- Added Choice trial structure validation.
- Added EEG exposure trigger validation using:
  - set size
  - experimental condition
  - expected trigger mapping
- Added questionnaire event validation.
- Added response timing validation.

### Testing

- Added automated validation test framework.
- Added synthetic log generation for validator testing.
- Added PASS/FAIL tests for:
  - valid experiment execution
  - invalid event codes
  - incorrect exposure triggers
  - invalid response timing

### Architecture Improvements

- Separated event reconstruction from validation logic.
- Parser is now responsible for determining what happened.
- Validator is responsible for determining whether execution was correct.




