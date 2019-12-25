servo_holder_gap_bottom = 0;
servo_holder_gap_side= 0.4;
servo_holder_wall_size_bottom = 3;
servo_holder_wall_size_side = 1;
servo_holder_hole_extra = 2;
servo_holder_mount_hole_d = 2;
servo_holder_cable_slit_w = 8.5;
servo_holder_cable_slit_hmin = 2;
servo_holder_wall_h = 10;
servo_holder_cable_extra_room = 2;
servo_holder_cable_extra_room_r = 15;

servo_arm_bracket_size = 3;
servo_arm_extra_dist = 1;
servo_arm_thickness = 3;

shaft_d = 5;
shaft_h = 4;
shaft_base1_l = 10;
shaft_base1_h = servo_holder_wall_size_bottom / 2;
shaft_base2_d = 8;
shaft_base2_h = servo_holder_wall_size_bottom / 2;
shaft_base2_extra_gap = 0.6;	// (to act like a washer)
shaft_fa = 1;
shaft_fs = 0.1;

bevel_r = 1.5;
bevel_subdivisions = 8;

module simple_bevel(posizione, direzione, normale, lunghezza)
{
  c = [posizione, direzione, 0];
  n = [posizione, normale, 0];
  bevel(c, n, cres = bevel_subdivisions, cr = bevel_r, l = lunghezza); 
}