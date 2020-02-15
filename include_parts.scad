include <include_sg90.scad>
include <include_constants.scad>
use <davel/davel.scad>

servo_holder(with_bevel=true);
joint_arm(servo_arm_extra_dist=servo_arm_extra_dist_min, with_screw_holes=true);
translate([20,0,0]) cable_holder();
translate([-120,0,0]) {lower_body_shell(); *upper_body_shell(); }

/*
"with_bevel" is a master switch, the others control single faces.
*/
module servo_holder(with_bevel = false, bevel_front = true, bevel_back = true, bevel_left = true, bevel_right = true, bevel_bottom = true, draw_servo=true)
{
	$fa = 1;
	$fs = 0.2;
	
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
			translate([-servo_holder_axis_x - servo_holder_wall_size_side, servo_holder_axis_y + servo_holder_l/2, -servo_holder_gap_bottom])
				cube([servo_holder_wall_size_side, servo_holder_l/2, servo_holder_wall_h]);
		}

		// bottom shaft hole
		translate([-shaft_base1_l / 2, -shaft_base1_l / 2, -servo_holder_gap_bottom - shaft_base1_h])
			cube([shaft_base1_l, shaft_base1_l, shaft_base1_h + 0.01]);
		translate([0, 0, -servo_holder_gap_bottom - shaft_base1_h - shaft_base2_h - 0.01])
			cylinder(d=shaft_base2_d, h=shaft_base2_h + 0.01 + 0.01, $fa = shaft_fa, $fs = shaft_fs);
		
		// bevel edges
		if (with_bevel)
		{
			$fs = bevel_fs;
			bevel_z = -servo_holder_gap_bottom;
			bevel_h = sg90_ledge_z + servo_holder_gap_bottom + servo_holder_base_h;
			
			translate([servo_holder_axis_x, servo_holder_axis_y, -servo_holder_base_h + bevel_z])
			{
				davel_box_bevel(
					[servo_holder_w, servo_holder_l, bevel_h], r=bevel_r, top = false, front=bevel_front, back=bevel_back, left = bevel_left, right=bevel_right, bottom=bevel_bottom, $fs = 0.3);
			}
		}
	}
	
	if (draw_servo)
		%SG90();
}


module joint_arm(servo_arm_extra_dist, with_top_bevel=true, with_bottom_bevel=true, with_buttress=true, with_screw_holes=true)
{
	$fa = 1;
	$fs = 0.2;
	
	w = servo_holder_w;
	bracket_dist = f_servo_arm_bracket_dist(servo_arm_extra_dist);
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
					$fs = bevel_fs;
					translate([0, -square_l + servo_arm_bracket_size, servo_arm_thickness])
					{
						davel_buttress_pos([0,0,0], w, [0,0,1],[0,1,0], r = servo_arm_buttress_r);
						davel_buttress_pos([0,0,servo_arm_h_in], w, [0,0,-1],[0,1,0], r = servo_arm_buttress_r);
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
				$fs = bevel_fs;
				if (with_bottom_bevel)
					davel_bevel_pos([0,0,0], w, [0,0,-1], [0,-1,0], bevel_r * 2.5);
				if (with_top_bevel)
					davel_bevel_pos([0,0,servo_arm_h_out + servo_arm_horn_bridge_h], w, [0,0,1], [0,-1,0], bevel_r * 2.5);
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
	tot_thickness = cable_holder_thickness + cable_holder_hole_thickness;
	translate([0,0,-cable_holder_l / 2])
	{
		union()
		{
			difference()
			{		
				// outer block
				cube([tot_thickness, cable_holder_w, cable_holder_l]);		
				
				// hole
				translate([-0.01, -0.01, (cable_holder_l - cable_holder_hole_l) / 2])
					cube([cable_holder_hole_thickness+0.02, cable_holder_w+0.02, cable_holder_hole_l]);
				
				// outer bevel
				davel_box_bevel([tot_thickness, cable_holder_w, cable_holder_l], r=cable_holder_thickness, left=false, front=false, back= false, $fs = 0.1);
			}
			
			// hole buttresses
			translate([0,0, (cable_holder_l - cable_holder_hole_l) / 2])
			{
				davel_box_buttress([cable_holder_hole_thickness, cable_holder_w, cable_holder_hole_l], r=cable_holder_thickness / 2, left=false, front=false, back= false, $fs = 0.1);
			}
		}
	}
}


module lower_body_shell()
{
	$fs = 0.3;
	$fa = 5;
	
	union()
	{
		// base
		difference()
		{
			linear_extrude(height = base_plate_h) body_shell_profile(body_r - body_shell_thickness / 2);
			
			// battery strap slits
			for (i=[-1,1])
			{
				translate([body_battery_strap_slit_x * i, 0, base_plate_h/2])
				{
					cube([body_battery_strap_slit_w, body_battery_strap_slit_l, base_plate_h + 0.02], center=true);
				}
			}
		}
		
