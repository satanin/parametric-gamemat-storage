# Changelog

All notable changes to this project are documented in this file.

## [1.1.0] - 2026-03-08

### Added
- New side-rail label retention system on the female part (flat label insertion from the lower entry side).
- Single snap-lock behavior for labels using a triangular protrusion on the label and a matching pocket in the channel floor.
- New label snap tuning parameters: `label_snap_height_mm`, `label_snap_length_mm`, `label_snap_offset_mm`, `label_snap_width_factor`.
- New rail bite tuning parameter: `label_rail_bite_mm`.

### Changed
- Default `label_insert_clearance_mm` set to `0.25` and max range increased to `0.5` for practical print tolerances.
- Default `label_snap_height_mm` set to `0.4`.
- Default `label_override_min_wall_thickness_mm` reduced to `5.5` based on validation renders.
- Customizer step values normalized by range size to reduce excessive precision.

### Removed
- Legacy dovetail-dependent label variables/assertions that no longer affect geometry.

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
