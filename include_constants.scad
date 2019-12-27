include <include_sg90.scad>

servo_holder_gap_bottom = 0;
servo_holder_gap_side= 0.4;
servo_holder_wall_size_bottom = 3;
servo_holder_wall_size_side = 1;
servo_holder_hole_extra = 2;
servo_holder_mount_hole_d = 2;
servo_holder_wall_h = 10;
servo_holder_cable_extra_room = 2.5;
servo_holder_cable_extra_room_r = 10;

servo_arm_bracket_size = 4;
servo_arm_extra_dist = 3;	// 0 is the minimal non-touching distance
servo_arm_thickness = 3.5;
servo_arm_servo_shaft_ring_thickness = 2;
servo_arm_servo_shaft_ring_gap = 0.5;	// to allow better movement
servo_arm_passage_angle = 90;
servo_arm_passage_extra_w = 0.5; // 0 is exactly the size of the servo shaft
servo_horn_rim = 0.2;

joint_screw_hole_d = 2;
joint_screw_hole_distance = 20;
joint_screw_hole_cone_d = 5.6;	// if 0, no cone
joint_screw_hole_cone_depth = 2;


shaft_d = 5;
shaft_h = servo_arm_thickness;
shaft_base1_l = 10;
shaft_base1_h = servo_holder_wall_size_bottom / 2;
shaft_base2_d = 8;
shaft_base2_h = servo_holder_wall_size_bottom / 2;
shaft_base2_extra_h = 0.6;	// (to act like a washer)
shaft_hole_extra_h = 0.5;	// gap between screw tip and end of hole
shaft_fa = 1;
shaft_fs = 0.1;
shaft_gap = 0.2;	// 0.2 when fast, 0.1 when slow and precise

servo_horn_hub_d = 6.9;
servo_horn_total_l = 19.6;
servo_horn_arm_w_min = 3.9;
servo_horn_arm_w_max = 5.6;

bevel_r = 1.5;
bevel_subdivisions = 8;

// --------------------- derived ------------------------

servo_holder_pillar_l = sg90_ledge_l_from_body - servo_holder_gap_side;
servo_holder_w = sg90_main_w + servo_holder_gap_side * 2 + servo_holder_wall_size_side * 2;
servo_holder_l = sg90_main_l + servo_holder_gap_side * 2 + servo_holder_pillar_l * 2;
servo_holder_base_h = servo_holder_wall_size_bottom;
servo_holder_axis_x = -servo_holder_w / 2;
servo_holder_axis_y = -(sg90_main_l - sg90_main_l)/2 - sg90_tower_d/2 - servo_holder_gap_side - servo_holder_pillar_l;

// ----------------- modules --------------------

module simple_bevel(posizione, direzione, normale, lunghezza)
{
  c = [posizione, direzione, 0];
  n = [posizione, normale, 0];
  bevel(c, n, cres = bevel_subdivisions, cr = bevel_r, l = lunghezza); 
}