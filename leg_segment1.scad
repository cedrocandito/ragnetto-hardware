use <include_parts.scad>
include <include_constants.scad>


rotate([0,90,0])
{
	%servo_holder(with_bevel=false);
	
	union()
	{
		joint_arm(with_screw_holes=false, with_bottom_bevel=false);
	
		translate([
			servo_holder_w/2 - servo_holder_wall_size_bottom - servo_holder_gap_bottom,
			servo_arm_axis_to_bracket - servo_holder_w/2,
			servo_arm_axis_to_base - servo_holder_axis_y
		])
		{
			rotate([0, -90,0])
			{
				rotate([0, 0,-90])
				{
					servo_holder(with_bevel = true, bevel_left = false, bevel_bottom = false);
					
					// buttresses
					bevel_r =  min(servo_arm_bracket_size, servo_holder_h - servo_holder_w);
					translate([
						-servo_holder_w /2,
						servo_holder_axis_y,
						sg90_ledge_z - servo_holder_h + servo_holder_w
					])
					{
						simple_bevel([0,servo_holder_pillar_l/2,0],[0,1,0],[1,0,-1],servo_holder_pillar_l, r = bevel_r);
						simple_bevel([0,servo_holder_l - servo_holder_pillar_l/2,0],[0,1,0],[1,0,-1],servo_holder_pillar_l, r = bevel_r);
					}
				}
			}
		}
	}
}