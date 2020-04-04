/* SG90 servo; origin is on the rotation axis. */

mg90 = true;

sg90_main_w = 12.25;
sg90_main_l = 22.6;
sg90_main_h = 23.8;
sg90_ledge_z = 17.3;
sg90_ledge_l = 32.2;
sg90_ledge_h = 2.35;
sg90_tower_d = 11.5;
sg90_tower_h = 4.4;
sg90_tower2_d = 5.5;
sg90_tower2_y = 6; // center to center
sg90_hub_d = 4.8;
sg90_hub_h = 2.9;
sg90_hub_with_horn_h = (mg90 ? 5.1 : 4.8);
sg90_horn_h = (mg90 ? 2.55 : 1.35);
sg90_mount_hole_d = 3;
sg90_mount_hole_dist = 27.8; // center to center
sg90_shaft_hole_d = 1.6;
sg90_cable_z = 1;
sg90_cable_w = 3.5;
sg90_cable_h = 1;
sg90_cable_l = 2;
sg90_mount_screw_h = 9;
sg90_connector_w = 7.6;
sg90_connector_l = 14;
sg90_connector_h = 2.6;

servo_horn_hub_d = (mg90 ? 6.8 : 6.9);
servo_horn_total_l = (mg90 ? 21.5 : 19.6);

servo_horn_first_mini_hole_distance = 4.3;
servo_horn_mini_hole_distance = 2;
servo_horn_mini_holes = (mg90 ? 7 : 6);
// list of medium hole indexes (zero based)
servo_horn_medium_holes_indexes = (mg90 ? [5] : []);
servo_horn_mini_hole_d = 1;
servo_horn_mini_hole_h = 5;
servo_horn_medium_hole_d = 1.5;
servo_horn_medium_hole_h = 5;

/* calculate projected width of horn at hub center (servo_horn_arm_w_max) */
servo_horn_width_at_hole_1 = (mg90 ? 5.85 : 5.1);
servo_horn_width_at_hole_5 = (mg90 ? 4.5 : 4.2);
servo_horn_length_at_hole_1 = servo_horn_first_mini_hole_distance;
servo_horn_length_at_hole_5 = servo_horn_first_mini_hole_distance + (5-1) * servo_horn_mini_hole_distance;
servo_horn_arm_w_max = (servo_horn_width_at_hole_1 * servo_horn_length_at_hole_5 - servo_horn_width_at_hole_5 * servo_horn_length_at_hole_1) / (servo_horn_length_at_hole_5 - servo_horn_length_at_hole_1);

servo_horn_arm_w_min = 4;



sg90_body_offset_x_from_axis = -sg90_main_w/2;
sg90_body_offset_y_from_axis = -sg90_tower_d/2;
sg90_mount_hole_offset_y_from_body = -(sg90_mount_hole_dist - sg90_main_l) / 2;
sg90_mount_hole_offset_y_from_axis = sg90_mount_hole_offset_y_from_body + sg90_body_offset_y_from_axis;
sg90_ledge_l_from_body = (sg90_ledge_l  - sg90_main_l) / 2;

module SG90()
{
	$fa=3; $fs=0.5;
	
	translate([sg90_body_offset_x_from_axis, sg90_body_offset_y_from_axis, 0])
	{
		difference()
		{
			union()
			{
				// main body
				cube([sg90_main_w, sg90_main_l, sg90_main_h]);
				// mount "ledge"
				translate([0,-sg90_ledge_l_from_body,sg90_ledge_z])
					cube([sg90_main_w, sg90_ledge_l, sg90_ledge_h]);
				// round tower
				translate([sg90_main_w/2, sg90_tower_d/2, sg90_main_h]) 
					cylinder(d=sg90_tower_d, h=sg90_tower_h);
				// tower little extension
				translate([sg90_main_w/2, sg90_tower_d/2 + sg90_tower2_y, sg90_main_h]) 
					cylinder(d=sg90_tower2_d, h=sg90_tower_h);
				// hub
				translate([sg90_main_w/2, sg90_tower_d/2, sg90_main_h + sg90_tower_h]) 
					cylinder(d=sg90_hub_d, h=sg90_hub_h);
				// cable
				translate([sg90_main_w/2 - sg90_cable_w/2, -sg90_cable_l, sg90_cable_z])
					cube([sg90_cable_w, sg90_cable_l, sg90_cable_h]);
			}
			
			// mount holes
			translate([sg90_main_w/2, sg90_mount_hole_offset_y_from_body, sg90_ledge_z - 1])
				cylinder(d = sg90_mount_hole_d, h = sg90_ledge_h + 2);
			translate([sg90_main_w/2, sg90_main_l - sg90_mount_hole_offset_y_from_body, sg90_ledge_z - 1])
				cylinder(d = sg90_mount_hole_d, h = sg90_ledge_h + 2);
			// shaft hole
			translate([sg90_main_w/2, sg90_tower_d/2, sg90_main_h + sg90_tower_h]) 
					cylinder(d=sg90_shaft_hole_d, h=sg90_hub_h+1);
		}
	}
}