		// walls
		difference()
		{
			// wall
			linear_extrude(height=lower_body_h) body_shell_profile(body_r);
			
			// inside cavity
			linear_extrude(height=lower_body_h + 0.01 ) body_shell_profile(body_r - body_shell_thickness);
			
			// holes in the wall so the body doesn't fill the holder screw holes
			body_servo_holder_blocks(0);
			
			// holes for servo wires
			body_cable_holes();
			
			// hole for on/off switch
			translate([0, -body_r, (lower_body_h -  base_plate_h)/2 + base_plate_h])
				rotate([90,0,0])
					cylinder(d=body_switch_hole_d, h=body_r, center=true);
		}

		// servo holders
		for (i=[0:5])
		{
			body_servo_holder_position(i)
			{
				union()
				{
					// servo holder
					mirror_or_not([1,0,0], i<3)
					{
						servo_holder(with_bevel=true, bevel_back=false, bevel_bottom=false, draw_servo=false);
						
						translate([-servo_holder_w/2, servo_holder_axis_y + servo_holder_l,servo_holder_base_z])
						{
							// buttress
							davel_buttress_pos([servo_holder_w/2,0,base_plate_h], servo_holder_w, [0,1,0],[0,0,1], body_servo_holder_buttress_h);
						}
					}
				}
			}
		}
		
		// screw pillars
		for (a=body_screw_sides)
		{
			screw_hole_position(body_r, a)
			{
				difference()
				{
					// column					
					screw_hole_pillar(d=body_screw_column_d, h=lower_body_h, x = body_screw_hole_x);
				
					// hole
					translate([0,0,lower_body_h - body_screw_hole_h])
						cylinder(d=body_screw_hole_d, h = body_screw_hole_h + 0.01);
				}
			}			
		}
		

		// PCB pillars
		translate([0,0,base_plate_h])
		{
			// left PWM controller
			translate(pwm_controller_pos)
				translate([0,-pwm_controller_offset,0])
					pwm_controller_pillars();
			// right PWM controller
			mirror([1,0,0])
				translate(pwm_controller_pos)
					translate([0,pwm_controller_offset,0])
						pwm_controller_pillars();
			// arduino nano
			translate(arduino_pos) arduino_pillars();
		}
	}
}


module upper_body_shell()
{
	$fs = 0.3;
	$fa = 5;
	
	difference()
	{
		union()
		{
			difference()
			{
				// shell
				translate([0,0,lower_body_h])
				{
					upper_body_dome();
				}
				
				// internal cavity
				translate([0,0,lower_body_h - 0.01])
				{
					scxy = (body_r - body_shell_thickness) / body_r;
					scz = (upper_body_h - body_shell_thickness) / upper_body_h;
					scale([scxy, scxy, scz]) upper_body_dome();
				}
				
				// rectangular holes corresponding to the servo holder positions
				body_servo_holder_blocks(body_wedge_gap);
			}
			
			// screw hole pillars
			translate([0,0,lower_body_h])
			{
				intersection()
				{
					for (a=body_screw_sides)
					{
						screw_hole_position(body_r, a)
						{
							difference()
							{
								union()
								{
									// platform
									screw_hole_pillar(d=body_screw_column_d, h=body_screw_hole_platform_h, x = body_screw_hole_x);
									
									// wall around the hole above
									translate([0,0,body_screw_hole_platform_h])
									{
										screw_hole_pillar(d=body_screw_column_d, h=upper_body_h - body_screw_hole_platform_h + 0.01, x = body_screw_hole_x);
									}
								}
							}
						}			
					}
					
					upper_body_dome();
					
				}
			}
		}
		
		for (a=body_screw_sides)
		{
			screw_hole_position(body_r, a)
			{
				// hole
				translate([0,0, lower_body_h - 0.01])
					cylinder(d=body_screw_hole_d, h = body_screw_hole_platform_h + 0.02);
				
				// empty column above screws
				translate([0,0, lower_body_h + body_screw_hole_platform_h])
				{
					screw_hole_pillar(d=body_screw_head_d, h=upper_body_h - body_screw_hole_platform_h, x = body_screw_hole_x);
				}
			}
		}
	}
}


// ----------------------------------------------------------------------------------------

function hex_side_r(r) = cos(30 - asin(servo_holder_w/2 / r)) * r;

module screw_hole_position(r, a)
{
	rotate([0,0,a]) translate([0, hex_side_r(r) - body_screw_hole_x, 0]) children();
}

module screw_hole_pillar(d,h,x)
{
	cylinder(d=d, h=h);
	translate([0, x / 2, h / 2]) cube([d, x+0.01, h], center=true);
}

module servo_pillar(with_cable_slit=false)
{
	w = servo_holder_w;
	h = servo_holder_pillar_h;
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
	union()
	{
		linear_extrude(height=height)
			servo_horn_2d(gap);
		// skip first and last hole: too near to borders
		for (i=[1:4])
		{
			translate([0, -servo_horn_first_mini_hole_distance - i * servo_horn_mini_hole_distance, -servo_horn_mini_hole_h+0.01])
			{
				cylinder(d=servo_horn_mini_hole_d, h = servo_horn_mini_hole_h, $fs = 0.1);
			}
		}
	}
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

module pwm_controller_pillars()
{
	pcb_pillars(
		pwm_controller_hole_d,
		pwm_controller_pillar_d_top,
		pwm_controller_pillar_d_base,
		pwm_controller_pillar_h,
		pwm_controller_hole_h,
		pwm_controller_hole_distance_short,
		pwm_controller_hole_distance_long,
		pwm_controller_size_short,
		pwm_controller_size_long,
		pwm_controller_h);
}

module arduino_pillars()
{
	pcb_pillars(
		arduino_hole_d,
		arduino_pillar_d_top,
		arduino_pillar_d_base,
		arduino_pillar_h,
		arduino_hole_h,
		arduino_hole_distance_short,
		arduino_hole_distance_long,
		arduino_size_short,
		arduino_size_long,
		arduino_h);
}


/* origin is at center of PCB, on ground */
module pcb_pillars(hole_d, pillar_d, base_d, h, hole_h, hole_distance_x, hole_distance_y, pcb_w, pcb_l, pcb_h)
{
	translate([0, 0, h+pcb_h / 2])
	{
		%cube([pcb_w, pcb_l, pcb_h], center=true);
	}
		
