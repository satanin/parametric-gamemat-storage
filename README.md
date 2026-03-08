# Parametric Map Storage Tube (OpenSCAD)

A parametric segmented tube for storing game mats/maps, designed for FDM printing.

Current stable release: **v1.1.0**.

## Features

- Automatic segmentation into printable pieces based on max part height.
- Male/female threaded joints between parts.
- Assembled preview mode and print-bed layout mode.
- Insertable side label for content identification.
- Flat insertable label retained by side rails (no dovetail tongue).
- Single snap-lock feature (triangular bump + matching pocket) to prevent labels from sliding out.
- Debug fit preview controls for fast visual validation.
- Simplified Customizer: essential parameters exposed, advanced parameters hidden.
- `threads-scad` compatibility for MakerWorld.

## Main Files

- `parametric_gamemat_storage.scad`: main model.
- `threads-scad/threads.scad`: thread library used by the model.
- `tubo_parametrico_mapas.json`: Customizer parameter preset.

## Dependency Policy

- The project vendors one local copy of `threads-scad` at `threads-scad/threads.scad`.
- Do not add a second `threads.scad` copy at repository root.
- Upstream source: <https://www.thingiverse.com/thing:1686322>
- License: CC0 1.0 Public Domain (as declared in the library header).

## Quick Start

1. Open `parametric_gamemat_storage.scad` in OpenSCAD.
2. Adjust parameters in the Customizer.
3. Export STL parts with `layout_mode = "print_bed"`.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history.

## MakerWorld Note

The main file includes:

```scad
include <threads-scad/threads.scad>;
```

and overrides `Demo()` to prevent the library's demo parts from appearing in the render.
