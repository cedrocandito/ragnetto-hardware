include <include_sg90.scad>
include <include_constants.scad>
use <obiscad/bevel.scad>

servo_holder(with_bevel=false);
joint_arm(with_screw_holes=true);
translate([20,0,0]) cable_holder();

/*
"with_bevel" is a master switch, the others control single faces.
*/
module servo_holder(with_bevel = false, bevel_front = true, bevel_back = true, bevel_left = true, bevel_right = true, bevel_bottom = true)
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
				bevel_z = -servo_holder_gap_bottom;
				bevel_h = sg90_ledge_z + servo_holder_gap_bottom + servo_holder_base_h;
				
				// left front
				if (bevel_front && bevel_left)
					simple_bevel([0,0,bevel_z + bevel_h/2], [0,0,1], [-1,-1,0], bevel_h + 0.01);
				// right front
				if (bevel_front && bevel_right)
					simple_bevel([servo_holder_w,0,bevel_z + bevel_h/2], [0,0,1], [1,-1,0], bevel_h + 0.01);
				// left back
				if (bevel_back && bevel_left)
					simple_bevel([0,servo_holder_l,bevel_z + bevel_h/2], [0,0,1], [-1,1,0], bevel_h + 0.01);
				// right back
				if (bevel_back && bevel_right)
					simple_bevel([servo_holder_w,servo_holder_l,bevel_z + bevel_h/2], [0,0,1], [1,1,0], bevel_h + 0.01);
				
				// bottom front
				if (bevel_bottom && bevel_front)
					simple_bevel([servo_holder_w/2,0,bevel_z], [1,0,0], [0,-1,-1], servo_holder_w + 0.01);
				// bottom back
				if (bevel_bottom && bevel_back)
					simple_bevel([servo_holder_w/2,servo_holder_l,bevel_z], [1,0,0], [0,1,-1], servo_holder_w + 0.01);
				// bottom left
				if (bevel_bottom && bevel_left)
					simple_bevel([0,servo_holder_l/2,bevel_z], [0,1,0], [-1,0,-1], servo_holder_l + 0.01);
				// bottom right
				if (bevel_bottom && bevel_right)
					simple_bevel([servo_holder_w,servo_holder_l/2,bevel_z], [0,1,0], [1,0,-1], servo_holder_l + 0.01);
			}
		}
	}
	
	%SG90();
}


module joint_arm(with_top_bevel=true, with_bottom_bevel=true, with_buttress=true, with_screw_holes=true)
{
	$fa = 3;
	$fs = 0.1;
	
	w = servo_holder_w;
	bracket_dist = servo_arm_bracket_dist;
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
				// here origin is at base level, shaft axis
			
				// bottom arm
				translate([-w/2, -square_l, 0])
					cube([w, square_l, servo_arm_thickness]);
				cylinder(d = w, h = servo_arm_thickness);
				
				// bracket
				translate([-w/2, -square_l, 0])
					cube([w, servo_arm_bracket_size, servo_arm_h_out]);
					
				// top arm
				translate([0,0,servo_arm_h_in + servo_arm_thickness])
				{
					translate([-w/2, -square_l, 0])
						cube([w, square_l, servo_arm_thickness]);
					cylinder(d = w, h = servo_arm_thickness);
				}
				
				// top arm horn bridge (to keep the horn tip down)
				horn_l = servo_horn_total_l - servo_horn_hub_d / 2;
				servo_arm_horn_bridge_l = square_l - horn_l - servo_horn_rim + servo_arm_horn_bridge_coverage;
				assert(servo_arm_horn_bridge_l > 0);
				translate([-w/2, -square_l, servo_arm_h_out])
					cube([w, servo_arm_horn_bridge_l, servo_arm_horn_bridge_h]);
				
				// buttresses
				if (with_buttress)
				{
					translate([0, -square_l + servo_arm_bracket_size, servo_arm_thickness])
					{
						simple_bevel([0,0,0],[1,0,0],[0,-1,-1],w,r = servo_arm_extra_dist / 2);
						simple_bevel([0,0,servo_arm_h_in],[1,0,0],[0,-1,1],w, r = servo_arm_extra_dist / 2);
					}
				}
					
