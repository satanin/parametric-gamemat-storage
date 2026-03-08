/*
Parametric map/mat storage tube for FDM printing.
- Automatic segmentation with max piece height.
- End pieces are blind on the bed side when arranged for print.
- Intermediate pieces are hollow with female/male threaded ends.

OpenSCAD notes:
- `layout_mode = "print_bed"` arranges all parts on a centered 250x250 bed.
- `layout_mode = "assembled"` shows the final assembled tube.
*/
// =========================
// User parameters
// =========================
/* [Tube] */
// Final assembled internal usable length in millimeters.
total_length_mm = 430;        // [100:0.5:1200]
// Internal usable diameter in millimeters.
inner_diameter_mm = 65;       // [20:0.1:200]
// Wall thickness in millimeters.
wall_thickness_mm = 4.0;      // [2:0.05:20]

/* [Segmentation] */
// Maximum printable height per piece in millimeters.
max_piece_height_mm = 240;    // [60:0.5:350]
// Minimum number of pieces.
min_pieces = 2;               // [2:1:12]

/* [Thread] */
// Female thread engagement length in millimeters.
thread_length_mm = 40;        // [20:0.1:50]
// Diametric thread clearance in millimeters.
thread_clearance_mm = 0.60;   // [0:0.01:2]

/* [Layout] */
// Layout mode: print bed arrangement or assembled preview.
layout_mode = "print_bed";    // [print_bed, assembled]
// Print bed X size in millimeters.
bed_size_x_mm = 250;          // [120:1:500]
// Print bed Y size in millimeters.
bed_size_y_mm = 250;          // [120:1:500]

/* [Label] */
// Enable separate printable name labels.
label_enabled = true;
// Label width (tangential) in millimeters.
label_width_mm = 12;          // [8:0.05:18]
// Label requested length (axial) in millimeters.
label_length_mm = 120;        // [8:0.1:300]
// Label plate thickness in millimeters.
label_thickness_mm = 0.8;     // [0.8:0.05:2]
// Dovetail insert clearance in millimeters.
label_insert_clearance_mm = 0.1; // [0:0.01:0.1]
// End clearance for dovetail insertion in millimeters.
label_insert_end_clearance_mm = 0.50; // [0:0.01:5]
// Depth of the visible label face recess in millimeters.
label_face_recess_mm = 1.20;  // [0:0.01:10]

/* [Debug] */
// Show debug label preview next to top female slot.
label_debug_fit_preview = false;
// Base radial offset for debug preview in millimeters.
label_debug_gap_mm = 0.0;     // [-20:0.05:20]
// Additional debug preview X offset in millimeters (applied over auto alignment).
label_debug_offset_x_mm = 0.0;
// Additional debug preview Y offset in millimeters (applied over auto alignment).
label_debug_offset_y_mm = 0.0; // [-50:0.05:50]
// Additional debug preview Z offset in millimeters (applied over auto alignment).
label_debug_offset_z_mm = 0.0; // [-50:0.05:50]
// Additional debug preview rotation in degrees (applied over auto alignment).
label_debug_rotate_deg = 0.0; // [-180:0.1:180]

/* [Pattern] */
// Enable exterior surface pattern.
surface_pattern = false;
// Pattern groove depth in millimeters.
pattern_depth_mm = 0.20;      // [0.01:0.01:0.8]
// Number of pattern lanes per family.
pattern_lanes = 10;           // [2:1:40]
// Pattern angle in degrees.
pattern_angle = 45;           // [10:1:75]
// Pattern twist gain factor.
pattern_twist_gain = 1.0;     // [0.5:0.05:3]
// Pattern line width in millimeters.
pattern_line_width = 1.15;    // [0.2:0.01:3]

