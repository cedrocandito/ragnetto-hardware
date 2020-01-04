use <include_parts.scad>
include <include_constants.scad>

with_ball_tip = false;
tip_w = 7;
tip_l = 7;
tip_h = 7;
tip_ball_d = 5;
tip_total_l = tip_l + tip_ball_d/2;
leg_beam_thickness = 4;
leg_side_space = 3;
leg_w = servo_arm_h_in - leg_side_space * 2;

$fa=1;
$fs = 0.3;

servo_arm_extra_dist = servo_arm_extra_dist_min;
servo_arm_axis_to_bracket = f_servo_arm_axis_to_bracket(servo_arm_extra_dist);

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
		
	translate([-servo_arm_axis_to_base - servo_arm_h_out / 2, servo_arm_axis_to_bracket, 0])
	{
			leg(l = leg_segment3_l - abs(servo_arm_axis_to_bracket), w =leg_w, h = servo_holder_w, with_ball_tip = with_ball_tip);
	}
}

module leg(w, l, h, bevel=bevel_r, with_ball_tip = false)
{
	lb = l - tip_total_l;
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
						[tip_w/2 * xs, -lb],
						[(tip_w/2 - leg_beam_thickness) * xs, -lb],
						[(w/2 - leg_beam_thickness) * xs,0]
					]);
				}
			}
			
			// slope
			rotate([0,-90,0])
			{
				#linear_extrude(height=leg_w, center=true)
				{
					polygon([
						[h/2, 0],
						[-h/2 + tip_h, -lb- 0.01],
						[-h/2 + tip_h + h, -lb - 0.01],
						[h/2 + h, 0]
					]);
				}
			}
		}
		
		translate([0, -lb, -(h - tip_h)/2])
		{
			foot();
		}
	}
}

module foot()
{
	translate([0,- tip_l/2, 0])
	{
		difference()
		{
			union()
			{
				// foot cube
				cube([tip_w, tip_l, tip_h], center=true);
			
				// ball tip
				if (with_ball_tip)
				{
					translate(0, -tip_l/2, 0) sphere(d=tip_ball_d);
				}
			}
		
			// hole if no ball tip
			if (!with_ball_tip)
			{
				translate([0, -tip_l/2, 0]) sphere(d=tip_ball_d);
			}
		}
	}
}
