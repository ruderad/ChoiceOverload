# Choice Overload Experiment

A modular MATLAB/Psychtoolbox implementation of a personalized choice overload experiment for EEG and eye-tracking.

---

# Project Philosophy

This project follows several guiding principles:

1. Only three global structures exist:
   - `P` : Parameters (read-only after initialization)
   - `R` : Results (all analyzable data)
   - `T` : Task (runtime objects and temporary variables)

2. Every function has a single responsibility.

3. Experimental parameters are defined only once inside
   `initializeParameters.m`.

4. `main.m` is the only script responsible for orchestrating the experiment.

5. Functions receive only the structures they actually require.

6. No hard-coded experimental parameters.

---

# Folder Structure

```
ChoiceOverload/

main.m

initialize/
tasks/
modules/
utilities/
stimuli/
data/
analysis/
```

---

# File Descriptions

## main.m

Entry point of the experiment.

Responsibilities:

- Adds project folders to MATLAB path.
- Initializes P, R and T.
- Executes each experimental task.
- Handles errors.
- Performs cleanup.

---

## initialize/initializeParameters.m

Creates the `P` structure.

Contains all experiment configuration including:

- experiment metadata
- screen parameters
- image information
- preference task parameters
- debug settings

No function should ever modify `P` after initialization.

---

## initialize/initializeResults.m

Creates the `R` structure.

Preallocates storage for all behavioral results generated during the experiment.

---

## initialize/initializeTask.m

Initializes Psychtoolbox.

Responsibilities:

- initialize PTB
- open display window
- configure keyboard
- hide cursor
- populate `T`

---

## initialize/cleanupTask.m

Safely closes the experiment.

Responsibilities:

- close PTB window
- restore keyboard
- show cursor

Always called after the experiment finishes or crashes.

---

## tasks/taskPreferenceRating.m

Top-level controller for the preference rating task.

Responsibilities:
- execute practice round
- execute Rating Round 1
- execute Rating Round 2
- compute average ratings

Contains no experimental logic itself.

---
## module/runRatingPractice.m

makes the practice round. 

- `nPracticeTrials` configurable in `P`, default is `5`
- practice images excluded from experimental pool 

---

## modules/runRatingRound.m

Runs one complete rating round.

Responsibilities:

- randomize presentation order
- call `runRatingTrial`
- save ratings and reaction times

---

## modules/runRatingTrial.m

Runs one rating trial.

Responsibilities:

- load image
- scale image
- display image
- collect participant response
- return rating and reaction time

---

## modules/drawRatingScreen.m

Draws one frame of the rating screen.

Responsibilities:

- draw image
- draw rating scale
- draw slider
- draw progress indicator
- flip screen

Contains no keyboard logic.

---

## modules/collectSliderResponse.m

Handles participant interaction.

Responsibilities:

- initialize slider
- update slider position
- redraw screen
- confirm response
- measure reaction time

Returns:

- rating
- RT

---

## modules/collectSubjectInfo.m

Simple experimenter form for entering participant information.

 OUTPUT
   Subject.ID
   Subject.Age
   Subject.Sex
   Subject.Handedness

 aborted = true if Cancel is pressed.

---

## modules/computeAverageRating.m

Computes the average preference rating across both rounds.

Stores the result in

```
R.Preference.average
```

---

## modules/saveResults.m

Saves the complete results structure for one participant.

 INPUT
   R       - Results structure
   root    - Experiment root directory

 Results are saved as:

   <root>/data/<SubjectID>.mat

---

## modules/selectClosestToRange.m

selectClosestToRange  Select stimuli closest to a target rating range.

   ids = selectClosestToRange(ratings, targetRange, n)

   Selects n rated stimuli whose ratings are closest to the specified
   target range. Stimuli inside the target range are always preferred.
   If additional stimuli are needed, stimuli outside the range are
   selected according to their distance from the range.

   When multiple stimuli have the same distance from the target range,
   selection among them is randomized.

   Inputs:
       ratings     - Vector of stimulus ratings, indexed by stimulus ID.
       targetRange - Two-element vector defining the desired rating range.
       n           - Number of stimuli to select.

   Output:
       ids         - Stimulus IDs of the selected images.