/* [Hidden] */
// Thread entry taper in millimeters.
thread_start_taper = 0.8;     // Entry taper for anti cross-threading (mm)
// Thread pitch in millimeters.
thread_pitch_mm = 10.0;
// Thread radial depth in millimeters.
thread_depth_mm = 0.65;
// Male thread shortfall versus female socket in millimeters.
male_thread_shortfall_mm = 5.0;
// Thread root fill fraction.
thread_root_fill = 0.32;      // 0..0.6: keeps thread root thick (prevents thin fins)
// Minimum wall thickness in thread zone in millimeters.
thread_min_wall = 1.0;        // Minimum wall in threaded zone (mm)
// Thread backend implementation.
thread_backend = "threads_scad"; // "threads_scad" (recommended) or "native"
// Thread tooth angle in degrees for threads.scad backend.
thread_tooth_angle = 80;      // Used by threads.scad backend
// Minimum tooth height clamp in millimeters.
thread_tooth_height_min = 0.20; // Safety clamp for threads.scad tooth_height
// Male thread end relief height in millimeters.
thread_end_relief_h = 0.0;    // Axial height of cylindrical relief at male thread tip
// Male thread end relief depth in millimeters.
thread_end_relief_depth = 1.10; // Radial amount removed at male thread tip
// Union overlap between body and thread in millimeters.
thread_union_overlap = 0.30;  // Overlap between tube body and male thread to avoid detached shells
// Shoulder blend height between body and thread in millimeters.
thread_shoulder_blend_h = 0.80; // Solid transition neck between body and thread
// End cap thickness in millimeters.
end_cap_thickness_mm = 3.7;   // Closed-end thickness (mm)
// End base bevel size in millimeters.
end_base_bevel_mm = 2.0;      // Tinkercad-like bevel size for end-piece bases (mm)
// Extra outer margin around connector in millimeters.
connector_outer_margin = 1.1; // Keeps thread hidden from outside silhouette (mm)
// Connector fit bias factor.
connector_fit_bias = 0.35;    // 0=min viable (more female wall), 1=max OD fill
// Equalize visible heights when assembled.
equalize_visible_heights = false; // true: balanced visible heights when assembled (may increase piece_count)
// Dovetail lip size in millimeters.
label_dovetail_lip = 0.90;    // Lateral undercut size for dovetail lock (mm)
// Side taper depth in millimeters.
label_side_taper = 0.9;       // Visible side taper depth from bottom to top (mm)
// Label end chamfer in millimeters.
label_end_chamfer = 1.2;      // End taper on label plate for smoother side profile (mm)
// Slot radial depth in millimeters (kept tied to label thickness).
label_slot_depth_mm = label_thickness_mm;
// Extra trim for label plate lower side in millimeters (kept tied to base bevel).
label_part_bottom_trim_mm = end_base_bevel_mm;
// Extra trim for dovetail lower side in millimeters (kept tied to base bevel).
label_dovetail_bottom_trim_mm = end_base_bevel_mm;
// Extra keepout above lower relief area in millimeters (kept tied to base bevel).
label_bottom_keepout_mm = end_base_bevel_mm;
// Margin from slot ends in millimeters.
label_slot_z_margin_mm = 2.0;
// Fixed label count while only one insert slot is supported.
label_count = 1;              // Single insert slot currently supported
// Keep insert mode always enabled in current design.
label_insert_enabled = true;  // Label insert mode is mandatory in current design
// Keep label side walls flat in current design.
label_curved_sides = false;
// Auto-disable thread-zone restriction if wall is thick enough.
label_auto_thread_override = true;
// Minimum wall thickness to allow auto thread-zone override in millimeters.
label_override_min_wall_thickness_mm = 6.0;
// Spacing between labels on print bed in millimeters (currently irrelevant with single label).
label_print_spacing_mm = 8;
// Pattern bottom margin baseline in millimeters (derived per-piece from bevel).
pattern_bottom_margin = 0;
// Pattern top margin baseline in millimeters (kept equal to bottom margin).
pattern_top_margin = pattern_bottom_margin;

// Rendering detail (higher than default for smoother cylinders)
// Angular fragment size in degrees.
$fa = 1;
// Minimum fragment size in millimeters.
$fs = 0.45;

// Internal mapping from UI variables to model variables.
total_length = total_length_mm;
inner_diameter = inner_diameter_mm;
wall_thickness = wall_thickness_mm;
max_piece_height = max_piece_height_mm;
thread_length = thread_length_mm;
thread_pitch = thread_pitch_mm;
thread_depth = thread_depth_mm;
thread_clearance = thread_clearance_mm;
male_thread_shortfall = male_thread_shortfall_mm;
end_cap_thickness = end_cap_thickness_mm;
end_base_bevel = end_base_bevel_mm;
bed_size_x = bed_size_x_mm;
bed_size_y = bed_size_y_mm;
label_width = label_width_mm;
label_length = label_length_mm;
label_thickness = label_thickness_mm;
label_insert_clearance = label_insert_clearance_mm;
label_insert_end_clearance = label_insert_end_clearance_mm;
label_face_recess = label_face_recess_mm;
label_slot_depth = label_slot_depth_mm;
label_override_min_wall_thickness = label_override_min_wall_thickness_mm;
label_slot_z_margin = label_slot_z_margin_mm;
label_bottom_keepout = label_bottom_keepout_mm;
label_part_bottom_trim = label_part_bottom_trim_mm;
label_dovetail_bottom_trim = label_dovetail_bottom_trim_mm;
label_print_spacing = label_print_spacing_mm;
label_debug_gap = label_debug_gap_mm;
label_debug_offset_x = label_debug_offset_x_mm;
label_debug_offset_y = label_debug_offset_y_mm;
label_debug_offset_z = label_debug_offset_z_mm;
pattern_depth = pattern_depth_mm;

// =========================
// Derived values
// =========================
outer_diameter = inner_diameter + 2 * wall_thickness;
male_thread_length = thread_length - male_thread_shortfall;
joint_overlap_length = male_thread_length;

