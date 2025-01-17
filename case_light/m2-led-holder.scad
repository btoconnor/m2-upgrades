// LED strip holder for M2
//
// Copyright (C) 2020  Kevin O'Connor <kevin@koconnor.net>
//
// This file may be distributed under the terms of the GNU GPLv3 license.

// Room at top for 2.5 inches width == 63.5mm
// Top frame screws measure 10 7/16 inches apart == 265mm
//  (10 11/16 - 4/16 == 10 7/16)

// Right Screw is ~9mm from steel frame; bed is ~19mm from steel frame.
// Screw ~9.5mm from edge.

// LED strip is 10mm wide by 1mm high.  Each section is 100mm long.

// Longest diagonal print on M2 is 320mm (sqrt(200**2 + 250**2))

plate_height = 3;
outside_wall = 2;
screw_holder = 8;
screw_dia = 4.5;
m2_rscrew_x = 265;
x_idler_offset_x = 26;
x_idler_offset_y1 = 30;
x_idler_offset_y2 = 4;
led_frame_x = 40;
led_frame_y = 15;
led_frame_length = 200;
led_frame_height = .6;
led_width = 10 + .5;
light_width = 4;
light_height = 0.4;
led_tracks = 5;
spacing = 100 / 6;
track_offsets = [2*spacing/5, 3*spacing/5, -spacing/5, spacing/5, 0];
led_bump_length = 2;
led_bump_height = 1;
led_wire_length = 5;
led_wall = 1.5;
slack = 1;
CUT = 0.01;
$fs = .5;

linear_rail_screw_spacing = 25;
linear_rail_margin = 19;
linear_rail_buffer = 5;
linear_rail_screw_x = 100;
linear_rail_screw_dia = 4.25;
linear_rail_num_screws = 1;
linear_rail_washer_clearance = 7.75;

support_start = led_frame_x + 3;

module led_plate() {
    module cyl(d, x, y, h=plate_height) {
        translate([x, y])
            cylinder(d=d, h);
    }
    led_frame_width = (led_width + led_wall) * led_tracks;
    frame_width = led_frame_width - led_wall + 2 * outside_wall;

    //echo(frame_width);
    hull_dia = 3;
    hull_left = led_frame_x;
    hull_right = led_frame_x + led_frame_length + led_bump_length + led_wire_length;
    hull_y1 = led_frame_y - hull_dia/2;
    hull_y2 = led_frame_y - frame_width + hull_dia/2;

    module plate() {
        hull() {
            cyl(screw_holder, 0, 0);
            cyl(hull_dia, x_idler_offset_x, hull_y1 - x_idler_offset_y1);
            cyl(hull_dia, hull_left, hull_y1 - x_idler_offset_y2);
        }
        hull() {
            cyl(hull_dia, x_idler_offset_x, hull_y1 - x_idler_offset_y1);
            cyl(hull_dia, x_idler_offset_x, hull_y1 - x_idler_offset_y1);
            cyl(hull_dia, x_idler_offset_x + 5, hull_y1);
            cyl(hull_dia, hull_left, hull_y1);
            cyl(hull_dia, hull_left, hull_y2);
            cyl(hull_dia, hull_right, hull_y1);
            cyl(hull_dia, hull_right, hull_y2);
            cyl(screw_holder, m2_rscrew_x, 0);
        }

        // Linear rail support bump out
        hull() {
            cyl(hull_dia, support_start + linear_rail_screw_x - linear_rail_buffer, hull_y2 + -10);
            cyl(hull_dia, support_start + linear_rail_screw_x - linear_rail_buffer, hull_y2 + -1);
            cyl(hull_dia, support_start + (linear_rail_screw_x + (linear_rail_screw_spacing * (linear_rail_num_screws-1))) + linear_rail_buffer, hull_y2 + -10);
            cyl(hull_dia, support_start + (linear_rail_screw_x + (linear_rail_screw_spacing * (linear_rail_num_screws-1))) + linear_rail_buffer, hull_y2 + -1);
        }
    }
    module led_track() {
        // Main channel to hold leds
        cube([led_frame_length, led_width, plate_height]);
        // Open space for light
        light_z = light_height-led_frame_height;
        translate([0, (led_width - light_width)/2, light_z])
            cube([led_frame_length, light_width, plate_height+99+CUT]);
        // Space for led wires
        bump_z = plate_height - (led_frame_height+led_bump_height);
        translate([led_frame_length - CUT, 0, bump_z])
            cube([led_bump_length+2*CUT, led_width, plate_height]);
        translate([led_frame_length + led_bump_length, 0, -99])
            cube([led_wire_length, led_width, 99 + plate_height + 2*CUT]);
    }

    track_y = led_frame_y - outside_wall - led_width;
    difference() {
        plate();
        translate([0, 0, -CUT])
            cylinder(d=screw_dia, h=plate_height + 2*CUT);
        translate([m2_rscrew_x, 0, -CUT])
            cylinder(d=screw_dia, h=plate_height + 2*CUT);
        for (i=[0:led_tracks-1]) {
            y = track_y - i * (led_width + led_wall);
            translate([led_frame_x - track_offsets[i], y, led_frame_height])
                led_track();
        }

        // Linear rail support to prevent sagging
        translate([support_start, hull_y2]) {
            // Screw hole
            for (i=[0:linear_rail_num_screws-1]) {
                translate([linear_rail_screw_x + (linear_rail_screw_spacing * i), -4.5-(2.5/2), -CUT]) {
                    cylinder(d=linear_rail_screw_dia, h=plate_height  + 2*CUT);
                }
            }

            // Spacing for nut + washer on the linear rail support
            for (i=[0:linear_rail_num_screws-1]) {
                translate([linear_rail_screw_x + (linear_rail_screw_spacing * i), -4.5-(2.5/2), -CUT]) {
                    cylinder(d=linear_rail_washer_clearance, h=2  + 2*CUT);
                }
            }
        }
    }
}

led_plate();