---
## makeChoiceSets.m

 makeChoiceSets  Generate choice sets for one set-size block.

   ChoiceSets = makeChoiceSets(ratings, setSize)

   Generates 45 choice sets for the specified set size:
       5  Uniform Least      (UL)
       5  Uniform Moderate   (UM)
       5  Uniform High       (UH)
       15 Clearly Favored    (CF)
       15 Random Set         (RS)

   Uniform conditions select stimuli closest to their intended rating
   range. If insufficient stimuli are available within the target range,
  the closest available ratings are used as substitutes.

   Inputs:
       ratings  - Vector of stimulus ratings (1-7), indexed by stimulus ID.
       setSize  - Number of stimuli in each choice set.

   Output:
       ChoiceSets - Struct array containing the condition and stimulus
                    IDs for each of the 45 choice sets.

---

## utilities/readimg.m

Loads an image and creates a Psychtoolbox texture.

Returns:

- texture ID
- image width
- image height

---
## utilities/normalizeScaleValue.m

%NORMALIZESCALEVALUE Convert a scale value to the interval [0, 1].
%
%   normalizedPosition = normalizeScaleValue(value, P)
%
%   Linearly maps a value from the preference rating scale defined in
%   P.Preference to the normalized interval [0, 1]. This is primarily
%   used to convert rating values into screen coordinates when drawing
%   the rating scale and slider.
%
%   INPUTS
%       value : Value on the preference scale.
%       P     : Parameter structure containing:
%                   P.Preference.min
%                   P.Preference.max
%
%   OUTPUT
%       normalizedPosition : Value normalized to the interval [0, 1].
%
%   EXAMPLE
%
%       sliderPosition = normalizeScaleValue(rating, P);
%       sliderX = x0 + sliderPosition * scaleWidth;
%
%   Keeping the normalization logic in a single function ensures that
%   any future changes to the scale definition are propagated
%   automatically throughout the experiment.

---
## utilities/showBlankScreen.m

%SHOWBLANKSCREEN Display a blank screen for a fixed duration.
%
%   showBlankScreen(duration, P, T)
%
%   Clears the display using the experiment background color,
%   flips the screen, and waits for the specified duration.
%
%   INPUTS
%       duration : Blank interval in seconds.
%       P        : Parameter structure.
%       T        : Task structure.
%
%   OUTPUTS
%       None.
%
%   EXAMPLE
%
%       showBlankScreen(P.Timing.blankITI, P, T);

---
## utilities/showMessageScreen.m

%SHOWMESSAGESCREEN Display a centered message and wait for SPACE.
%
%   showMessageScreen(message, P, T)
%
%   Displays one or more lines of text centered on the screen. The
%   function blocks execution until the participant presses the SPACE
%   key. Pressing ESCAPE immediately terminates the experiment.
%
%   INPUTS
%       message : Cell array of strings. Each cell represents one line
%                 of text. Empty strings can be used to insert blank lines.
%       P       : Parameter structure.
%       T       : Task structure.
%
%   EXAMPLE
%
%       showMessageScreen({
%           'Preference Rating'
%           ''
%           'You will see pictures of mugs.'
%           'Rate how much you like each mug.'
%           ''
%           'LEFT / RIGHT   Move Slider'
%           'SPACE          Confirm Rating'
%           ''
%           'Press SPACE to begin.'
%       }, P, T);
%
%   This function is intended to be a generic message renderer for the
%   entire experiment and can be reused for instructions, break screens,
%   round transitions, completion messages, calibration prompts, and
%   other text-only screens.

---
## utilities/getSetRatings

function ratings = getSetRatings(ChoiceSets, rating, setIndex)

% getSetRatings  Return stimulus IDs and ratings for a choice set.
%
%   ratings = getSetRatings(ChoiceSets, rating, setIndex)
%
%   Returns the stimulus IDs and their corresponding ratings for the
%   specified choice set.
%
%   Inputs:
%       ChoiceSets - Struct array generated by makeChoiceSets.
%       rating     - Vector of stimulus ratings indexed by stimulus ID.
%       setIndex   - Index of the choice set to inspect.
%
%   Output:
%       ratings    - Two-column matrix:
%                    column 1: stimulus IDs
%                    column 2: ratings

---

# Data Structures

## P

Experiment parameters.

Read-only after initialization.

Contains:

- Experiment
- Debug
- Screen
- Images
- Preference
- Choice
- Questionnaire

---

## R

Behavioral results.

Contains only data intended for later analysis.

---

## T

Temporary runtime objects.

Contains:

- PTB window
- screen geometry
- progress
- runtime variables

Can safely be discarded after the experiment ends.

---

# Development Status

## Completed

- Project architecture
- Initialization layer
- Preference rating engine
- Fully-configurable preference rating task
- Personalized Choice Set curation engine

## Planned

- Instruction screens
- Questionnaire
- EEG triggers
- Eye-tracker integration