connector_major_max_d = outer_diameter - 2 * connector_outer_margin;
connector_major_min_d = inner_diameter + 2 * (thread_min_wall + thread_depth);
connector_major_d = connector_major_min_d + (connector_major_max_d - connector_major_min_d) * connector_fit_bias;
connector_core_d = connector_major_d - 2 * thread_depth;
thread_tooth_height_target = 2 * thread_depth * tan(thread_tooth_angle);
thread_tooth_height = min(thread_pitch * 0.90, max(thread_tooth_height_min, thread_tooth_height_target));

min_connector_wall = (connector_core_d - inner_diameter) / 2;

// Recursive piece count so each physical part <= max_piece_height.
function physical_piece_height(target_len, joint_len, n, eq_vis=false) =
    eq_vis ? (target_len / n + joint_len) : ((target_len + (n - 1) * joint_len) / n);

function compute_piece_count(target_len, joint_len, max_h, eq_vis=false, n=min_pieces) =
    (physical_piece_height(target_len, joint_len, n, eq_vis) <= max_h)
    ? n
    : compute_piece_count(target_len, joint_len, max_h, eq_vis, n + 1);

piece_count = compute_piece_count(total_length, joint_overlap_length, max_piece_height, equalize_visible_heights);
segment_visible_height = total_length / piece_count;
piece_height_male = physical_piece_height(total_length, joint_overlap_length, piece_count, equalize_visible_heights);
piece_height_top = equalize_visible_heights ? segment_visible_height : piece_height_male;
label_restrict_thread_zone = !(label_auto_thread_override && wall_thickness >= label_override_min_wall_thickness);
label_slot_excluded_bottom = label_restrict_thread_zone ? thread_length : 0;
label_slot_min_z = label_slot_excluded_bottom + label_slot_z_margin + label_bottom_keepout;
label_length_limit = min(150, piece_height_top - label_slot_min_z);
label_length_eff = min(label_length, label_length_limit); // Used by negative slot
label_slot_length_eff = label_length_eff; // Exact negative slot reference length
label_tag_length_eff = max(0.2, label_slot_length_eff - label_part_bottom_trim); // Positive/debug plate = slot minus bevel distance

