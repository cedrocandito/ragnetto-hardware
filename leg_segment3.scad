use <include_parts.scad>
include <include_constants.scad>



$fa=1;
$fs = 0.3;

servo_arm_extra_dist = servo_arm_extra_dist_min;
servo_arm_axis_to_bracket = f_servo_arm_axis_to_bracket(servo_arm_extra_dist);
lower_leg_w = servo_arm_h_in - lower_leg_side_space * 2;

leg_l = leg_segment3_l - abs(servo_arm_axis_to_bracket);

union()
{
	mirror([1,0,0])
	{
		rotate([0,90,0])
		{
			%servo_holder(with_bevel=false);
			joint_arm(servo_arm_extra_dist, with_screw_holes=false, with_bottom_bevel=true);
		}
	}
		
	translate([-servo_arm_axis_to_base - servo_arm_h_out / 2, servo_arm_axis_to_bracket + 0.01, 0])
	{
			leg(l = leg_segment3_l - abs(servo_arm_axis_to_bracket), w =lower_leg_w, h = servo_holder_w, foot_with_ball_tip = foot_with_ball_tip);
	}
}

module leg(w, l, h, bevel=bevel_r, foot_with_ball_tip = false)
{
	lb = l - foot_l;
	foot_tip_pos = [0, -lb, -(h - foot_h)/2];
	
	union()
	{
		// beams
		difference()
		{
			linear_extrude(height=h, center=true)
			{
				for (xs=[-1,1])
				{
					polygon([
						[w/2 * xs, 0],
						[foot_w/2 * xs, -lb],
						[(foot_w/2 - lower_leg_beam_thickness) * xs, -lb],
						[(w/2 - lower_leg_beam_thickness) * xs,0]
					]);
				}
			}
			
			// slope
			rotate([0,-90,0])
			{
				linear_extrude(height=lower_leg_w, center=true)
				{
					polygon([
						[h/2, 0],
						[-h/2 + foot_h, -lb- 0.01],
						[-h/2 + foot_h + h, -lb - 0.01],
						[h/2 + h, 0]
					]);
				}
			}
			
			if (!foot_with_ball_tip)
			{
				translate(foot_tip_pos)
				{
					sphere(d=foot_tip_hole_d);
				}
			}
		}
		
		if (foot_with_ball_tip)
		{
			translate(foot_tip_pos)
			{
				sphere(d=foot_tip_ball_d);
			}
		}
	}
}

module foot()
{
	translate([0,- foot_tip_l/2, 0])
	{
		difference()
		{
			union()
			{
				// foot cube
				cube([foot_w, foot_tip_l, foot_h], center=true);
			
				// ball tip
				if (foot_with_ball_tip)
				{
					translate(0, -foot_tip_l/2, 0) sphere(d=foot_tip_ball_d);
				}
			}
		
			// hole if no ball tip
			if (!foot_with_ball_tip)
			{
				translate([0, -tip_l/2, 0]) sphere(d=tip_ball_d);
			}
		}
	}
}
