use <include_parts.scad>
use <davel/davel.scad>
include <include_constants.scad>

$fa = 1;
$fs = 0.2;

servo_arm_extra_dist = servo_arm_extra_dist_min;
servo_arm_axis_to_bracket = f_servo_arm_axis_to_bracket(servo_arm_extra_dist);

leg_segment_1_length = abs(f_servo_arm_axis_to_bracket(servo_arm_extra_dist)) +  servo_holder_w/2;
echo(leg_segment_1_length = leg_segment_1_length);

union()
{
	rotate([0,90,0])
	{
		%servo_holder(with_bevel=false);
			
		union()
		{
			joint_arm(servo_arm_extra_dist = servo_arm_extra_dist_min, with_screw_holes=false, with_bottom_bevel=false);
		
			translate([
				servo_holder_w/2 - servo_holder_wall_size_bottom - servo_holder_gap_bottom,
				servo_arm_axis_to_bracket - servo_holder_w/2 + 0.01 /* merge objects together */,
				servo_arm_axis_to_base - servo_holder_axis_y
			])
			{
				rotate([0, -90,0])
				{
					rotate([0, 0,-90])
					{
						servo_holder(with_bevel = true, bevel_left = false, bevel_bottom = false, draw_servo=true);
						
						// buttress
						bevel_r =  min(servo_arm_bracket_size, servo_holder_h - servo_holder_w);
						translate([
							-servo_holder_w /2,
							servo_holder_axis_y,
							sg90_ledge_z - servo_holder_h + servo_holder_w
						])
						{
							$fs = bevel_fs;
							davel_buttress_pos([0,servo_holder_l/2,0], servo_holder_l, [-1,0,0], [0,0,1],bevel_r);
						}
					}
				}
			}
		}
	}
		
	// cable holder
	translate([servo_arm_axis_to_base, servo_arm_axis_to_bracket / 2, 0])
		rotate([0,0,180])
			cable_holder();
}