// =========================
// Safety checks
// =========================
assert(total_length > 0, "total_length must be > 0");
assert(inner_diameter > 0, "inner_diameter must be > 0");
assert(wall_thickness > 0, "wall_thickness must be > 0");
assert(thread_length > 0, "thread_length must be > 0");
assert(male_thread_shortfall >= 0 && male_thread_shortfall < thread_length, "male_thread_shortfall must be in [0, thread_length)");
assert(male_thread_length > 0, "male_thread_length must be > 0");
assert(thread_pitch > 0, "thread_pitch must be > 0");
assert(thread_depth > 0, "thread_depth must be > 0");
assert(thread_tooth_height > 0 && thread_tooth_height < thread_pitch, "Invalid thread geometry after clamping: tooth_height must be in (0, pitch)");
assert(thread_start_taper >= 0 && thread_start_taper <= thread_length / 2, "thread_start_taper must be between 0 and thread_length/2");
assert(thread_root_fill >= 0 && thread_root_fill < 0.7, "thread_root_fill must be in [0, 0.7)");
assert(thread_min_wall >= 0.9, "thread_min_wall should be >= 0.9 for FDM strength");
assert(thread_backend == "threads_scad" || thread_backend == "native", "thread_backend must be \"threads_scad\" or \"native\"");
assert(connector_fit_bias >= 0 && connector_fit_bias <= 1, "connector_fit_bias must be in [0,1]");
assert(end_base_bevel >= 0 && end_base_bevel < outer_diameter/4, "end_base_bevel out of range");
assert(thread_end_relief_h >= 0 && thread_end_relief_h < male_thread_length/2, "thread_end_relief_h must be in [0, male_thread_length/2)");
assert(thread_end_relief_depth >= 0 && thread_end_relief_depth <= (thread_depth + thread_min_wall * 0.8), "thread_end_relief_depth too large for current thread wall");
assert(thread_union_overlap >= 0 && thread_union_overlap < male_thread_length/2, "thread_union_overlap must be in [0, male_thread_length/2)");
assert(thread_shoulder_blend_h >= 0 && thread_shoulder_blend_h < male_thread_length/2, "thread_shoulder_blend_h must be in [0, male_thread_length/2)");
assert(piece_height_male <= max_piece_height + 1e-6, "Piece height exceeds max_piece_height");
assert(connector_major_min_d <= connector_major_max_d + 1e-6, "Not enough wall for internal thread. Increase wall_thickness or reduce thread_depth/thread_min_wall.");
assert(connector_major_d <= outer_diameter + 1e-6, "Thread connector exceeds outer diameter. Increase wall_thickness or reduce connector_outer_margin.");
assert(connector_major_d > inner_diameter + 2.0, "Connector too thin. Increase wall_thickness or reduce margins.");
assert(min_connector_wall >= thread_min_wall - 1e-6, "Connector wall too thin. Increase wall_thickness or reduce thread_depth.");
assert(
    end_cap_thickness < (equalize_visible_heights ? piece_height_top : (piece_height_male - male_thread_length)),
    "end_cap_thickness too large for current piece geometry."
);
assert(label_count >= 0, "label_count must be >= 0");
assert(label_width > 6 && label_length > 10, "label dimensions are too small.");
assert(label_thickness >= 0.8, "label_thickness should be >= 0.8 mm");
assert(label_insert_clearance >= 0, "label_insert_clearance must be >= 0");
assert(label_insert_end_clearance >= 0, "label_insert_end_clearance must be >= 0");
assert(label_dovetail_lip >= 0, "label_dovetail_lip must be >= 0");
assert(label_face_recess >= 0 && label_face_recess < wall_thickness, "label_face_recess must be in [0, wall_thickness)");
assert(label_curved_sides == true || label_curved_sides == false, "label_curved_sides must be boolean");
assert(label_side_taper >= 0, "label_side_taper must be >= 0");
assert(label_end_chamfer >= 0 && label_end_chamfer < label_length / 3, "label_end_chamfer out of range");
assert(label_slot_depth > 0 && label_slot_depth < wall_thickness, "label_slot_depth must be in (0, wall_thickness)");
assert(label_auto_thread_override == true || label_auto_thread_override == false, "label_auto_thread_override must be boolean");
assert(label_override_min_wall_thickness >= 0, "label_override_min_wall_thickness must be >= 0");
assert(label_slot_z_margin >= 0, "label_slot_z_margin must be >= 0");
assert(label_bottom_keepout >= 0, "label_bottom_keepout must be >= 0");
assert(label_part_bottom_trim >= 0, "label_part_bottom_trim must be >= 0");
assert(label_dovetail_bottom_trim >= 0, "label_dovetail_bottom_trim must be >= 0");
assert(label_length_limit > 8, "No room for label slot with current thread/margin constraints.");
assert(label_tag_length_eff > 0, "Computed label_tag_length_eff must be > 0");
assert(label_debug_fit_preview == true || label_debug_fit_preview == false, "label_debug_fit_preview must be boolean");
assert(label_debug_offset_x >= -200 && label_debug_offset_x <= 200, "label_debug_offset_x out of practical range");
assert(label_debug_offset_y >= -200 && label_debug_offset_y <= 200, "label_debug_offset_y out of practical range");
assert(label_debug_offset_z >= -200 && label_debug_offset_z <= 200, "label_debug_offset_z out of practical range");
assert(label_debug_rotate_deg >= -180 && label_debug_rotate_deg <= 180, "label_debug_rotate_deg out of range");

echo("---- Tube summary ----");
echo(str("piece_count = ", piece_count));
echo(str("piece_height_male = ", piece_height_male));
echo(str("piece_height_top = ", piece_height_top));
echo(str("outer_diameter = ", outer_diameter));
echo(str("label_slot_length_eff = ", label_slot_length_eff));
echo(str("label_part_bottom_trim = ", label_part_bottom_trim));
echo(str("label_tag_length_eff = ", label_tag_length_eff));

// Keep include below the Customizer parameters so OpenSCAD can detect them.
include <threads-scad/threads.scad>;

// Override demo from threads.scad so cloud include does not render sample parts.
module Demo() {}

// =========================
// Thread geometry helpers
// =========================
module buttress_thread_ridge_2d(pitch, depth) {
    // Asymmetric buttress-like profile tuned for plastic parts.
    // Steeper "load" flank, gentler "relief" flank, broad crest/root.
    root = depth * thread_root_fill;
    crest = depth;
    polygon([
        [0, 0],
        [root, 0.06 * pitch],               // root rounding
        [crest, 0.18 * pitch],              // steep load flank
        [crest, 0.52 * pitch],              // broad crest
        [root + 0.20 * (depth - root), 0.84 * pitch], // gentle relief flank
        [root, 0.95 * pitch],               // root rounding
        [0, pitch]
    ]);
}

module native_external_thread_solid(major_d, length, pitch, depth) {
    turns = length / pitch;
    union() {
        cylinder(d = major_d - 2 * depth, h = length);
        linear_extrude(
            height = length,
            twist = 360 * turns,
            slices = max(64, ceil(turns * 64)),
            convexity = 10
        )
            translate([(major_d - 2 * depth) / 2, 0, 0])
                buttress_thread_ridge_2d(pitch, depth);

        // Gentle entry/exit taper to improve engagement in plastics.
        cylinder(
            h = thread_start_taper,
            d1 = major_d - depth,
            d2 = major_d
        );
        translate([0, 0, length - thread_start_taper])
            cylinder(
                h = thread_start_taper,
                d1 = major_d,
                d2 = major_d - depth
            );
    }
}

