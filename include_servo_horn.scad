servo_horn_hub_d = 6.9;
servo_horn_total_l = 19.6;
servo_horn_arm_w_min = 3.9;
servo_horn_arm_w_max = 5.6;

hub_r = servo_horn_hub_d / 2;
arm_tip_r = servo_horn_arm_w_min / 2;
arm_l = servo_horn_total_l - hub_r - arm_tip_r;

module servo_arm_2d(gap)
{
	$fs = 0.1;
	$fa = 1;
	
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

module servo_arm(height=1.35, gap=0.2)
{
	linear_extrude(height=height)
		servo_arm_2d(gap);
}