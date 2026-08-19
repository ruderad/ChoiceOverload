# Choice Overload Experiment
## Documentation by Radmehr Bahrami

A modular MATLAB/Psychtoolbox implementation of a personalized choice-overload experiment designed for behavioral and EEG data collection.

---

# 1. Project Architecture

The experiment uses three main structures:

```text
P = Parameters
R = Results
T = Runtime task state
```

## `P` — Parameters

`P` contains experiment configuration.

Examples include:

* screen settings
* stimulus paths
* trial numbers
* timing values
* task layout parameters
* response colors
* questionnaire settings

`P` is created by:

```matlab
initializeParameters
```

Functions should not modify experimental parameters during task execution.

---

## `R` — Results

`R` contains all participant data that must be saved or analyzed.

Examples include:

* participant information
* preference ratings
* reaction times
* choice conditions
* selected images
* questionnaire responses

`R` is initialized by:

```matlab
initializeResults
```

---

## `T` — Runtime Task State

`T` contains temporary Psychtoolbox and runtime information.

Examples include:

* window pointer
* screen dimensions
* window rectangle
* screen center
* frame interval
* frame rate

`T` is created by:

```matlab
initializeTask
```

---

# 2. General Design Principles

The code follows these rules:

1. Each function has one main responsibility.
2. Experimental parameters are stored in `P`.
3. Participant results are stored in `R`.
4. Runtime Psychtoolbox objects are stored in `T`.
5. `main.m` controls the experiment sequence.
6. Spatial-layout creation is separate from pixel conversion.
7. Drawing logic is separate from response collection where practical.
8. Choice-set generation is separate from choice presentation.
9. Only occupied stimulus locations can produce valid choice responses.
10. Visual response feedback is controlled independently from stimulus drawing.

---

# 3. Experiment Sequence

The complete experiment follows this sequence:

```text
main.m
  |
  +-- initializeParameters
  |
  +-- initializeResults
  |
  +-- collectSubjectInfo
  |
  +-- initializeTask
  |
  +-- taskPreferenceRating
  |
  +-- makeChoiceSets
  |
  +-- taskChoice
  |      |
  |      +-- choice trials
  |      |
  |      +-- questionnaire after successful choices
  |
  +-- cleanupTask
  |
  +-- saveResults
```

---

# 4. Main Folder Structure

```text
ChoiceOverload/
│
├── main.m
├── CHANGELOG.md
├── DOCUMENTATION.md
│
├── Initialize/
│   ├── initializeParameters.m
│   ├── initializeResults.m
│   ├── initializeTask.m
│   └── cleanupTask.m
│
├── Tasks/
│   ├── taskPreferenceRating.m
│   └── taskChoice.m
│
├── Modules/
│   ├── rating-task modules
│   ├── choice-task modules
│   └── questionnaire modules
│
├── Utilities/
│   └── shared helper functions
│
├── Stimuli/
│   └── mug images
│
├── Instructions/
│   └── questionnaire images
│
└── data/
    └── participant result files
```

Questionnaire instruction and item images are stored in:

Instructions/

Their paths are defined once in:

P.Questionnaire.questionFiles
---

# 5. Initialization

## `initializeParameters.m`

Creates the experiment parameter structure:

```matlab
P
```

Important parameter groups include:

```text
P.Experiment
P.Debug
P.Screen
P.Images
P.Timing
P.Message
P.Preference
P.Choice
P.Questionnaire
```

---

## `initializeResults.m`

Creates the initial results structure.

Main result groups are:

```text
R.Subject
R.Preference
R.Choice
```

Questionnaire results are stored inside each choice trial.

---

## `initializeTask.m`

Initializes Psychtoolbox.

Responsibilities include:

* Psychtoolbox setup
* screen creation
* keyboard configuration
* cursor state
* screen geometry
* frame interval calculation

Important fields include:

```text
T.window
T.windowRect
T.width
T.height
T.centerX
T.centerY
T.ifi
T.frameRate
```

---

## `cleanupTask.m`

Restores the computer after the task ends or an error occurs.

Typical responsibilities are:

* close Psychtoolbox screens
* restore keyboard input
* restore cursor visibility

---

# 6. Participant Information

## `collectSubjectInfo.m`

Collects participant metadata before Psychtoolbox task presentation begins.

Stored values include:

```text
R.Subject.ID
R.Subject.Age
R.Subject.Sex
R.Subject.Handedness
```

The experiment can terminate safely if the form is cancelled.

---

# 7. Preference-Rating Task

The first experimental task measures participant preference for the mug stimuli.

The resulting ratings are later used to generate personalized choice sets.

## Main Controller

```matlab
taskPreferenceRating
```

Responsibilities:

