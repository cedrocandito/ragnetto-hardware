include <include_constants.scad>
use <include_parts.scad>
use <davel/davel.scad>

$fa=1;
$fs=0.2;

body_r_axes = 75;
body_r= body_r_axes - servo_holder_axis_y - servo_holder_l + servo_holder_pillar_l;
body_h = servo_holder_h;
base_plate_h = servo_holder_wall_size_bottom;
body_shell_thickness = 2;

union()
{
	// base disc
	base_plate();		
	
	// walls
	difference()
	{
		// wall
		linear_extrude(height=body_h) shell_profile(body_r);
		// inside cavity
		linear_extrude(height=body_h + 0.01 ) shell_profile(body_r - body_shell_thickness);
		
		// holes in the wall so the body doesn't fill the holder screw holes
		for (i=[0:5])
		{
			servo_holder_position(i)
			{
				translate([-servo_holder_w/2, servo_holder_axis_y,servo_holder_base_z])
					cube([servo_holder_w, servo_holder_l, servo_holder_h + 0.01]);
			}
		}
		
		// holes for servo wires
	}

	// servo holders
	for (i=[0:5])
	{
		servo_holder_position(i)
		{
			union()
			{
				// servo holder
				servo_holder(with_bevel=true, bevel_back=false, bevel_bottom=false);
				
				translate([-servo_holder_w/2, servo_holder_axis_y + servo_holder_l,servo_holder_base_z])
				{
					
					// buttress
					davel_buttress_pos([servo_holder_w/2,0,base_plate_h], servo_holder_w, [0,1,0],[0,0,1], servo_holder_h - base_plate_h);
				}
			}
		}
	}

	// PCB pillars
	translate([-20,0,pwm_controller_pillar_h]) pwm_controller_pillars();
	translate([20,0,pwm_controller_pillar_h]) pwm_controller_pillars();
}

module servo_holder_position(index)
{
	a = 360 / 6 * index;
	v = [cos(a) * body_r_axes, sin(a) * body_r_axes, -servo_holder_base_z];
	translate(v) rotate([0,0,a + 90]) children();
}

module base_plate()
{
	linear_extrude(height = base_plate_h) shell_profile(body_r - body_shell_thickness / 2);
}

module shell_profile(r)
{
	a_offset = asin(servo_holder_w/2 / r);
	step = 360/6;
	
	p = [ for(i=[0:5]) each [
			[ cos(step * i - a_offset)*r, sin(step * i - a_offset)*r],
			[ cos(step * i + a_offset)*r, sin(step * i + a_offset)*r] ]
	];
	polygon(p);
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
