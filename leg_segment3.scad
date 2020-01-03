use <include_parts.scad>
include <include_constants.scad>

with_ball_tip = false;
base_width = servo_arm_h_in;
tip_width = 5;
circle_r = 107;
bend_offset_side = 7;
bend_offset_top = 0;

$fa=0.5;
$fs = 0.5;

mirror([1,0,0])
{
	rotate([0,90,0])
	{
		%servo_holder(with_bevel=false);
		
		union()
		{
			joint_arm(with_screw_holes=false, with_bottom_bevel=true);
		
			translate([0, servo_arm_axis_to_bracket + servo_arm_bracket_size / 2, servo_arm_axis_to_base + servo_arm_h_out / 2])
			{
				foot(l = leg_segment3_l, w =base_width, h = servo_holder_w, with_ball_tip = with_ball_tip);
			}
		}
	}
}

module foot(w, l, h, bevel=bevel_r, with_ball_tip = false)
{
	la = l - tip_width/2;
	rotate([0,90,180])
	{		
		union()
		{
			difference()
			{
				// sides
				p = [ for(i=[0:0.01:1]) [i*i*i * w/2, (1-i)*la]];
				linear_extrude(height=h, center=true)
				{
					polygon(p);
				}
				
				// top
				rotate([0, 90, 0])
				{
					linear_extrude(height=base_width, center=true)
					{
						translate([-circle_r + h/2 - tip_width, la + bend_offset_top]) circle(r=circle_r);
					}
				}
				
				// hole if no ball tip
				translate([0, la, -h/2 + tip_width/2])
				{
					if (!with_ball_tip)
					{
						sphere(d=tip_width);
					}
				}
			}
			
			// tip
			translate([0, la, -h/2 + tip_width/2])
			{
				if (with_ball_tip)
				{
					sphere(d=tip_width);
				}
			}
		}
	}	
}

