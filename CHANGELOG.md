# Changelog

All notable changes to this project are documented in this file.

## [1.0.0] - 2026-03-07

### Added
- Insertable side label workflow with dovetail slot integration on the top female piece.
- Label debug fit preview with automatic alignment and manual debug offsets.
- Parameter descriptions in English for Customizer-facing controls.

### Changed
- Tuned thread defaults and fit behavior for practical FDM assembly.
- Improved male/female joint geometry and engagement behavior.
- Refined label geometry (plate, dovetail ramp, lower trim, side profile behavior).
- Reorganized Customizer into user-facing sections and hidden advanced controls.
- Linked several label safety trims and keepout values to base bevel logic for consistency.
- Exposed pattern controls again and updated defaults (`pattern_angle = 45`, `pattern_twist_gain = 1.0`, `pattern_depth_mm` max `0.8`).

### Removed
- Unused label parameters that no longer affected geometry (for example, legacy concavity/fit-clearance controls).

