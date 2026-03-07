/*
Parametric map/mat storage tube for FDM printing.
- Automatic segmentation with max piece height.
- End pieces are blind on the bed side when arranged for print.
- Intermediate pieces are hollow with female/male threaded ends.

OpenSCAD notes:
- `layout_mode = "print_bed"` arranges all parts on a centered 250x250 bed.
- `layout_mode = "assembled"` shows the final assembled tube.
*/
include <threads-scad/threads.scad>;

// Override demo from threads.scad so cloud include does not render sample parts.
module Demo() {}

// =========================
// User parameters
// =========================
total_length = 430;           // Final assembled tube length (mm)
inner_diameter = 65;          // Internal usable diameter (mm)
wall_thickness = 4.0;         // Tube wall thickness (mm)

max_piece_height = 240;       // Printability limit per piece (mm)
min_pieces = 2;               // Always at least two pieces

thread_length = 40;           // Axial engagement length for each joint (mm)
thread_pitch = 10.0;          // Balanced pitch for easier start + good strength
thread_depth = 0.65;          // Reduced radial height to avoid bulky male thread
thread_clearance = 0.60;      // Diametric extra clearance on female thread cut
male_thread_shortfall = 5.0;  // Male thread is shorter than female socket (mm)
thread_start_taper = 0.8;     // Entry taper for anti cross-threading (mm)
thread_root_fill = 0.32;      // 0..0.6: keeps thread root thick (prevents thin fins)
thread_min_wall = 1.0;        // Minimum wall in threaded zone (mm)
thread_backend = "threads_scad"; // "threads_scad" (recommended) or "native"
thread_tooth_angle = 80;      // Used by threads.scad backend
thread_tooth_height_min = 0.20; // Safety clamp for threads.scad tooth_height
thread_end_relief_h = 0.0;    // Axial height of cylindrical relief at male thread tip
thread_end_relief_depth = 1.10; // Radial amount removed at male thread tip
thread_union_overlap = 0.30;  // Overlap between tube body and male thread to avoid detached shells
thread_shoulder_blend_h = 0.80; // Solid transition neck between body and thread

end_cap_thickness = 3.7;      // Closed-end thickness (mm)
connector_outer_margin = 1.1; // Keeps thread hidden from outside silhouette (mm)
connector_fit_bias = 0.35;    // 0=min viable (more female wall), 1=max OD fill
end_base_bevel = 2.0;         // Tinkercad-like bevel size for end-piece bases

layout_mode = "print_bed";    // "print_bed" or "assembled"
bed_size_x = 250;
bed_size_y = 250;

label_enabled = true;          // Adds printable name tags for content identification
label_count = 1;               // How many tags to place on the bed
label_width = 24;              // Tangential size (mm)
label_length = 120;            // Requested axial size (auto-clamped to safe max)
label_thickness = 2.0;         // Flat base thickness (mm)
label_concavity_depth = 1.2;   // Depth of top concavity that matches tube curvature (mm)
label_fit_clearance = 0.25;    // Extra radius so the concavity sits without rocking (mm)
label_insert_enabled = true;   // Adds side slot on the top female piece for insertion
label_insert_clearance = 0.35; // Clearance between slot and tag tongue
label_insert_end_clearance = 0.50; // Extra axial play at both tongue ends
label_slot_depth = 1.2;        // Radial depth of side insertion slot (mm)
label_slot_z_margin = 2.0;     // Axial margin from slot ends (mm)
label_print_spacing = 8;       // Separation between tags in print layout (mm)

surface_pattern = false;      // Optional exterior texture (can be heavy to render)
pattern_depth = 0.20;
pattern_lanes = 10;           // Number of helical lanes per family (higher => denser diamonds)
pattern_angle = 42;           // Diamond line angle vs tube axis (degrees)
pattern_twist_gain = 1.6;     // Boost helical tilt so diamonds are clearly visible
pattern_line_width = 1.15;    // Width of each diagonal groove (mm)
pattern_bottom_margin = 0.4;  // Small margin from lower edge
pattern_top_margin = 0.4;     // Small margin from upper edge

// Rendering detail (higher than default for smoother cylinders)
$fa = 1;
$fs = 0.45;

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
function compute_piece_count(target_len, joint_len, max_h, n=min_pieces) =
    ((target_len + (n - 1) * joint_len) / n <= max_h)
    ? n
    : compute_piece_count(target_len, joint_len, max_h, n + 1);

