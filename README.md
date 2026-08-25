# Choice Overload

MATLAB/Psychtoolbox implementation of a personalized choice-overload experiment with behavioral logging, EEG serial triggers, and EyeLink integration.

Current release candidate: **v0.4.0**

## Quick start

1. Install MATLAB and Psychtoolbox.
2. Review hardware and task settings in `Initialize/initializeParameters.m`.
3. Keep `P.Debug.enabled = true` for a hardware-free run.
4. Start MATLAB in the repository root.
5. Run:

```matlab
main
```

Participant MAT files and transferred EyeLink EDF files use the canonical `Data/` directory. Development event logs use `Logs/` when enabled.

## Tests

```matlab
addpath(genpath(pwd));
runValidationTests;
testAcquisitionContracts;
```

The EEG trigger smoke test, EyeLink recording test, and cross-device synchronization test require the target hardware.

## Documentation

- [Full experiment documentation](Docs/DOCUMENTATION.md)
- [Event codebook](Docs/EVENT_CODEBOOK.md)
- [Validation guide](Docs/Validation_Documentation.md)
- [Changelog](Docs/CHANGELOG.md)

## v0.4.0 validation status

EEG transmission has been tested with hardware. Behavioral event validation and acquisition lifecycle contracts have automated coverage. EyeLink hardware recording, EDF transfer, and EEG/EyeLink/behavioral synchronization still require an on-hardware validation run.
