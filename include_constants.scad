servo_holder_gap_bottom = 0;
servo_holder_gap_side= 0.4;
servo_holder_wall_size_bottom = 3;
servo_holder_wall_size_side = 1;
servo_holder_hole_extra = 2;
servo_holder_mount_hole_d = 2;
servo_holder_wall_h = 10;
servo_holder_cable_extra_room = 2.5;
servo_holder_cable_extra_room_r = 10;

servo_arm_bracket_size = 3.5;
servo_arm_extra_dist = 2;	// 0 is the minimal non-touching distance
servo_arm_thickness = 3.5;
servo_arm_servo_shaft_ring_thickness = 2;
servo_arm_passage_extra_w = 0.5; // 0 is exactly the size of the servo shaft
servo_horn_rim = 0.2;

shaft_d = 5;
shaft_h = servo_arm_thickness;
shaft_base1_l = 10;
shaft_base1_h = servo_holder_wall_size_bottom / 2;
shaft_base2_d = 8;
shaft_base2_h = servo_holder_wall_size_bottom / 2;
shaft_base2_extra_h = 0.6;	// (to act like a washer)
shaft_hole_extra_h = 0.5;
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