include <include_sg90.scad>
include <include_constants.scad>
use <obiscad/bevel.scad>

servo_holder_pillar_l = sg90_ledge_l_from_body - servo_holder_gap_side;
servo_holder_w = sg90_main_w + servo_holder_gap_side * 2 + servo_holder_wall_size_side * 2;
servo_holder_l = sg90_main_l + servo_holder_gap_side * 2 + servo_holder_pillar_l * 2;
servo_holder_base_h = servo_holder_wall_size_bottom;
servo_holder_axis_x = -servo_holder_w / 2;
servo_holder_axis_y = -(sg90_main_l - sg90_main_l)/2 - sg90_tower_d/2 - servo_holder_gap_side - servo_holder_pillar_l;


module servo_holder()
{
	$fa = 1;
	$fs = 0.15;
	
	difference()
	{
		union()
		{
			// base
			translate([servo_holder_axis_x, servo_holder_axis_y, -servo_holder_wall_size_bottom - servo_holder_gap_bottom])
				cube([servo_holder_w, servo_holder_l, servo_holder_base_h]);

			// pillars
			translate([0,servo_holder_axis_y,-servo_holder_gap_bottom])
				servo_pillar(true);
			translate([0,servo_holder_axis_y + servo_holder_l,-servo_holder_gap_bottom])
				rotate([0, 0, 180])
					servo_pillar(false);
			
			// side wall
			translate([servo_holder_axis_x, servo_holder_axis_y, -servo_holder_gap_bottom])
				cube([servo_holder_wall_size_side, servo_holder_l, servo_holder_wall_h]);
		}

		// bottom shaft hole
		translate([-shaft_base1_l / 2, -shaft_base1_l / 2, -servo_holder_gap_bottom - shaft_base1_h])
			cube([shaft_base1_l, shaft_base1_l, shaft_base1_h+0.1]);
		translate([0, 0, -servo_holder_gap_bottom - shaft_base1_h - shaft_base2_h - 0.1])
			cylinder(d=shaft_base2_d, h=shaft_base2_h+0.1+0.1, $fa = shaft_fa, $fs = shaft_fs);
	}
	
	%SG90();
}

module servo_pillar(with_cable_slit=false)
{
	w = servo_holder_w;
	h = sg90_ledge_z + servo_holder_gap_bottom;
	hole_h = sg90_mount_screw_h  - sg90_ledge_h + servo_holder_hole_extra;
	
	difference()
	{
		translate([-w/2,0,0])
		{
			cube([w, servo_holder_pillar_l, h]);	
		}
		
		#translate([0, sg90_mount_hole_offset_y_from_axis - servo_holder_axis_y, h - hole_h])
			cylinder(d = servo_holder_mount_hole_d, h = hole_h+0.1, $fa=5, $fs=0.1);
		
		if (with_cable_slit)
		{
			translate([0, -0.1, 0])
			{
				cable_slit(servo_holder_cable_slit_w, servo_holder_cable_slit_hmin, servo_holder_pillar_l + 0.1 + 0.1);
			}
			
			translate([0, servo_holder_pillar_l + servo_holder_cable_extra_room_r, 0])
			{
				rotate([0, 90, 0])
				{
					cylinder(r=servo_holder_cable_extra_room_r + servo_holder_cable_extra_room, h=w/2 + 0.1);
				}
			}
		}
	}
}

module cable_slit(w, hmin, depth)
{
	rotate([90, 0, 180])
	{
		linear_extrude(height=depth)
		{
			union()
			{
				translate([-w/2, 0])
					square([w,hmin]);
				
				difference()
				{
					translate([0, hmin])
						circle(d=w);
					
					translate([-w/2, -w/2])
						square([w, w/2]);
				}
			}
		}
	}
}