piece_count = compute_piece_count(total_length, joint_overlap_length, max_piece_height);
piece_height = (total_length + (piece_count - 1) * joint_overlap_length) / piece_count;
label_length_limit = min(150, piece_height);
label_length_eff = min(label_length, label_length_limit);

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
assert(piece_height <= max_piece_height + 1e-6, "Piece height exceeds max_piece_height");
assert(connector_major_min_d <= connector_major_max_d + 1e-6, "Not enough wall for internal thread. Increase wall_thickness or reduce thread_depth/thread_min_wall.");
assert(connector_major_d <= outer_diameter + 1e-6, "Thread connector exceeds outer diameter. Increase wall_thickness or reduce connector_outer_margin.");
assert(connector_major_d > inner_diameter + 2.0, "Connector too thin. Increase wall_thickness or reduce margins.");
assert(min_connector_wall >= thread_min_wall - 1e-6, "Connector wall too thin. Increase wall_thickness or reduce thread_depth.");
assert(end_cap_thickness < piece_height - male_thread_length, "end_cap_thickness too large for current piece geometry.");
assert(label_count >= 0, "label_count must be >= 0");
assert(label_width > 6 && label_length > 10, "label dimensions are too small.");
assert(label_thickness > 0.8, "label_thickness should be > 0.8 mm");
assert(label_concavity_depth > 0 && label_concavity_depth < label_thickness, "label_concavity_depth must be in (0, label_thickness)");
assert(label_fit_clearance >= 0, "label_fit_clearance must be >= 0");
assert(label_insert_clearance >= 0, "label_insert_clearance must be >= 0");
assert(label_insert_end_clearance >= 0, "label_insert_end_clearance must be >= 0");
assert(label_slot_depth > 0 && label_slot_depth < wall_thickness, "label_slot_depth must be in (0, wall_thickness)");
assert(label_slot_z_margin >= 0, "label_slot_z_margin must be >= 0");

echo("---- Tube summary ----");
echo(str("piece_count = ", piece_count));
echo(str("piece_height = ", piece_height));
echo(str("outer_diameter = ", outer_diameter));

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

            // Optional side slot for label insertion on the top female end piece only.
            if (label_insert_enabled && closed_top) {
                slot_w = label_width + 2 * label_insert_clearance;
                slot_len_max = max(8, h - thread_length - 2 * label_slot_z_margin);
                slot_len = min(label_length_eff, slot_len_max);
                slot_z0 = thread_length + (h - thread_length - slot_len) / 2;
                slot_x0 = outer_diameter / 2 - label_slot_depth - 0.02;

                translate([slot_x0, -slot_w / 2, slot_z0])
                    cube([label_slot_depth + 0.06, slot_w, slot_len]);
            }
        }

        // Decorative/functional grip pattern on the visible body area.
        if (surface_pattern) {
            pattern_z0 = pattern_bottom_margin;
            pattern_z1 = body_h - pattern_top_margin;
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

// =========================
// Label tag
// =========================
module content_label_tag() {
    concave_r = outer_diameter / 2 + label_fit_clearance;
    tongue_w = max(4, label_width - 2 * (1.2 + label_insert_clearance));
    tongue_d = max(0.6, label_slot_depth - label_insert_clearance);
    tongue_len = max(8, label_length_eff - 2 * label_insert_end_clearance);

    union() {
        difference() {
            cube([label_width, label_length_eff, label_thickness]);

            // Top concavity to match the tube outer curvature.
            translate([label_width / 2, label_length_eff + 0.06, label_thickness + concave_r - label_concavity_depth])
                rotate([90, 0, 0])
                    cylinder(h = label_length_eff + 0.12, r = concave_r, $fn = max(96, ceil(concave_r * 8)));
        }

        if (label_insert_enabled)
            translate([(label_width - tongue_w) / 2, label_insert_end_clearance, label_thickness])
                cube([tongue_w, tongue_len, tongue_d]);
    }
}

module part_by_index(idx) {
    if (idx == 0)
        bottom_end_piece(piece_height);
    else if (idx == piece_count - 1)
        top_end_piece(piece_height);
    else
        middle_piece(piece_height);
}

module part_for_print(idx) {
    // Keep blind side of both end pieces against the print bed.
    if (idx == piece_count - 1)
        translate([0, 0, piece_height])
            rotate([180, 0, 0])
                part_by_index(idx);
    else
        part_by_index(idx);
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
        tag_y = -bed_size_y / 2 + label_length_eff * 0.6 + 2;

        if (tag_step * label_count > bed_size_x)
            echo("WARNING: Labels may exceed bed width. Reduce label_count/label_width or increase bed_size_x.");

        for (j = [0 : label_count - 1]) {
            translate([tag_x0 + j * tag_step, tag_y, 0])
                content_label_tag();
        }
    }
}

module assembled_layout() {
    // Stack pieces and overlap each joint by effective male insertion length.
    for (i = [0 : piece_count - 1]) {
        z = i * (piece_height - joint_overlap_length);
        translate([0, 0, z])
            part_by_index(i);
    }
}

if (layout_mode == "assembled")
    assembled_layout();
else
    print_bed_layout();
