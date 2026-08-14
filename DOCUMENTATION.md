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
# Modules used in each task

## general experiment level functions

```
collectSubjectInfo.m
saveResults.m
```

## PreferenceRatingTask
```

drawRatingScreen.m      : Draw stimuli and slider
collectSliderResponse.m : Collect subject response
runRatingPractice.m     : Run pracitce round
runRatingTrial.m        : Run a single trial
runRatingRound.m        : Run the whole round
computeAverageRating.m  : Compute average rating for each stimulus
taskPreferenceRating.m  : Run the whole task
```
## ChoiceTask
```
makeChoiceSets.m           : Curate 45 personalized choice sets of 5 conditions 
selectClosetToRange.m      : Finds closest missing values from neighbering class
makeChoiceLayout.m         : Defines the locations
convertChoiceLayout.m        : Convert geometry to pixels
randomizeChoicePositions.m : Decide which locations are occupied
DrawChoiceSet.m            : Draw stimuli and masks
collectChoiceResponse.m    : Collect subject's response
runChoiceTrial.m           : Run a single trial
runChoiceBlock.m           : Run the whole block
taskChoice                 : Run the whole task
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

## tasks/taskChoice.m

Top-level controller for the choice task.

% taskChoice  Run the choice task.
%
%   R = taskChoice(P, R, window, textures, ChoiceSets, maskTexture)
%
%   Runs the three choice-task blocks in the order specified by
%   P.Choice.blockOrder and stores the results in R.Choice.
%
%   Inputs:
%       P           - Parameter structure.
%       R           - Results structure.
%       window      - Psychtoolbox window pointer.
%       textures    - PTB textures indexed by image ID.
%       ChoiceSets  - Cell array containing the prepared choice sets
%                     for each set size.
%       maskTexture - PTB texture used for empty locations.
%
%   Output:
%       R           - Updated results structure.
%
%   ChoiceSets are organized by set-size index:
%
%       ChoiceSets{1} -> 6-item trials
%       ChoiceSets{2} -> 12-item trials
%       ChoiceSets{3} -> 24-item trials
%
%   The function only handles block execution and result storage.


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
## modules/makeChoiceLayout.m

makeChoiceLayout  Generate the fixed spatial layout for the choice task.
%
%   Layout = makeChoiceLayout(P)
%
%   Generates the fixed 30-location spatial layout used by the choice
%   task. The layout consists of 6 columns and 5 rows, with the stimulus
%   regions symmetrically distributed around a central fixation region.
%
%   All coordinates are normalized to the screen:
%       x = -0.5 ... +0.5
%       y = -0.5 ... +0.5
%
%   Inputs:
%       P       - Parameter structure containing Choice.Layout settings.
%
%   Output:
%       Layout  - Structure containing:
%                   .rect      30 × 4 matrix of stimulus rectangles
%                   .fixation  1 × 4 fixation rectangle
%
%   Rectangle format:
%       [left top right bottom]
%
%   The function only defines spatial geometry. It does not assign
%   stimuli, conditions, set sizes, or masks to locations.

---
## modules/convertChoiceLayout.m

function Layout = convertChoiceLayout(Layout, screenRect)

% convertChoiceLayout  Convert normalized layout coordinates to pixels.
%
%   Layout = convertChoiceLayout(Layout, screenRect)
%
%   Converts the normalized coordinates produced by makeChoiceLayout
%   into Psychtoolbox pixel coordinates.
%
%   Normalized coordinates:
%       x = -0.5 ... +0.5
%       y = -0.5 ... +0.5
%
%   Inputs:
%       Layout      - Layout generated by makeChoiceLayout.
%       screenRect  - Psychtoolbox screen rectangle:
%                     [left top right bottom]
%
%   Output:
%       Layout      - Layout with pixel-based rectangles.
%
%   The normalized layout is overwritten with pixel coordinates.

---
## modules/randomizeChoicePositions.m

function positions = randomizeChoicePositions(Layout, setSize)

% randomizeChoicePositions  Randomly assign occupied locations.
%
%   positions = randomizeChoicePositions(Layout, setSize)
%
%   Randomly selects setSize locations from the 30 fixed locations
%   generated by makeChoiceLayout. The remaining locations are
%   available for masking.
%
%   Inputs:
%       Layout  - Spatial layout generated by makeChoiceLayout.
%       setSize - Number of stimuli presented on the current trial.
%
%   Output:
%       positions.stimulus - Indices of occupied locations.
%       positions.empty     - Indices of unoccupied locations.
%
%   The function only handles spatial randomization. It does not assign
%   stimuli or conditions to the selected locations.

---
## modules/DrawChoiceSet.m

function drawChoiceSet(window, textures, ChoiceSet, Layout, positions, maskTexture)

% drawChoiceSet  Draw one choice-set display.
%
%   drawChoiceSet(window, textures, ChoiceSet, Layout, ...
%                 positions, maskTexture)
%
%   Draws the stimuli in ChoiceSet at their assigned locations and
%   fills all remaining locations with the mask texture.
%
%   Inputs:
%       window      - Psychtoolbox window pointer.
%       textures    - PTB textures indexed by image ID.
%       ChoiceSet   - Image IDs belonging to the current trial.
%       Layout      - Pixel-based layout generated by
%                     convertChoiceLayout.
%       positions   - Location assignment generated by
%                     randomizeChoicePositions.
%       maskTexture - PTB texture used for empty locations.
%
%   The function only draws. It does not randomize, convert coordinates,
%   collect responses, or modify results.

---
## modules/collectChoiceResponse.m

function [response, RT] = collectChoiceResponse(window, Layout)

% collectChoiceResponse  Collect a mouse click on the choice grid.
%
%   [response, RT] = collectChoiceResponse(window, Layout)
%
%   Waits for the participant to click one of the 30 cells in the
%   choice-task grid.
%
%   Inputs:
%       window  - Psychtoolbox window pointer.
%       Layout  - Pixel-based layout generated by
%                 convertChoiceLayout.
%
%   Outputs:
%       response - Index of the clicked cell (1 ... 30).
%       RT       - Response time in seconds.
%
%   The function only collects the mouse response. It does not determine
%   which stimulus occupies the selected location or modify R.

---
## modules/runChoiceTrial.m

function trial = runChoiceTrial( ...
    window, textures, ChoiceSet, Layout, maskTexture)

% runChoiceTrial  Run one choice-task trial.
%
%   trial = runChoiceTrial( ...
%       window, textures, ChoiceSet, Layout, maskTexture)
%
%   Presents one choice set, randomly assigns its stimuli to spatial
%   locations, displays the choice screen, and collects the participant's
%   mouse response.
%
%   Inputs:
%       window      - Psychtoolbox window pointer.
%       textures    - PTB textures indexed by image ID.
%       ChoiceSet   - Image IDs belonging to the current trial.
%       Layout      - Pixel-based layout generated by
%                     convertChoiceLayout.
%       maskTexture - PTB texture used for empty locations.
%
%   Output:
%       trial       - Structure containing:
%                       .choiceSet
%                       .positions
%                       .response
%                       .selectedImage
%                       .RT
%
%   The function only handles the sequence of one trial. It does not
%   generate choice sets, define the layout, or modify R.

---
## modules/runChoiceblock.m
function block = runChoiceBlock( ...
    window, textures, ChoiceSets, Layout, maskTexture)

% runChoiceBlock  Run all trials in one choice-task block.
%
%   block = runChoiceBlock( ...
%       window, textures, ChoiceSets, Layout, maskTexture)
%
%   Runs every choice trial in the supplied block and stores its results.
%
%   Inputs:
%       window      - Psychtoolbox window pointer.
%       textures    - PTB textures indexed by image ID.
%       ChoiceSets  - Cell array containing the choice set for each trial.
%       Layout      - Pixel-based choice-task layout.
%       maskTexture - PTB texture used for empty locations.
%
%   Output:
%       block       - Structure containing the results of each trial.

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
## utilities/getSetRatings.m

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
- Data recording structure
- Preference rating engine
- Fully-configurable preference rating task
- Personalized Choice Set curation engine
- Fully configutable choice task


## Planned

- Farsi Instruction screens
- Questionnaire
- EEG triggers
- Eye-tracker integration