* run practice trials
* run experimental rating rounds
* calculate average stimulus ratings
* update `R.Preference`

---

## Preference Task Modules

```text
drawRatingScreen.m
collectSliderResponse.m
runRatingPractice.m
runRatingTrial.m
runRatingRound.m
computeAverageRating.m
taskPreferenceRating.m
```

---

## Rating Results

For each stimulus, the task stores:

* preference rating
* reaction time

The final average rating is stored in:

```matlab
R.Preference.average
```

This vector is indexed by stimulus ID.

---

# 8. Personalized Choice-Set Generation

## `makeChoiceSets.m`

Generates personalized choice sets from:

```matlab
R.Preference.average
```

Supported set sizes are configured by:

```matlab
P.Choice.setSizes
```

The current default set sizes are:

```matlab
[6 12 24]
```

Each set-size block contains 45 trials.

---

## Choice Conditions

### `UL` — Uniform Least

Stimuli are selected from the lowest preference range.

### `UM` — Uniform Moderate

Stimuli are selected from the moderate preference range.

### `UH` — Uniform High

Stimuli are selected from the highest preference range.

### `CF` — Clearly Favored

One highly preferred stimulus is presented with lower-rated alternatives.

### `RS` — Random Set

Stimuli are selected randomly from the available rated stimuli.

---

## `selectClosestToRange.m`

Selects stimuli closest to a requested rating range.

If there are not enough stimuli inside the target range, the function uses the nearest available ratings.

This keeps choice-set generation feasible even when participant rating distributions are uneven.

---

# 9. Choice Task Architecture

The choice task is controlled by:

```matlab
taskChoice
```

The call hierarchy is:

```text
taskChoice
    |
    v
runChoiceBlock
    |
    v
runChoiceTrial
    |
    +-- collectChoiceResponse
    |
    +-- runQuestionnaire
```

---

# 10. `taskChoice.m`

Function signature:

```matlab
R = taskChoice(R, P, T, ChoiceSets)
```

Responsibilities:

* show the mouse cursor
* construct the choice layout
* convert the choice layout to pixels
* construct the questionnaire layout
* convert the questionnaire layout to pixels
* resolve questionnaire image paths
* run the configured choice blocks
* store block results in `R.Choice`
* hide the cursor when complete

The block order is controlled by:

```matlab
P.Choice.blockOrder
```

---

# 11. Choice Layout

## `makeChoiceLayout.m`

Creates the normalized spatial geometry of the choice screen.

The choice grid contains:

```text
6 columns
5 rows
30 possible stimulus locations
1 central fixation region
```

The output includes:

```text
Layout.rect
Layout.fixation
Layout.fixationCross
```

`Layout.rect` is a:

```text
30 × 4
```

matrix.

Each row is:

```text
[left top right bottom]
```

---

## `convertChoiceLayout.m`

Converts normalized choice geometry into Psychtoolbox pixel coordinates.

The converted layout is used for:

* stimulus drawing
* masks
* fixation
* mouse hit testing
* response highlighting

---

## `randomizeChoicePositions.m`

Randomly assigns the stimuli in a trial to available grid cells.

Returns:

```matlab
positions.stimulus
positions.empty
```

### `positions.stimulus`

Contains locations occupied by real stimuli.

### `positions.empty`

Contains unoccupied locations that are shown as masks.

Only locations in:

```matlab
positions.stimulus
```

are valid behavioral choices.

---

# 12. `drawChoiceSet.m`

Draws one choice display.

Responsibilities:

* load stimulus images
* fit each image inside its assigned cell
* draw occupied stimulus cells
* draw masks in empty cells
* draw the central fixation tile
* draw the fixation border
* draw the fixation cross

The function performs drawing only.

It does not:

* randomize positions
* collect responses
* modify results

---

# 13. Choice-Trial Temporal Structure

## `runChoiceTrial.m`

Runs one complete choice trial.

The current sequence is:

```text
Fixation
    ↓
Exposure
    ↓
Mask
    ↓
Choice fixation
    ↓
Response
    ↓
Questionnaire
```

Current default timing values are:

```text
Fixation:          1.0 s
Exposure:          8.0 s
Mask:              0.5 s
Choice fixation:   1.0 s
Choice response:   3.0 s
Questionnaire:     6.0 s
```

These values are configurable in `P`.

---

# 14. Exposure Phase

During exposure:

* the complete choice set is visible
* the participant observes the stimuli
* no yellow response highlight is shown
* mouse hover does not produce response feedback

The absence of yellow highlighting is intentional.

Yellow indicates that an active choice can be made.

---

# 15. Response-Phase Visual Cue

The response phase has a dedicated visual-feedback system.

Its purpose is to:

* make response onset clear
* show which item is currently selectable
* confirm the final choice
* minimize unnecessary visual transients for EEG recording

