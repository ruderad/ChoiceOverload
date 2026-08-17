# Changelog

## v0.1.0 — First Executable Prototype

### Added
- Modular experiment architecture
- Three-structure design (`P`, `R`, `T`)
- Initialization framework
- Genereic renderer
- Preference rating task
- Psychtoolbox integration
- Image loading
- Slider-based rating interface
- Progress indicator
- Modular drawing and response collection

### Status
The preference rating task successfully executes from start to finish.
Remaining work is limited to interface refinement and participant experience.

### Planned
- Make it aesthetically pleasing
- Response collection with mouse?
- Use the new stimuli set

## v0.1.1 - Updated Stimulus Set

### Added
- Final set of Mug images containing 130 images
- added `.gitignore`


## v0.1.2 - Preference Rating Task: very nice both aestheticly and technically

- Implemented `P.Preference.Layout` to enable configuration of geometric layout of objects on screen
- Implemented *ruler-shaped* scale
- `normalizeScaleValue` utiliy function
- Improved and then removed progress indicator 
- Scaled Images
- `showMessageScreen` a genereic message render function
- `Instructions`/`round-complete`/`task-complete` screens
- `showBlankScreen` with configurable duration 
- response collection with mouse
- having `ESC` as an emeregency exit

### Planned

- Practice round 
- a system for getting the name and demographics of subjects
- figuring how to store individual results
- Persian instruction images
	- utility function to load image messages
	- making the instructions themselves
- Curation of personalized choice sets

## v0.1.3 - Result Saving System
- `collectSubjectInfo.m`: a pop-up window before the main task begins, asks for `subject ID`, `age`, `sex`, `handedness` and saves the results in `R.Subject`
- `saveResults`: a function that saves the whole `R` struct on a `.mat` file named `SubjectID.mat`
 

 ## v0.1.4 - Added practice round, improved round logic

 - `runRatingPractice.m` orchestrates the practrice round
 - Added two parameters (`P.Preference.nPracticeTrials` and `P.Preference.nTrialsPerRound`) to `intilizalizeParameters.m`
 - Small tweak on `initializeResults.m`
 - Improved `computeAverageRating.m`
 - `runRatingRound.m` can now run on configurable trial numbers
 - Modified `taskPreferenceRating.m` to accomodate the practice round 

### Planned

  - coming up with a solutoin to ensure that we have enough rating for each number to curate our stimulus sets
  - curation of set sizes`

## V0.2.0 - 'makeChoiceSets'
- `makeChoiceSets`, makes costume-sized choice sets in 5 conditions (`UL`,`UM`,`UH`,`CF`,`RS`)
- `selectClosestToRange.m` selects the nearest images to each uniform category in case the subject ratings are not sufficient.
- `getSetRating` a small utility function that shows every individual score in a given choiceSet

## V0.2.1 - 'taskChoice'
- `makeChoiceLayout`
- `convertChoiceLayout`
- `randomizeChoicePosition`
- `drawChoiceSet`
- `collectChoiceResponse`
- `runChoiceTrial`
- `runChoiceBlock`
- `taskChoice`

## v0.2.2 - 'temporal strucutre + questionnaire'
- fixed trial temporal structure of choice task
- `makeQuestionnaireLayout`
- `convertQuestionnaireLayout`


