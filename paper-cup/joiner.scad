$fn = $preview? 16: 64;

module cup_joiner() {
  bottom_inner_radius = 57.5 / 2;
  top_inner_radius = 76.5 / 2;
  thickness = 0.6;
  depth = 5;
  inner_slit = 1.5;
  outer_slit = 3.7;

  rotate_extrude()
    polygon([
      [bottom_inner_radius - thickness, 0],
      [bottom_inner_radius, 0],
      [bottom_inner_radius, depth],
      [bottom_inner_radius + inner_slit, depth],
      [bottom_inner_radius + inner_slit, 0],
      [top_inner_radius + outer_slit + thickness, 0],
      [top_inner_radius + outer_slit + thickness, thickness + depth],
      [top_inner_radius + outer_slit, thickness + depth],
      [top_inner_radius + outer_slit, thickness],
      [top_inner_radius, thickness],
      [top_inner_radius, thickness + depth],
      [top_inner_radius - thickness, thickness + depth],
      [top_inner_radius - thickness, thickness],
      [bottom_inner_radius + inner_slit + thickness, thickness],
      [bottom_inner_radius + inner_slit + thickness, thickness + depth],
      [bottom_inner_radius - thickness, thickness + depth],
    ]);
}

cup_joiner();