---

# 16. Response Highlight State Machine

The interaction follows this sequence:

```text
EXPOSURE
    no yellow highlight

        ↓

RESPONSE ONSET
    yellow fixation border

        ↓

HOVER VALID STIMULUS
    yellow stimulus border

        ↓

LEAVE VALID STIMULUS
    no highlight

        ↓

HOVER ANOTHER VALID STIMULUS
    yellow stimulus border

        ↓

CLICK VALID STIMULUS
    green stimulus border
```

## Important EEG Rule

The yellow border around fixation appears only at response onset.

After the participant moves away from a valid stimulus, the highlight disappears.

It does **not** return to fixation.

This prevents repeated fixation-border flashes caused by normal mouse movement.

---

# 17. `drawResponseHighlight.m`

Generic helper function:

```matlab
drawResponseHighlight( ...
    window, ...
    rect, ...
    color, ...
    borderWidth)
```

The helper draws a border around a supplied rectangle.

It does not know whether the rectangle belongs to:

* a choice stimulus
* fixation
* a questionnaire button

This makes the helper reusable across tasks.

Current choice-task use:

```text
Yellow = hover / response availability
Green  = confirmed selection
```

---

# 18. Cached Choice Response Screen

The response phase uses an offscreen Psychtoolbox window as a clean cached display.

The full choice screen is drawn once into the offscreen window.

During hover updates:

```text
cached clean screen
        ↓
copy to participant window
        ↓
draw current highlight
        ↓
flip
```

This avoids repeatedly:

* reading stimulus files
* rebuilding textures
* redrawing the complete choice display from disk

The response loop therefore changes only the visual state that must change.

---

# 19. `collectChoiceResponse.m`

Collects the participant's choice response.

Inputs include:

```text
onscreen window
cached response window
ChoiceLayout
valid stimulus locations
choice onset time
choice duration
highlight parameters
```

Responsibilities:

* read mouse position
* determine whether the mouse is over a valid stimulus
* update the yellow hover border
* ignore masked cells
* detect a valid click
* calculate reaction time
* display green selection feedback
* wait for mouse release

---

## Valid Choice Rule

Only occupied stimulus cells can produce a response.

The valid set is:

```matlab
positions.stimulus
```

Clicks on:

* masked cells
* empty screen regions
* fixation

do not produce a behavioral response.

---

## Reaction Time

Choice RT is measured from the actual response-screen flip timestamp:

```matlab
choiceOnset
```

The stored value is:

```matlab
trial.RT
```

---

# 20. Missed Choice Trials

If no valid choice occurs before:

```matlab
P.Choice.choiceDuration
```

expires:

```text
trial.response      = []
trial.RT            = NaN
trial.selectedImage = NaN
```

The questionnaire is skipped.

Questionnaire values remain:

```text
NaN
```

for the missed trial.

---

# 21. Choice Result Structure

Each choice trial stores:

```text
trial.choiceSet
trial.condition
trial.positions
trial.response
trial.selectedImage
trial.RT
trial.question.response
trial.question.RT
```

## `trial.choiceSet`

Stimulus IDs shown on that trial.

## `trial.condition`

Choice-set condition:

```text
UL
UM
UH
CF
RS
```

## `trial.positions`

Random spatial assignment.

Contains:

```text
positions.stimulus
positions.empty
```

## `trial.response`

Selected spatial location.

## `trial.selectedImage`

Stimulus ID of the selected image.

## `trial.RT`

Choice reaction time.

## `trial.question.response`

Questionnaire responses associated with the choice.

## `trial.question.RT`

Questionnaire reaction times.

---

# 22. `runChoiceBlock.m`

Runs all trials for one set-size block.

Function interface:

```matlab
block = runChoiceBlock( ...
    P, ...
    T, ...
    ChoiceSets, ...
    ChoiceLayout, ...
    QuestionnaireLayout, ...
    questionFiles)
```

The function:

1. determines the number of trials
2. preallocates the full trial result structure
3. calls `runChoiceTrial` for each trial
4. stores each returned trial structure

The preallocated structure includes questionnaire fields so trial assignments remain structurally compatible.

---

# 23. Questionnaire Architecture

The questionnaire currently appears after every successful choice.

Current module hierarchy:

```text
makeQuestionnaireLayout
        ↓
convertQuestionnaireLayout
        ↓
runQuestionnaire
        |
        +-- drawQuestionnaire
        |
        +-- collectQuestionnaireResponse
```

---

# 24. Questionnaire Images

The questionnaire uses:

```text
Q0.png
Q1.png
Q2.png
Q3.png 
```

All questionnaire images are stored in:
 `Instructions/`

Their full paths are defined once during initialization:
`P.Questionnaire.questionFiles`

