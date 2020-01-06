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
servo_arm_extra_dist_min = 3;	// 0 is the minimal non-touching distance
servo_arm_extra_dist_max = 13;
servo_arm_thickness = 3.5;
servo_arm_servo_shaft_ring_thickness = 2;
servo_arm_servo_shaft_ring_gap = 0.4;	// to allow better movement
servo_arm_passage_angle = 90;
servo_arm_passage_extra_w = 0.5; // 0 is exactly the size of the servo shaft
servo_horn_rim = 0.2;
servo_arm_extra_horn_depth = 0.3;
servo_arm_horn_bridge_coverage = 1.5;
servo_arm_horn_bridge_h = 1;
servo_arm_buttress_r = min(4, servo_arm_extra_dist_min);

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

cable_holder_thickness = 2.5;
cable_holder_hole_thickness = 3.5;
cable_holder_hole_l = 11;
cable_holder_w = 4;

leg_segment2_l = 60;	// distance between axes
leg_segment3_l = 60; // distance between axis and tip
foot_with_ball_tip = false;
foot_w = 7;
foot_h = 7;
foot_tip_ball_d = min(foot_w, foot_h);
foot_tip_hole_d = 5;
foot_l = foot_tip_ball_d/2;
lower_leg_beam_thickness = 5;
lower_leg_side_space = 3;

pwm_controller_size_short = 27.3;
pwm_controller_size_long =  62.23;
pwm_controller_h = 20;
pwm_controller_pos = [-20, 0, 0];	// the second one is mirror
pwm_controller_rotation = [0,0,0];
pwm_controller_hole_d = 3;
pwm_controller_hole_h = 13;
pwm_controller_hole_distance_short = 19.05;
pwm_controller_hole_distance_long = 55.88;
pwm_controller_pillar_h = 15;
pwm_controller_pillar_d_top = 5;
pwm_controller_pillar_d_base = 10;

arduino_size_long = 44;
arduino_size_short = 18;
arduino_pos = [9,0,-22];
arduino_rotation = [0,0,0];
arduino_hole_d = 1.6;
arduino_hole_h = 10;
arduino_hole_distance_short = 15.10;
arduino_hole_distance_long = 40.64;
arduino_pillar_h = 15;
arduino_pillar_d_top = 4.5;
arduino_pillar_d_base = 4.5;

bevel_r = 2;
bevel_fs = 0.3;


// --------------------- derived ------------------------

servo_holder_pillar_l = sg90_ledge_l_from_body - servo_holder_gap_side;
servo_holder_w = sg90_main_w + servo_holder_gap_side * 2 + servo_holder_wall_size_side * 2;
servo_holder_l = sg90_main_l + servo_holder_gap_side * 2 + servo_holder_pillar_l * 2;
servo_holder_base_h = servo_holder_wall_size_bottom;
servo_holder_axis_x = -servo_holder_w / 2;
servo_holder_axis_y = -(sg90_main_l - sg90_main_l)/2 - sg90_tower_d/2 - servo_holder_gap_side - servo_holder_pillar_l;
servo_holder_h = servo_holder_wall_size_bottom + servo_holder_gap_bottom + sg90_ledge_z;
servo_holder_base_z = -servo_holder_gap_bottom - servo_holder_wall_size_bottom;

function f_servo_arm_bracket_dist(servo_arm_extra_dist) = sqrt(servo_holder_axis_y * servo_holder_axis_y + servo_holder_axis_x * servo_holder_axis_x) + servo_arm_extra_dist;
function f_servo_arm_axis_to_bracket(servo_arm_extra_dist) = - f_servo_arm_bracket_dist(servo_arm_extra_dist) - servo_arm_bracket_size;
servo_arm_axis_to_base = -servo_holder_gap_bottom - servo_holder_wall_size_bottom - shaft_base2_extra_h - servo_arm_thickness;
servo_arm_h_in = shaft_base2_extra_h + servo_holder_wall_size_bottom + servo_holder_gap_bottom + sg90_main_h + sg90_tower_h + sg90_hub_with_horn_h - servo_arm_thickness;
servo_arm_h_out = servo_arm_h_in + servo_arm_thickness * 2;
cable_holder_l =servo_holder_w;


// ---------------- assertions --------------------

assert(shaft_base1_l > shaft_base2_d);
assert(shaft_base1_l < sg90_main_w);
