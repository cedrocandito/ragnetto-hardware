include <include_sg90.scad>


servo_holder_gap_bottom = 0;
servo_holder_pillar_h = sg90_ledge_z + servo_holder_gap_bottom;
servo_holder_gap_side= 0.4;
servo_holder_wall_size_bottom = 3;
servo_holder_wall_size_side = 1.5;
servo_holder_hole_extra = 2;
servo_holder_mount_hole_d = 2.1;
servo_holder_wall_h = servo_holder_pillar_h;
servo_holder_cable_extra_room = 2.5;
servo_holder_cable_extra_room_r = 10;
servo_holder_right_wall_l = 14;

servo_arm_bracket_size = 4;
servo_arm_extra_dist_min = 4;	// 0 is the minimal non-touching distance
servo_arm_extra_dist_max = 13;
servo_arm_thickness = 3.5;
servo_arm_servo_shaft_ring_thickness = 2;
servo_arm_servo_shaft_ring_gap = 0.0;	// to allow better movement
servo_arm_passage_angle = 90;
servo_arm_passage_extra_w = 0.5; // 0 is exactly the size of the servo shaft
servo_horn_rim = 0.2;	// gap between horn and joint arm
servo_arm_extra_horn_depth = 0.3;
servo_arm_horn_bridge_coverage = 1.5;
servo_arm_horn_bridge_h = 1;
servo_arm_buttress_r = min(4, servo_arm_extra_dist_min);
servo_arm_horn_hole_depth = min(1.3, sg90_horn_h);

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
shaft_base_gap = 0.2;	// 0.2 when fast, 0.1 when slow and precise
shaft_cylinder_gap = 0.1;

cable_holder_thickness = 2.5;
cable_holder_hole_thickness = 3.5;
cable_holder_hole_l = 11;
cable_holder_w = 4;

leg_segment2_l = 70;	// distance between axes
leg_segment3_l = 70; // distance between axis and tip
foot_with_ball_tip = true;
foot_w = 7;
foot_h = 7;
foot_tip_ball_d = min(foot_w, foot_h);
foot_tip_ball_offset = foot_tip_ball_d * 0.2;
foot_tip_hole_d = 5;
foot_l = foot_tip_ball_d/2;
lower_leg_beam_thickness = 5;
lower_leg_side_space = 3;

lower_body_h = servo_holder_pillar_h + servo_holder_wall_size_bottom;
body_r_axes = 80;
total_body_h = 43;
upper_body_dome_r = 60;
base_plate_h = 2;
body_shell_thickness = 2;
body_wedge_gap = 0.3;
body_cable_hole_d = sg90_connector_w + 2;
body_battery_strap_slit_l = 25;
body_battery_strap_slit_w = 7;
body_battery_strap_slit_x = 25;
body_servo_holder_ledge_extra_h = 0.5;
body_switch_hole_d = 6.5;
body_screw_hole_h = 20;
body_screw_hole_d = 3;
body_screw_head_d = 5;
body_screw_hole_platform_h = 2;
body_screw_column_d = 7;
body_screw_sides = [0, 60, 120, 240, 300];

pwm_controller_size_short = 27.3;
pwm_controller_size_long =  62.23;
pwm_controller_h = 20;
pwm_controller_pos = [-26, 0, 0];	// the second one is mirror
pwm_controller_hole_d = 2.5;	// technically it's 3, but the head of a 3 screw will be blocked by the PCB headers.
pwm_controller_hole_h = 8;
pwm_controller_hole_distance_short = 19.05;
pwm_controller_hole_distance_long = 55.88;
pwm_controller_pillar_h = 8;
pwm_controller_pillar_d_top = 5;
pwm_controller_pillar_d_base = 9;
pwm_controller_offset = 13;

arduino_size_long = 44;
arduino_size_short = 18;
arduino_h = 18;
arduino_pos = [0,35,0];
arduino_hole_d = 1.6;
arduino_hole_h = 8;
arduino_hole_distance_short = 15.10;
arduino_hole_distance_long = 40.64;
arduino_pillar_h = 12;
arduino_pillar_d_top = 3.5;
arduino_pillar_d_base = 8;

bevel_r = 2;
bevel_fs = 0.3;

$fa = 1;
$fs = 0.2;


// --------------------- derived ------------------------

servo_holder_pillar_l = sg90_ledge_l_from_body - servo_holder_gap_side;
servo_holder_w = sg90_main_w + servo_holder_gap_side * 2 + servo_holder_wall_size_side * 2;
servo_holder_l = sg90_main_l + servo_holder_gap_side * 2 + servo_holder_pillar_l * 2;
servo_holder_base_h = servo_holder_wall_size_bottom;
servo_holder_axis_x = -servo_holder_w / 2;
servo_holder_axis_y = -sg90_tower_d/2 - servo_holder_gap_side - servo_holder_pillar_l;
servo_holder_h = servo_holder_wall_size_bottom + servo_holder_gap_bottom + sg90_ledge_z;
servo_holder_base_z = -servo_holder_gap_bottom - servo_holder_wall_size_bottom;

function f_servo_arm_bracket_dist(servo_arm_extra_dist) = sqrt(servo_holder_axis_y * servo_holder_axis_y + servo_holder_axis_x * servo_holder_axis_x) + servo_arm_extra_dist;
function f_servo_arm_axis_to_bracket(servo_arm_extra_dist) = - f_servo_arm_bracket_dist(servo_arm_extra_dist) - servo_arm_bracket_size;
servo_arm_axis_to_base = -servo_holder_gap_bottom - servo_holder_wall_size_bottom - shaft_base2_extra_h - servo_arm_thickness;
servo_arm_h_in = shaft_base2_extra_h + servo_holder_wall_size_bottom + servo_holder_gap_bottom + sg90_main_h + sg90_tower_h + sg90_hub_with_horn_h - sg90_horn_h + servo_arm_horn_hole_depth - servo_arm_thickness;
servo_arm_h_out = servo_arm_h_in + servo_arm_thickness * 2;
cable_holder_l =servo_holder_w;
body_r = body_r_axes - servo_holder_w / 2;
body_servo_holder_buttress_h = (servo_holder_h - base_plate_h)/2;
upper_body_h = total_body_h - lower_body_h;
body_screw_hole_x = body_screw_column_d / 2;


// ---------------- assertions --------------------

assert(shaft_base1_l > shaft_base2_d);
assert(shaft_base1_l < sg90_main_w);
assert(lower_body_h - base_plate_h > body_cable_hole_d +1);