module external_thread_solid(major_d, length, pitch, depth) {
    if (thread_backend == "threads_scad") {
        // External thread from threads.scad (more robust than custom sweep).
        ScrewThread(
            outer_diam = major_d,
            height = length,
            pitch = pitch,
            tooth_angle = thread_tooth_angle,
            tolerance = 0,
            tip_height = 0,
            tooth_height = thread_tooth_height,
            tip_min_fract = 0.25
        );
    } else {
        native_external_thread_solid(major_d, length, pitch, depth);
    }
}

module internal_thread_cut(major_d, length, pitch, depth, clr) {
    // Slightly oversized male thread used as boolean cutter for female thread.
    if (thread_backend == "threads_scad") {
        ScrewThread(
            outer_diam = major_d + clr,
            height = length + 0.02,
            pitch = pitch,
            tooth_angle = thread_tooth_angle,
            tolerance = 0,
            tip_height = thread_start_taper,
            tooth_height = thread_tooth_height,
            tip_min_fract = 0.25
        );
    } else {
        external_thread_solid(
            major_d = major_d + 2 * clr,
            length = length + 0.02,
            pitch = pitch,
            depth = depth + 0.35 * clr
        );
    }
}

module male_spigot(length) {
    relief_h = max(0, min(thread_end_relief_h, length));
    threaded_h = max(0, length - relief_h);
    relief_tip_d = max(inner_diameter + 0.2, connector_major_d - 2 * thread_end_relief_depth);

    difference() {
        union() {
            if (threaded_h > 0)
                external_thread_solid(
                    major_d = connector_major_d,
                    length = threaded_h,
                    pitch = thread_pitch,
                    depth = thread_depth
                );

            // Straight pilot at tip: true cylindrical relief + flat end.
            if (relief_h > 0)
                translate([0, 0, threaded_h])
                    cylinder(h = relief_h, d = relief_tip_d);
        }

        translate([0, 0, -0.1])
            cylinder(d = inner_diameter, h = length + 0.2);
    }
}

// =========================
// Surface pattern
// =========================
module pattern_grooves(h, z0) {
    r = outer_diameter / 2 - pattern_depth * 0.5;
    circumference = 2 * PI * r;
    lane_count = max(16, pattern_lanes);
    lane_step = 360 / lane_count;
    lead = circumference / max(0.15, tan(pattern_angle));
    twist_deg = 360 * (h / lead) * pattern_twist_gain;
    groove_w = max(0.75, pattern_line_width);
    groove_radial = max(0.8, pattern_depth * 2.0);
    slices_n = max(72, ceil(h * 2.8));

    for (a = [0 : lane_step : 360 - lane_step]) {
        // Family A helical grooves.
        rotate([0, 0, a])
            translate([0, 0, z0])
                linear_extrude(
                    height = h,
                    twist = twist_deg,
                    slices = slices_n,
                    convexity = 8
                )
                    translate([r, 0, 0])
                        square([groove_radial, groove_w], center = true);

        // Family B, opposite helix and half-step phase for clearer diamonds.
        rotate([0, 0, a + lane_step * 0.5])
            translate([0, 0, z0])
                linear_extrude(
                    height = h,
                    twist = -twist_deg,
                    slices = slices_n,
                    convexity = 8
                )
                    translate([r, 0, 0])
                        square([groove_radial, groove_w], center = true);
    }
}

module beveled_outer_body(h, bevel_bottom=false, bevel_top=false) {
    bb = (bevel_bottom ? end_base_bevel : 0);
    tb = (bevel_top ? end_base_bevel : 0);
    mid_h = h - bb - tb;

    if (bb > 0)
        cylinder(h = bb, d1 = outer_diameter - 2 * bb, d2 = outer_diameter);

    if (mid_h > 0)
        translate([0, 0, bb])
            cylinder(h = mid_h, d = outer_diameter);

    if (tb > 0)
        translate([0, 0, h - tb])
            cylinder(h = tb, d1 = outer_diameter, d2 = outer_diameter - 2 * tb);
}

// =========================
// Generic piece builder
// =========================
module tube_piece(h, female_bottom=false, male_top=false, closed_bottom=false, closed_top=false, bevel_bottom=false, bevel_top=false) {
    body_h = h - (male_top ? male_thread_length : 0);

