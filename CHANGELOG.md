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

## v0.2.3 — Choice-Task Stabilization and Response Feedback

### Fixed — Choice/Questionnaire Integration

Corrected interface mismatches introduced when the questionnaire was integrated into the choice task.

The final call hierarchy is:

```text
taskChoice
    ↓
runChoiceBlock
    ↓
runChoiceTrial
    ├── collectChoiceResponse
    └── runQuestionnaire
```

The following values are now passed consistently through the hierarchy:

* `ChoiceSet`
* `condition`
* `ChoiceLayout`
* `QuestionnaireLayout`
* `questionFiles`

### Fixed — Trial Structure

Updated choice-trial preallocation to include questionnaire output:

```text
trial.question.response
trial.question.RT
```

This keeps the structures returned by `runChoiceTrial` compatible with the structures stored by `runChoiceBlock`.

### Fixed — Choice Layout References

Removed stale references to the generic variable `Layout` inside the updated choice-trial code.

Choice-task geometry now consistently uses:

```matlab
ChoiceLayout
```

Questionnaire geometry uses:

```matlab
QuestionnaireLayout
```

### Fixed — Valid Choice Locations

Choice responses are now accepted only when the participant clicks an occupied stimulus cell.

Masked or empty cells are ignored.

Valid response locations are defined by:

```matlab
positions.stimulus
```

This prevents an empty grid location from being stored as a behavioral choice.

### Fixed — Questionnaire Text Rendering

Corrected the `DrawFormattedText` argument sequence in `drawQuestionnaire.m`.

The questionnaire rating numbers now render correctly inside their response buttons.

### Fixed — Mouse Carryover

A mouse click used to select a choice cannot carry directly into the questionnaire.

The response collector waits for mouse-button release after a valid choice.

### Added — Response Highlight Helper

Added:

```text
drawResponseHighlight.m
```

This small helper draws a configurable response border around any supplied rectangle.

The helper is task-independent and can later be reused by the questionnaire.

### Added — Choice Response Highlighting

The choice response phase now has explicit visual feedback.

#### Response onset

A yellow border is drawn around the central fixation cell.

This yellow border is a visual cue that the response phase has started.

#### Valid stimulus hover

When the mouse moves over an occupied stimulus cell:

```text
yellow fixation
      ↓
yellow stimulus border
```

#### Mouse outside valid stimuli

When the mouse leaves a valid stimulus cell:

```text
yellow stimulus border
      ↓
no highlight
```

The yellow border does **not** return to fixation.

This behavior reduces unnecessary visual transients during EEG recording.

#### Confirmed response

When the participant clicks a valid stimulus:

```text
yellow hover
     ↓
green selection border
```

The green border provides brief visual confirmation of the selected option.

### EEG-Specific Highlight Rules

Response highlighting follows these rules:

```text
EXPOSURE
    no yellow highlight

RESPONSE ONSET
    yellow fixation border

HOVER VALID STIMULUS
    yellow stimulus border

LEAVE VALID STIMULUS
    no highlight

HOVER ANOTHER VALID STIMULUS
    yellow stimulus border

CLICK VALID STIMULUS
    green stimulus border
```

The fixation highlight appears only at response onset.

It does not flash again when the mouse moves between valid and invalid screen regions.

### Added — Cached Response Display

The clean response screen is stored in an offscreen Psychtoolbox window.

Hover updates restore this cached display and then draw only the required highlight.

This avoids repeatedly loading and rebuilding stimulus textures during mouse movement.

### Fixed — Questionnaire File Paths

Renamed the misspelled questionnaire image directory:

```text
Instrctions/

to:

Instructions/
```




### Current Status

The experiment now executes the following complete sequence:

```text
Participant information
        ↓
Preference-rating practice
        ↓
Preference-rating rounds
        ↓
Personalized choice-set generation
        ↓
Choice task
        ↓
Questionnaire after each successful choice
        ↓
Result saving
```

The preference task, choice task, and questionnaire are integrated and operational.

### Next Planned Change

Redesign the questionnaire from one three-question screen into three sequential question trials.

Each questionnaire trial will contain:

```text
Q0 instruction
      ↓
Current question
      ↓
Rating buttons
```

The questionnaire will reuse the yellow-hover and green-selection response-feedback system.
