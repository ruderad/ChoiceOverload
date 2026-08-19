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