    difference() {
        union() {
            beveled_outer_body(body_h, bevel_bottom = bevel_bottom, bevel_top = bevel_top);
            if (male_top) {
                // Solid transition neck: guarantees there is no gap between
                // main body and threaded section (print-safe manifold).
                translate([0, 0, body_h - thread_union_overlap])
                    cylinder(
                        h = thread_shoulder_blend_h + thread_union_overlap,
                        d1 = outer_diameter,
                        d2 = connector_major_d
                    );

                // Start thread after the transition neck.
                translate([0, 0, body_h - thread_union_overlap + thread_shoulder_blend_h])
                    male_spigot(male_thread_length + thread_union_overlap - thread_shoulder_blend_h);
            }
        }

        // Main bore (reduced by end caps when required).
        main_bore_z0 = closed_bottom ? end_cap_thickness : 0;
        main_bore_z1 = closed_top ? (h - end_cap_thickness) : h;

        if (main_bore_z1 > main_bore_z0)
            translate([0, 0, main_bore_z0 - 0.05])
                cylinder(d = inner_diameter, h = (main_bore_z1 - main_bore_z0) + 0.10);

        // Female threaded socket at the lower side.
        if (female_bottom) {
            translate([0, 0, -0.01])
                internal_thread_cut(
                    major_d = connector_major_d,
                    length = thread_length,
                    pitch = thread_pitch,
                    depth = thread_depth,
                    clr = thread_clearance
                );

            // Lead-in chamfer to help threading.
            translate([0, 0, -0.01])
                cylinder(
                    h = 1.2,
                    d1 = connector_major_d + thread_clearance + 0.7,
                    d2 = connector_major_d + thread_clearance
                );

            // Optional side dovetail slot for label insertion on the top female end piece only.
            if (label_insert_enabled && closed_top) {
                slot_face_w = label_width + 2 * label_insert_clearance;
                slot_neck_w = max(4.0, label_width * 0.55 + 2 * label_insert_clearance);
                slot_head_w = min(slot_face_w - 0.4, slot_neck_w + 2 * label_dovetail_lip);
                slot_min_z = label_slot_excluded_bottom + label_slot_z_margin + label_bottom_keepout;
                slot_len_max = max(8, h - slot_min_z);
                slot_len = min(label_length_eff, slot_len_max);
                // Keep insertion opening at the top edge so the label can slide in.
                slot_z0 = h - slot_len;
                pocket_x0 = outer_diameter / 2 - label_face_recess - 0.02;
                // Start dovetail neck right at pocket floor so the label does not "float".
                channel_neck_x = outer_diameter / 2 - label_face_recess - 0.02;
                channel_root_x = channel_neck_x - label_slot_depth;

                // Shallow flat pocket to keep the visible label surface close to flush.
                translate([pocket_x0, -slot_face_w / 2, slot_z0 - 0.01])
                    cube([label_face_recess + 0.06, slot_face_w, slot_len + 0.02]);

                // Real dovetail channel under the pocket floor.
                translate([0, 0, slot_z0 - 0.01])
                    linear_extrude(height = slot_len + 0.02, convexity = 8)
                        polygon([
                            [channel_neck_x, -slot_neck_w / 2],
                            [channel_root_x, -slot_head_w / 2],
                            [channel_root_x,  slot_head_w / 2],
                            [channel_neck_x,  slot_neck_w / 2]
                        ]);
            }
        }

        // Decorative/functional grip pattern on the visible body area.
        if (surface_pattern) {
            pattern_z0 = (bevel_bottom ? end_base_bevel : 0) + pattern_bottom_margin;
            pattern_z1 = body_h - ((bevel_top ? end_base_bevel : 0) + pattern_top_margin);
            pattern_h = pattern_z1 - pattern_z0;

            if (pattern_h > 2)
                pattern_grooves(pattern_h, pattern_z0);
        }
    }
}

// =========================
// Specific parts
// =========================
module bottom_end_piece(h) {
    // Blind at bottom (bed side in print), male thread on top.
    tube_piece(
        h = h,
        female_bottom = false,
        male_top = true,
        closed_bottom = true,
        closed_top = false,
        bevel_bottom = true,
        bevel_top = false
    );
}

module middle_piece(h) {
    // Hollow part with female bottom and male top.
    tube_piece(
        h = h,
        female_bottom = true,
        male_top = true,
        closed_bottom = false,
        closed_top = false,
        bevel_bottom = false,
        bevel_top = false
    );
}

module top_end_piece(h) {
    // Female bottom and blind top in assembled orientation.
    tube_piece(
        h = h,
        female_bottom = true,
        male_top = false,
        closed_bottom = false,
        closed_top = true,
        bevel_bottom = false,
        bevel_top = true
    );
}

function arc_side_inset(z, r) =
    (z <= 0 || r <= 0 || z >= r)
    ? 0
    : r - sqrt(max(0.0001, r * r - z * z));

