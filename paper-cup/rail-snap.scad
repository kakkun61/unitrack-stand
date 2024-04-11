$fn = $preview? 16: 64;

stage_width = 42;
bottom_inner_radius = 57.5 / 2;
top_inner_radius = 76.5 / 2;
thickness = 0.6;
depth = 5;

module rail_fence() {
  fence_width = 33;
  difference() {
    translate([stage_width / 2 + 2, 0, 0])
      rotate([90, 0, 180])
        linear_extrude(fence_width, center = true)
          translate([0, thickness + depth])
            polygon([[0, 0], [2, 0], [2, 0.5] ,[3, 1.5], [2, 2.5], [0, 2.5]]);
    translate([stage_width / 2 - 1, fence_width / 2 - 3, 0]) rotate([0, 0, 45]) cube([10, 10, 10]);
    translate([stage_width / 2 - 1, - (fence_width / 2 - 3), 0]) rotate([0, 0, 225]) cube([10, 10, 10]);
  }
  snap = 2;
  intersection() {
    translate([stage_width / 2 + 2, 0, 0])
      rotate([90, 0, 180])
        linear_extrude(60, center = true)
          union() {
            square([2, thickness + depth]);
            polygon([[2, thickness + depth - 2], [2 + 2, thickness + depth], [2, thickness + depth]]);
          }
    cylinder(r = bottom_inner_radius - thickness, h = thickness + depth);
  }
}

module cup_joiner() {
  slit = 1.5;
  rotate_extrude()
    polygon([
      [bottom_inner_radius - thickness, 0],
      [bottom_inner_radius, 0],
      [bottom_inner_radius, depth],
      [bottom_inner_radius + slit, depth],
      [bottom_inner_radius + slit, 0],
      [bottom_inner_radius + slit + thickness, 0],
      [bottom_inner_radius + slit + thickness, thickness + depth],
      [bottom_inner_radius - thickness, thickness + depth],
    ]);
}

cup_joiner();

rail_fence();

rotate([0, 0, 180]) rail_fence();
