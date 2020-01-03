include <include_constants.scad>
use <include_parts.scad>

$fa=1;
$fs=0.2;

body_d = 150;
base_plate_h = servo_holder_wall_size_bottom;


body_r = body_d / 2;

union()
{
	difference()
	{
		// base disc
		base_plate();
		
		// indentations
		indent_center_r = body_r - 10;
		for (i=[0:5])
		{
			a = 360 / 6 * i + 30;
			v = [cos(a) * indent_center_r, sin(a) * indent_center_r, 0];
			translate(v) #circle(r=26);
		}
	}

	// servo holders
	for (i=[0:5])
	{
		a = 360 / 6 * i;
		v = [cos(a) * body_r, sin(a) * body_r, 0];
		translate(v)
		{
			rotate([0,0,a + 90])
			{
				servo_holder(with_bevel=false);
			}
		}
	}

	// PCB pillars
	translate([-20,0,pwm_controller_pillar_h]) pwm_controller_pillars();
	translate([20,0,pwm_controller_pillar_h]) pwm_controller_pillars();
}

module base_plate()
{
	translate([0,0,-base_plate_h])
	{
		linear_extrude(height = base_plate_h)
		{
			circle(r=body_r - servo_holder_l + abs(servo_holder_axis_y) + servo_holder_l / 2);
		}
	}
}


module pwm_controller_pillars()
{
	pillars(
		pwm_controller_hole_d,
		pwm_controller_pillar_d_top,
		pwm_controller_pillar_d_base,
		pwm_controller_pillar_h,
		pwm_controller_hole_h,
		pwm_controller_hole_distance_short,
		pwm_controller_hole_distance_long);
}


/* origin is at center of PCB */
module pillars(hole_d, pillar_d, base_d, h, hole_h, hole_distance_x, hole_distance_y)
{
	translate([-hole_distance_x/2, -hole_distance_y/2, 0])
		pillar(hole_d, pillar_d, base_d, h, hole_h);
	translate([hole_distance_x/2, -hole_distance_y/2, 0])
		pillar(hole_d, pillar_d, base_d, h, hole_h);
	translate([-hole_distance_x/2, hole_distance_y/2, 0])
		pillar(hole_d, pillar_d, base_d, h, hole_h);
	translate([hole_distance_x/2, hole_distance_y/2, 0])
		pillar(hole_d, pillar_d, base_d, h, hole_h);
}

/* origin is centerd on PCB hole */
module pillar(hole_d, pillar_d, base_d, h, hole_h)
{
	difference()
	{
		translate([0,0,-h]) cylinder(d1=base_d, d2=pillar_d, h=h);
		translate([0,0,-hole_h+0.01]) cylinder(d=hole_d, h=hole_h);
	}
}