module label_plate_body(width, length, thickness, side_r, side_samples=20) {
    if (!label_curved_sides || side_r <= 0 || side_r <= thickness) {
        difference() {
            cube([width, length, thickness]);

            if (label_end_chamfer > 0) {
                // Front end chamfer.
                translate([-0.02, -0.01, thickness - label_end_chamfer])
                    rotate([0, 90, 0])
                        linear_extrude(height = width + 0.04)
                            polygon([[0, 0], [label_end_chamfer + 0.02, 0], [0, label_end_chamfer + 0.02]]);

                // Back end chamfer.
                translate([-0.02, length + 0.01, thickness - label_end_chamfer])
                    rotate([0, 90, 0])
                        linear_extrude(height = width + 0.04)
                            polygon([[0, 0], [0, -label_end_chamfer - 0.02], [label_end_chamfer + 0.02, 0]]);
            }
        }
    } else {
        difference() {
            translate([0, length, 0])
                rotate([90, 0, 0])
                linear_extrude(height = length, convexity = 8)
                    polygon(
                        concat(
                            [for (i = [0 : side_samples])
                                let(
                                    z = i * thickness / side_samples,
                                    curved = arc_side_inset(z, side_r),
                                    tapered = label_side_taper * (1 - z / max(0.001, thickness)),
                                    inset = min(width / 2 - 0.2, max(curved, tapered))
                                )
                                    [inset, z]
                            ],
                            [for (i = [side_samples : -1 : 0])
                                let(
                                    z = i * thickness / side_samples,
                                    curved = arc_side_inset(z, side_r),
                                    tapered = label_side_taper * (1 - z / max(0.001, thickness)),
                                    inset = min(width / 2 - 0.2, max(curved, tapered))
                                )
                                    [width - inset, z]
                            ]
                        )
                    );

            if (label_end_chamfer > 0) {
                // Front end chamfer.
                translate([-0.02, -0.01, thickness - label_end_chamfer])
                    rotate([0, 90, 0])
                        linear_extrude(height = width + 0.04)
                            polygon([[0, 0], [label_end_chamfer + 0.02, 0], [0, label_end_chamfer + 0.02]]);

                // Back end chamfer.
                translate([-0.02, length + 0.01, thickness - label_end_chamfer])
                    rotate([0, 90, 0])
                        linear_extrude(height = width + 0.04)
                            polygon([[0, 0], [0, -label_end_chamfer - 0.02], [label_end_chamfer + 0.02, 0]]);
            }
        }
    }
}

// =========================
// Label tag
// =========================
module content_label_tag() {
    slot_face_w = label_width + 2 * label_insert_clearance;
    slot_neck_w = max(4.0, label_width * 0.55 + 2 * label_insert_clearance);
    slot_head_w = min(slot_face_w - 0.4, slot_neck_w + 2 * label_dovetail_lip);
    rail_neck_w = max(3.2, slot_neck_w - 2 * label_insert_clearance);
    rail_head_w = max(rail_neck_w + 0.4, slot_head_w - 2 * label_insert_clearance);
    rail_d = max(0.6, label_slot_depth - label_insert_clearance);
    // Lower end (insertion-start side) begins at the label edge.
    rail_start = 0;
    rail_end_clear = label_insert_end_clearance;
    rail_len = max(0.8, label_slot_length_eff - rail_end_clear);
    // Trim run for dovetail relief (allow full user control over visible ramp length).
    rail_trim = min(label_dovetail_bottom_trim, max(0, rail_len - 0.8));
    // Keep full profile from the lower edge and trim at the opposite end.
    rail_main_start = rail_start;
    rail_main_len = max(0.6, rail_len - rail_trim);
    rail_ramp_start = rail_start + rail_main_len;
    // Exact plate rule: negative slot length minus female bevel/chamfer distance.
    plate_len = label_tag_length_eff;
    rail_x_neck = (label_width - rail_neck_w) / 2;
    rail_x_head = (label_width - rail_head_w) / 2;
    side_curve_r = outer_diameter / 2;

    union() {
        // Visible face is fully flat (good for printing text/colors).
        label_plate_body(label_width, plate_len, label_thickness, side_curve_r);

        if (label_insert_enabled)
            union() {
                // Main dovetail tongue keeps full usable length.
                hull() {
                    translate([rail_x_neck, rail_main_start, label_thickness])
                        cube([rail_neck_w, rail_main_len, 0.02]);
                    translate([rail_x_head, rail_main_start, label_thickness + rail_d])
                        cube([rail_head_w, rail_main_len, 0.02]);
                }

                // Ramp on trimmed side, keeping a clean 45 deg-like relief.
                if (rail_trim > 0.05)
                    hull() {
                        // Full profile at ramp start.
                        translate([rail_x_neck, rail_ramp_start, label_thickness])
                            cube([rail_neck_w, 0.02, 0.02]);
                        translate([rail_x_head, rail_ramp_start, label_thickness + rail_d])
                            cube([rail_head_w, 0.02, 0.02]);

                        // Tiny section at trimmed tip on the rail outer face (not label-contact face).
                        translate([rail_x_neck + rail_neck_w * 0.25, rail_start + rail_len, label_thickness + rail_d - 0.02])
                            cube([rail_neck_w * 0.5, 0.02, 0.02]);
                        translate([rail_x_head + rail_head_w * 0.25, rail_start + rail_len, label_thickness + rail_d - 0.02])
                            cube([rail_head_w * 0.5, 0.02, 0.02]);
                    }
            }
    }
}

