$fn = $preview? 16: 64;

stage_height = 35;
stage_width = 42;
stage_length = stage_width;
stage_thickness = 2;
stage_leg_socket_height = 5;
stage_leg_socket_thickness = 1;
stage_flange_height = 2;
leg_height = stage_height - stage_thickness;
leg_width = sqrt(stage_width ^ 2 + stage_length ^ 2);
leg_thickness = 2;
leg_frame_width = 3;
leg_brace_width = 3;
center_hole_length = 2;
rail_fence_height = 2;
rail_fence_radius = 1;

module leg() {
  module half() {
    hole_width = (leg_width - leg_thickness) / 2 - 2 * leg_frame_width;
    hole_height = leg_height - 2 * leg_frame_width;
    hole_center = [- leg_thickness / 2 - leg_frame_width - hole_width / 2, 0];
    module brace() {
      brace_length = sqrt(hole_width ^ 2 + hole_height ^ 2);
      square([leg_brace_width, brace_length], center = true);
    }
    linear_extrude(leg_thickness) {
      difference() {
        square([leg_width, leg_height], center = true);
        translate([0, leg_height / 4]) square([leg_thickness + 0.1, leg_height / 2], center = true);
        circle(d = leg_thickness + 0.1);
        translate(hole_center) square([hole_width, leg_height - 2 * leg_frame_width], center = true);
      }
      translate(hole_center) rotate(atan2(hole_width, hole_height)) brace();
      translate(hole_center) rotate(atan2(- hole_width, hole_height)) brace();
    }
  }
  intersection() { half(); mirror([1, 0, 0]) half(); }
}

module lower_stage() {
  linear_extrude(stage_thickness)
    intersection() { square([stage_width, stage_length], center = true);
      union() {
        rotate([0, 0, 45]) square([leg_width, 10], center = true);
        rotate([0, 0, 135]) square([leg_width, 10], center = true);
      }
    }
  module leg_socket() {
    linear_extrude(stage_leg_socket_height)
      intersection() {
        difference() {
          union() {
            rotate([0, 0, 45]) square([leg_width, leg_thickness + 2 * stage_leg_socket_thickness], center = true);
            rotate([0, 0, 135]) square([leg_width, leg_thickness + 2 * stage_leg_socket_thickness], center = true);
          }
          rotate([0, 0, 45]) square([leg_width, leg_thickness + 0.5], center = true);
          rotate([0, 0, 135]) square([leg_width, leg_thickness + 0.5], center = true);
        }
        square([stage_width, stage_length], center = true);
      }
  }
  translate([0, 0, stage_thickness]) leg_socket();
}

module upper_stage() {
  allowance = 0.3;
  linear_extrude(stage_flange_height)
    difference() {
      square([stage_width, stage_length], center = true);
      rotate([0, 0, 45]) square([leg_width, leg_thickness + 2 * stage_leg_socket_thickness + allowance], center = true);
      rotate([0, 0, 135]) square([leg_width, leg_thickness + 2 * stage_leg_socket_thickness + allowance], center = true);
      rotate([0, 0, 45]) square([stage_width, stage_length]);
      rotate([0, 0, 225]) square([stage_width, stage_length]);
    }
  translate([0, 0, stage_flange_height])
    linear_extrude(stage_thickness)
      difference() {
        square([stage_width, stage_length], center = true);
        rotate([0, 0, 45]) square([leg_width, 10 + allowance], center = true);
        rotate([0, 0, 135]) square([leg_width, 10 + allowance], center = true);
        rotate([0, 0, 45]) square([stage_width, stage_length]);
        rotate([0, 0, 225]) square([stage_width, stage_length]);
      }
  module rail_pin() {
    linear_extrude(rail_pin_height)
      difference() {
        circle(r = rail_pin_hole_radius + rail_pin_thickness);
        circle(r = rail_pin_hole_radius);
        square([0.5, 2 * (rail_pin_hole_radius + rail_pin_thickness)], center = true);
      }
  }
  module rail_fence() {
    // translate([0, - rail_fence_radius, 0]) cube([rail_fence_radius, 2 * rail_fence_radius, stage_thickness + stage_flange_height]);
    // cylinder(r = rail_fence_radius, h = stage_thickness + stage_flange_height + rail_fence_height);
    rotate([90, 0, 0]) linear_extrude(24, center = true) {
      translate([0, stage_thickness + stage_flange_height]) polygon([[0, 0], [2, 0], [2, 0.5] ,[3, 1.5], [2, 2.5], [0, 2.5]]);
      square([2, stage_thickness + stage_flange_height]);
    }
  }
  translate([stage_width / 2 + 2, 0]) rotate([0, 0, 180]) rail_fence();
  translate([- stage_width / 2 - 2, 0]) rail_fence();
}

module all() {
  color("khaki") rotate([90, 0, 0]) translate([0, 0, - leg_thickness / 2]) leg();
  color("gold") rotate([0, 270, 0]) rotate([0, 0, 90]) translate([0, 0, - leg_thickness / 2]) leg();
  color("olive") % translate([0, 0, leg_height / 2 + stage_thickness]) rotate([180, 0, 45]) lower_stage();
  color("yellow") translate([0, 0, leg_height / 2 - stage_thickness]) rotate([0, 0, 45]) upper_stage();
}

all();
