use <include_parts.scad>
use <davel/davel.scad>
include <include_constants.scad>


servo_arm_extra_dist = servo_arm_extra_dist_max;
servo_arm_axis_to_bracket = f_servo_arm_axis_to_bracket(servo_arm_extra_dist);

min_link_l =  -servo_arm_axis_to_bracket + servo_holder_l + servo_holder_axis_y;
assert(leg_segment2_l > min_link_l);


union()
{
	mirror([1,0,0])
	{
		rotate([0,90,0])
		{
			%servo_holder(with_bevel=false);
			
			union()
			{
				joint_arm(servo_arm_extra_dist, with_screw_holes=false, with_bottom_bevel=false);
			
				translate([0, -leg_segment2_l, 0])
				{
					// servo holder
					mirror([1,0,0])
					{
						servo_holder(with_bevel = true, bevel_back = false, bevel_bottom=false);
					}
					
					// connecting block
					translate([-servo_holder_w / 2, servo_holder_axis_y + servo_holder_l - 0.01, servo_holder_base_z])
					{
						hole_l =  leg_segment2_l - min_link_l;
						hole_h = servo_holder_h - servo_arm_bracket_size * 2;
						carve_hole = (hole_l > bevel_r * 2);
						hole_pos = [0,0,servo_arm_bracket_size];
						hole_size = [servo_holder_w + 0.02, hole_l, hole_h];
						
						union()
						{
							difference()
							{
								cube([servo_holder_w, leg_segment2_l - min_link_l + 0.02, servo_holder_h]);
								
								// hole in the connecting block (if enough space)
								if (carve_hole)
								{
									translate(hole_pos - [0.01,0,0]) cube(hole_size);
								}
							}
							
							//  buttress for hole in the connecting block (if enough space)
							if (carve_hole)
							{
								$fs = bevel_fs;
								$fa = 1;
								translate(hole_pos) davel_box_buttress(hole_size, r=bevel_r, left=false, right=false);
							}
						}
					}
				}
				
				// buttresses
				{
					r = abs(servo_arm_axis_to_base - servo_holder_base_z);
					assert(r > 0);
					
					translate([0, servo_arm_axis_to_bracket, servo_holder_base_z])
					{
						$fs = bevel_fs;
						$fa = 1;
						davel_buttress_pos([0,0,0], servo_holder_w, [0,-1,0], [0,0,-1], r);
						davel_buttress_pos([0,0,servo_holder_h], servo_holder_w, [0,-1,0], [0,0,1], r);
					}
				}
			}
		}
	}

	// cable holder
	translate([-servo_arm_axis_to_base, servo_arm_axis_to_bracket , 0])
		cable_holder();
}