module part_by_index(idx) {
    if (idx == 0)
        bottom_end_piece(piece_height_male);
    else if (idx == piece_count - 1)
        top_end_piece(piece_height_top);
    else
        middle_piece(piece_height_male);
}

module part_for_print(idx) {
    // Keep blind side of both end pieces against the print bed.
    if (idx == piece_count - 1)
        translate([0, 0, piece_height_top])
            rotate([180, 0, 0])
                part_by_index(idx);
    else
        part_by_index(idx);
}

module label_fit_preview_local(h_local) {
    slot_min_z = label_slot_excluded_bottom + label_slot_z_margin + label_bottom_keepout;
    slot_len = min(label_length_eff, max(8, piece_height_top - slot_min_z));
    slot_z0 = h_local - slot_len;
    rail_d = max(0.6, label_slot_depth - label_insert_clearance);
    radial_extent = label_thickness + rail_d;
    // Auto-align debug label from current geometry so it tracks diameter/label changes.
    dbg_auto_offset_x = -0.6 * label_width;
    dbg_auto_offset_y = -label_dovetail_lip;
    dbg_auto_offset_z = 0;
    dbg_auto_rotate_deg = -90;
    x_pos = outer_diameter / 2 + label_debug_gap + dbg_auto_offset_x + label_debug_offset_x;
    y_pos = radial_extent + dbg_auto_offset_y + label_debug_offset_y;
    z_pos = slot_z0 + dbg_auto_offset_z + label_debug_offset_z;
    dbg_len = label_tag_length_eff;
    dbg_center_x = label_width / 2;
    dbg_center_y = -radial_extent / 2;
    dbg_center_z = dbg_len / 2;

    color([1.0, 0.15, 0.15, 0.85])
        translate([x_pos, y_pos, z_pos])
            // Keep label length aligned with Z (tube axis) and rotate around placed Z axis at label center.
            translate([dbg_center_x, dbg_center_y, dbg_center_z])
                rotate([0, 0, dbg_auto_rotate_deg + label_debug_rotate_deg])
                    translate([-dbg_center_x, -dbg_center_y, -dbg_center_z])
                        rotate([90, 0, 0])
                            content_label_tag();
}

module label_fit_preview_in_assembled() {
    top_piece_z0 = (piece_count - 1) * (piece_height_male - joint_overlap_length);
    translate([0, 0, top_piece_z0])
        label_fit_preview_local(piece_height_top);
}

// =========================
// Layouts
// =========================
module print_bed_layout() {
    cols = max(1, ceil(sqrt(piece_count)));
    rows = max(1, ceil(piece_count / cols));

    step_x = bed_size_x / cols;
    step_y = bed_size_y / rows;

    echo(str("print grid cols/rows = ", cols, " / ", rows));
    if (step_x < outer_diameter || step_y < outer_diameter)
        echo("WARNING: Parts may overlap on the selected bed size.");

    for (i = [0 : piece_count - 1]) {
        col = i % cols;
        row = floor(i / cols);

        x = -bed_size_x / 2 + step_x * (col + 0.5);
        y = -bed_size_y / 2 + step_y * (row + 0.5);

        translate([x, y, 0])
            part_for_print(i);
    }

    // Optional separate name tags (flat on bed, concavity up).
    if (label_enabled && label_count > 0) {
        tag_step = label_width + label_print_spacing;
        tag_span = (label_count - 1) * tag_step;
        tag_x0 = -tag_span / 2;
        tag_y = -bed_size_y / 2 + label_tag_length_eff * 0.6 + 2;

        if (tag_step * label_count > bed_size_x)
            echo("WARNING: Labels may exceed bed width. Reduce label_count/label_width or increase bed_size_x.");

        for (j = [0 : label_count - 1]) {
            translate([tag_x0 + j * tag_step, tag_y, 0])
                content_label_tag();
        }
    }

    // Debug overlay: show a vertical label copy near the printed top piece slot.
    if (label_debug_fit_preview) {
        i_top = piece_count - 1;
        col_t = i_top % cols;
        row_t = floor(i_top / cols);
        x_t = -bed_size_x / 2 + step_x * (col_t + 0.5);
        y_t = -bed_size_y / 2 + step_y * (row_t + 0.5);

        translate([x_t, y_t, 0])
            translate([0, 0, piece_height_top])
                rotate([180, 0, 0])
                    label_fit_preview_local(piece_height_top);
    }
}

module assembled_layout() {
    // Stack pieces and overlap each joint by effective male insertion length.
    for (i = [0 : piece_count - 1]) {
        z = i * (piece_height_male - joint_overlap_length);
        translate([0, 0, z])
            part_by_index(i);
    }

    if (label_debug_fit_preview)
        label_fit_preview_in_assembled();
}

if (layout_mode == "assembled")
    assembled_layout();
else
    print_bed_layout();