`Q0` contains the general questionnaire instruction.

`Q1` to `Q3` contain the individual questionnaire items.

`taskChoice.m` validates that all required files exist before the choice blocks begin.

---

# 25. `makeQuestionnaireLayout.m`

Creates normalized questionnaire geometry.

The layout contains:

```text
Layout.instruction
Layout.question
Layout.button
```

The number of questions is controlled by:

```matlab
P.Questionnaire.nQuestions
```

The number of rating options is controlled by:

```matlab
P.Questionnaire.nScalePoints
```

---

# 26. `convertQuestionnaireLayout.m`

Converts normalized questionnaire geometry to pixel coordinates.

The resulting rectangles are used for:

* question-image placement
* rating-button placement
* mouse hit testing

---

# 27. `drawQuestionnaire.m`

Draws the current questionnaire screen.

The current implementation displays:

* `Q0` instruction
* all three question images
* seven response buttons for each question
* green borders around selected responses

Question images are scaled while preserving their aspect ratio.

---

# 28. `collectQuestionnaireResponse.m`

Collects questionnaire responses.

The current implementation permits the participant to answer the three questions shown on the same screen.

For each question it records:

```text
response
RT
```

A questionnaire timeout is controlled by:

```matlab
P.Questionnaire.duration
```

---

# 29. `runQuestionnaire.m`

Controls questionnaire presentation.

Responsibilities:

1. initialize unanswered responses
2. draw the questionnaire
3. flip the display
4. record questionnaire onset
5. collect responses
6. return response and RT vectors

---

# 30. Current Questionnaire Limitation

The current questionnaire presents all three questions simultaneously.

This implementation is functional, but it is scheduled for redesign.

The planned architecture is one question per screen.

Planned sequence:

```text
Questionnaire trial 1
    Q0
    Q1
    rating buttons

Questionnaire trial 2
    Q0
    Q2
    rating buttons

Questionnaire trial 3
    Q0
    Q3
    rating buttons
```

The planned questionnaire interaction will reuse:

```matlab
drawResponseHighlight
```

for:

* yellow hover feedback
* green confirmed-response feedback

---

# 31. Result Saving

## `saveResults.m`

Saves the complete participant result structure.

Results are stored as:

```text
data/<SubjectID>.mat
```

The saved structure contains both:

* behavioral task results
* participant metadata

---

# 32. Utilities

## `readimg.m`

Loads an image file and creates a Psychtoolbox texture.

Returns:

```text
textureID
imageWidth
imageHeight
```

---

## `normalizeScaleValue.m`

Converts a preference-scale value to the normalized interval:

```text
[0, 1]
```

Used by the preference-rating display.

---

## `showBlankScreen.m`

Displays the experiment background for a specified duration.

---

## `showMessageScreen.m`

Displays centered experiment messages and waits for participant input.

---

# 33. Main Module Map

## General

```text
collectSubjectInfo.m
saveResults.m
readimg.m
showBlankScreen.m
showMessageScreen.m
```

## Preference Rating

```text
drawRatingScreen.m
collectSliderResponse.m
runRatingPractice.m
runRatingTrial.m
runRatingRound.m
computeAverageRating.m
taskPreferenceRating.m
```

## Choice-Set Generation

```text
makeChoiceSets.m
selectClosestToRange.m
getSetRating.m
```

## Choice Task

```text
makeChoiceLayout.m
convertChoiceLayout.m
randomizeChoicePositions.m
drawChoiceSet.m
drawResponseHighlight.m
collectChoiceResponse.m
runChoiceTrial.m
runChoiceBlock.m
taskChoice.m
```

## Questionnaire

```text
makeQuestionnaireLayout.m
convertQuestionnaireLayout.m
drawQuestionnaire.m
collectQuestionnaireResponse.m
runQuestionnaire.m
```

---

# 34. Current Experimental Status

The experiment currently supports:

* participant-information collection
* preference-rating practice
* repeated preference-rating rounds
* average preference calculation
* participant-specific choice-set generation
* three choice-set sizes
* five choice conditions
* fixed choice-trial timing
* mouse-based choice responses
* response timeouts
* response-phase visual cue
* yellow valid-option hover feedback
* green selection confirmation
* EEG-oriented suppression of unnecessary highlight flashes
* questionnaire presentation after successful choices
* questionnaire response and RT storage
* result saving

---

# 35. Next Development Target

The next planned change is the questionnaire redesign.

The goal is to replace the current simultaneous three-question display with a trial-based sequence.

Each questionnaire trial will contain:

```text
Q0 instruction
      ↓
one question
      ↓
rating buttons
```

The choice-task response-highlight architecture will be reused where possible.

This keeps interaction behavior consistent across the experiment.
