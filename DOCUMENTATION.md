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

- execute Rating Round 1
- execute Rating Round 2
- compute average ratings

Contains no experimental logic itself.

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

## modules/readimg.m

Loads an image and creates a Psychtoolbox texture.

Returns:

- texture ID
- image width
- image height

---

## modules/computeAverageRating.m

Computes the average preference rating across both rounds.

Stores the result in

```
R.Preference.average
```

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

## Planned

- Instruction screens
- Practice block
- Personalized choice task
- Questionnaire
- EEG triggers
- Eye-tracker integration