				// top arm shaft ring
				translate([0, 0, servo_arm_h_in + servo_arm_thickness - ring_h])
				{
					difference()
					{
						cylinder(d=servo_horn_hub_d + servo_horn_rim * 2 + servo_arm_servo_shaft_ring_thickness * 2, h=ring_h + 0.01);
						cylinder(d=servo_horn_hub_d + servo_horn_rim * 2 , h=ring_h + 0.01);						
					}
				}
			}
			
			// space for horn
			translate([0,0,servo_arm_h_out - sg90_horn_h - servo_arm_extra_horn_depth])
			{
				servo_horn(sg90_horn_h + servo_arm_extra_horn_depth + 0.01, servo_horn_rim);	
			}
			
			// horn hub
			translate([0,0,servo_arm_h_out - servo_arm_thickness - 0.01])
			{
				cylinder(d = servo_horn_hub_d + servo_horn_rim * 2, h = servo_arm_thickness + 0.01);
			}
			
			// passage for servo shaft in top arm
			rotate([0, 0, servo_arm_passage_angle])
				translate([-top_arm_passage_width/2, 0, servo_arm_h_out - servo_arm_thickness - ring_h - 0.01])
					cube([top_arm_passage_width, w/2 + 0.01, servo_arm_thickness + ring_h + 0.01 + 0.01]);
			
			// bottom shaft hole
			translate([0, 0, servo_arm_thickness - shaft_h - shaft_hole_extra_h])
				cylinder(d=shaft_d, h=shaft_h +shaft_hole_extra_h + 0.01, $fa = shaft_fa, $fs = shaft_fs);
			
			// screw holes
			if (with_screw_holes)
			{
				for (i=[-1:2:1])
				{
					translate([0, -square_l + servo_arm_bracket_size + 0.01, servo_arm_h_out/2 + joint_screw_hole_distance / 2 * i])
					{
						rotate([90, 0, 0])
						{
							cylinder(d=joint_screw_hole_d, h=servo_arm_bracket_size + 0.01 + 0.01);
							if (joint_screw_hole_cone_d > 0)
							{
								cylinder(d1=joint_screw_hole_cone_d, d2=joint_screw_hole_d, h=joint_screw_hole_cone_depth);
							}
						}
					}
				}
			}
			
			// bevel
			translate([0, -square_l, 0])
			{
				if (with_bottom_bevel)
					simple_bevel([0,0,0],[1,0,0],[0,-1,-1],w + 0.01,r = bevel_r * 2);
				if (with_top_bevel)
					simple_bevel([0,0,servo_arm_h_out + servo_arm_horn_bridge_h],[1,0,0],[0,-1,1],w + 0.01,r = bevel_r * 2);
			}
			
		}
	}
}


module shaft()
{
	$fa = shaft_fa;
	$fs = shaft_fs;
	
	// square base
	translate([-shaft_base1_l / 2 + shaft_gap, -shaft_base1_l / 2 + shaft_gap, 0])
		cube([shaft_base1_l - shaft_gap * 2, shaft_base1_l - shaft_gap * 2, shaft_base1_h]);

	// round base
	translate([0, 0, shaft_base1_h])
		cylinder(d=shaft_base2_d - shaft_gap * 2, h=shaft_base2_h + shaft_base2_extra_h);
	
	// shaft
	translate([0, 0, shaft_base1_h + shaft_base2_h + shaft_base2_extra_h])
		cylinder(d=shaft_d - shaft_gap * 2, h=shaft_h);
}


module cable_holder()
{
	base_h = cable_holder_l - cable_holder_tooth_l - cable_holder_hole_l;
	tot_thickness = cable_holder_thickness + cable_holder_hole_thickness;
	translate([0,0,-cable_holder_l / 2])
	{
		rotate([90,0,0])
		{
			linear_extrude(height=cable_holder_w, center= true)
			{
				polygon([
					[0,0],
					[tot_thickness,0],
					[tot_thickness, cable_holder_l],
					[cable_holder_hole_thickness - cable_holder_tooth_thickness, cable_holder_l],
					[cable_holder_hole_thickness - cable_holder_tooth_thickness, cable_holder_l - cable_holder_tooth_l],
					[cable_holder_hole_thickness, cable_holder_l - cable_holder_tooth_l],
					[cable_holder_hole_thickness, base_h],
					[0, base_h]
				]);
			}
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

module servo_horn(height=1.35, gap=0.2)
{
	linear_extrude(height=height)
		servo_horn_2d(gap);
}



module servo_horn_2d(gap)
{
	hub_r = servo_horn_hub_d / 2;
	arm_tip_r = servo_horn_arm_w_min / 2;
	arm_l = servo_horn_total_l - hub_r - arm_tip_r;
	
	rotate([0,0,-90])
	{
		offset(delta=gap)
		{
			union()
			{
				circle(d=servo_horn_hub_d);
				polygon([
					[0,-servo_horn_arm_w_max/2],
					[arm_l,-arm_tip_r],
					[arm_l,arm_tip_r],
					[0,servo_horn_arm_w_max/2]
				]);
				translate([arm_l,0]) circle(d=servo_horn_arm_w_min);
			}
		}
	}
}