	translate([-hole_distance_x/2, -hole_distance_y/2, 0])
		pcb_pillar(hole_d, pillar_d, base_d, h,  hole_h);
	translate([hole_distance_x/2, -hole_distance_y/2, 0])
		pcb_pillar(hole_d, pillar_d, base_d, h,  hole_h);
	translate([-hole_distance_x/2, hole_distance_y/2, 0])
		pcb_pillar(hole_d, pillar_d, base_d, h,  hole_h);
	translate([hole_distance_x/2, hole_distance_y/2, 0])
		pcb_pillar(hole_d, pillar_d, base_d, h,  hole_h);
}

/* origin is centerd on base of pillar */
module pcb_pillar(hole_d, pillar_d, base_d, h, hole_h)
{
	difference()
	{
		cylinder(d1=base_d, d2=pillar_d, h=h);
		translate([0,0,h-hole_h+0.01]) cylinder(d=hole_d, h=hole_h);
	}
}


module upper_body_dome()
{
	scale_bottom_to_top = upper_body_dome_r / body_r;
	linear_extrude(height=upper_body_h, scale = scale_bottom_to_top)
	{
		body_shell_profile(body_r);
	}
}

module body_servo_holder_position(index)
{
	a = leg_index_to_angle(index);
	v = [cos(a) * body_r_axes, sin(a) * body_r_axes, -servo_holder_base_z];
	translate(v) rotate([0,0,a + 90]) children();
}

/* leg index is 0 at front left leg. Note: + 2 so it's easy to tell left (0-2) from right (3-5) legs */
function leg_index_to_angle(leg) = 360 / 6 * (leg + 2);

/* angle of the side which is just back of the requested leg */
function back_of_leg_index_to_angle(leg) = 60 * (leg + 2) + 30;

module mirror_or_not(axis, do_it)
{
	if (do_it)
		mirror(axis) children();
	else
		children();
}

module body_servo_holder_blocks(gap)
{
	union()
	{
		for (i=[0:5])
		{
			body_servo_holder_position(i)
			{
				translate([servo_holder_axis_x, servo_holder_axis_y, servo_holder_base_z])
					cube([servo_holder_w, servo_holder_l, servo_holder_h+0.01]);
				
				scale(1.05)
				{
					SG90();
				}
			}
		}
	}
}

module body_cable_hole(leg,z)
{
	side_l = sin(30) * body_r * 2;
	dist = side_l/2 - servo_holder_w/2 - body_cable_hole_d / 2;
	
	a = (leg <=2) ? back_of_leg_index_to_angle(leg) : back_of_leg_index_to_angle(leg-1);
	left_or_right = (leg <= 2) ? -1 : 1;
	
	rotate([0,0,a])
	{
		translate([body_r,dist * left_or_right,  base_plate_h + body_cable_hole_d / 2])
		{
			rotate([0, -90,0]) cylinder(d=body_cable_hole_d, h=body_r);
		}
	}
}

module body_cable_holes()
{
	for (i=[0:5])
		body_cable_hole(i);
}

module body_shell_profile(r)
{
	a_offset = asin(servo_holder_w/2 / r);
	step = 360/6;
	
	p = [ for(i=[0:5]) each [
			[ cos(step * i - a_offset)*r, sin(step * i - a_offset)*r],
			[ cos(step * i + a_offset)*r, sin(step * i + a_offset)*r] ]
	];
	polygon(p);
}

module body_shell_screw_pillar()
{
	cylinder(d=body_screw_colum_d, h=total_body_h);
}

