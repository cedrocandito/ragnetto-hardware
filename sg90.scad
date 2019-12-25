/* SG90 servo; origin is on the rotation axis. */

sg90_main_w = 12.25;
sg90_main_l = 22.6;
sg90_main_h = 23.8;
sg90_ledge_z = 17.5;
sg90_ledge_l = 32.2;
sg90_ledge_h = 2.4;
sg90_tower_d = 11.5;
sg90_tower_h = 4.4;
sg90_tower2_d = 5.5;
sg90_tower2_y = 6; // center to center
sg90_hub_d = 4.8;
sg90_hub_h = 2.9;
sg90_mount_hole_d = 3;
sg90_mount_hole_dist = 27.8; // center to center
sg90_shaft_hole_d = 1.6;
sg90_cable_z = 1;
sg90_cable_w = 3;
sg90_cable_h = 1;
sg90_cable_l = 2;
sg90_mount_screw_h = 9;

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