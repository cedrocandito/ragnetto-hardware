include <include_sg90.scad>
include <include_constants.scad>
include <include_servo_horn.scad>
use <obiscad/bevel.scad>

servo_holder_pillar_l = sg90_ledge_l_from_body - servo_holder_gap_side;
servo_holder_w = sg90_main_w + servo_holder_gap_side * 2 + servo_holder_wall_size_side * 2;
servo_holder_l = sg90_main_l + servo_holder_gap_side * 2 + servo_holder_pillar_l * 2;
servo_holder_base_h = servo_holder_wall_size_bottom;
servo_holder_axis_x = -servo_holder_w / 2;
servo_holder_axis_y = -(sg90_main_l - sg90_main_l)/2 - sg90_tower_d/2 - servo_holder_gap_side - servo_holder_pillar_l;


module servo_holder(with_bevel = false)
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
			cube([shaft_base1_l, shaft_base1_l, shaft_base1_h + 0.01]);
		translate([0, 0, -servo_holder_gap_bottom - shaft_base1_h - shaft_base2_h - 0.01])
			cylinder(d=shaft_base2_d, h=shaft_base2_h + 0.01 + 0.01, $fa = shaft_fa, $fs = shaft_fs);
		
		// bevel edges
		if (with_bevel)
		{
			translate([servo_holder_axis_x, servo_holder_axis_y, -servo_holder_base_h])
			{
				bevel_h = sg90_ledge_z + servo_holder_gap_bottom + servo_holder_base_h;
				
				// left front
				simple_bevel([0,0,bevel_h/2], [0,0,1], [-1,-1,0], bevel_h);
				// right front
				simple_bevel([servo_holder_w,0,bevel_h/2], [0,0,1], [1,-1,0], bevel_h);
				// left back
				simple_bevel([0,servo_holder_l,bevel_h/2], [0,0,1], [-1,1,0], bevel_h);
				// right back
				simple_bevel([servo_holder_w,servo_holder_l,bevel_h/2], [0,0,1], [1,1,0], bevel_h);
				
				// bottom front
				simple_bevel([servo_holder_w/2,0,0], [1,0,0], [0,-1,-1], servo_holder_w);
				// bottom back
				simple_bevel([servo_holder_w/2,servo_holder_l,0], [1,0,0], [0,1,-1], servo_holder_w);
				// bottom left
				simple_bevel([0,servo_holder_l/2,0], [0,1,0], [-1,0,-1], servo_holder_l);
				// bottom right
				simple_bevel([servo_holder_w,servo_holder_l/2,0], [0,1,0], [1,0,-1], servo_holder_l);
			}
		}
	}
	
	%SG90();
}


module joint_arm()
{
	$fa = 1;
	$fs = 0.2;
	
	w = servo_holder_w;
	in_h = shaft_base2_extra_h + servo_holder_wall_size_bottom + servo_holder_gap_bottom + sg90_main_h + sg90_tower_h + sg90_hub_with_horn_h - servo_arm_thickness;
	out_h = in_h + servo_arm_thickness * 2;
	bracket_dist = sqrt(servo_holder_axis_y * servo_holder_axis_y + servo_holder_axis_x * servo_holder_axis_x) + servo_arm_extra_dist;
	l = bracket_dist + servo_arm_bracket_size + w/2;
	square_l = l - w / 2;
	shaft_hole_gap = 0.5;
	top_arm_passage_width = sg90_hub_d + servo_arm_passage_extra_w;
	ring_h = sg90_hub_with_horn_h - servo_arm_thickness - servo_arm_servo_shaft_ring_gap;
	
	translate([0,0,-servo_holder_gap_bottom - servo_holder_wall_size_bottom - shaft_base2_extra_h - servo_arm_thickness])
	{
		difference()
		{
			union()
			{
				// here origin is at base level, at shaft axis
			
				// bottom arm
				translate([-w/2, -square_l, 0])
					cube([w, square_l, servo_arm_thickness]);
				cylinder(d = w, h = servo_arm_thickness);
				
				// bracket
				translate([-w/2, -square_l, 0])
					cube([w, servo_arm_bracket_size, out_h]);
					
				// top arm
				translate([0,0,in_h + servo_arm_thickness])
				{
					translate([-w/2, -square_l, 0])
						cube([w, square_l, servo_arm_thickness]);
					cylinder(d = w, h = servo_arm_thickness);
				}
				
				// top arm shaft ring
				translate([0, 0, in_h + servo_arm_thickness - ring_h])
				{
					difference()
					{
						cylinder(d=servo_horn_hub_d + servo_horn_rim * 2 + servo_arm_servo_shaft_ring_thickness * 2, h=ring_h);
						cylinder(d=servo_horn_hub_d + servo_horn_rim * 2 , h=ring_h);						
					}
				}
			}
			
			// horn
			translate([0,0,out_h - sg90_horn_h])
			{
				servo_arm(sg90_horn_h + 0.01, servo_horn_rim);	
			}
			
			// horn hub
			translate([0,0,out_h - servo_arm_thickness - 0.01])
			{
				cylinder(d = servo_horn_hub_d + servo_horn_rim * 2, h = servo_arm_thickness + 0.01);
			}
			
			// passage for servo shaft in top arm
			translate([-w/2 - 0.01, -top_arm_passage_width/2, out_h - servo_arm_thickness - ring_h - 0.01])
				cube([w/2, top_arm_passage_width, servo_arm_thickness + ring_h + 0.01 + 0.01]);
			
			// bottom shaft hole
			translate([0, 0, servo_arm_thickness - shaft_h - shaft_hole_extra_h])
				cylinder(d=shaft_d, h=shaft_h +shaft_hole_extra_h + 0.01, $fa = shaft_fa, $fs = shaft_fs);
		}
	}
}


// ----------------------------------------------------------------------------------------

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
		
		// screw hole
		translate([0, sg90_mount_hole_offset_y_from_axis - servo_holder_axis_y, h - hole_h])
			cylinder(d = servo_holder_mount_hole_d, h = hole_h + 0.01, $fa=5, $fs=0.1);
		
		if (with_cable_slit)
		{
			translate([0, servo_holder_pillar_l + servo_holder_cable_extra_room_r, 0])
			{
				translate([-sg90_cable_w, 0, 0])
				{
					rotate([0, 90, 0])
					{
						cylinder(r=servo_holder_cable_extra_room_r + servo_holder_cable_extra_room, h=w/2 + sg90_cable_w + 0.01);
					}
				}
			}
		}
	}
}
