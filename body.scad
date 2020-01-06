include <include_constants.scad>
use <include_parts.scad>
use <davel/davel.scad>

$fa=1;
$fs=0.2;

body_r_axes = 75;
body_r= body_r_axes - servo_holder_axis_y - servo_holder_l + servo_holder_pillar_l;
total_body_h = 30;
lower_body_h =15;
upper_body_h = total_body_h - lower_body_h;
upper_body_dome_r = 47;
base_plate_h = servo_holder_wall_size_bottom;
body_shell_thickness = 2;
body_wedge_gap = 0.3;
body_cable_hole_d = sg90_connector_w + 1;

assert(lower_body_h - base_plate_h > body_cable_hole_d +1);

lower_body_shell();
translate([0,0,0]) upper_body_shell();

module lower_body_shell()
{
	union()
	{
		// base disc
		base_plate();		
		
		// walls
		difference()
		{
			// wall
			linear_extrude(height=lower_body_h) shell_profile(body_r);
			// inside cavity
			linear_extrude(height=lower_body_h + 0.01 ) shell_profile(body_r - body_shell_thickness);
			
			// holes in the wall so the body doesn't fill the holder screw holes
			servo_holder_blocks(0);
			
			// holes for servo wires
			cable_holes();
		}

		// servo holders
		for (i=[0:5])
		{
			servo_holder_position(i)
			{
				union()
				{
					// servo holder
					mirror_or_not([1,0,0], i>=3)
					{
						servo_holder(with_bevel=true, bevel_back=false, bevel_bottom=false, draw_servo=false);
					}
					
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
}

module upper_body_shell()
{
	difference()
	{
		translate([0,0,lower_body_h]) 
		{
			upper_body_dome();
		}
		
		translate([0,0,lower_body_h - 0.01])
		{
			scxy = (body_r - body_shell_thickness) / body_r;
			scz = (upper_body_h - body_shell_thickness) / upper_body_h;
			scale([scxy, scxy, scz]) upper_body_dome();
		}
		
		servo_holder_blocks(body_wedge_gap);
	}
}

module upper_body_dome()
{
	scale_bottom_to_top = upper_body_dome_r / body_r;
	linear_extrude(height=upper_body_h, scale = scale_bottom_to_top)
	{
		shell_profile(body_r);
	}
}

module servo_holder_position(index)
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

module servo_holder_blocks(gap)
{
	for (i=[0:5])
	{
		servo_holder_position(i)
		{
			translate([-servo_holder_w/2 - gap, servo_holder_axis_y - gap,servo_holder_base_z - gap])
			{
				cube([servo_holder_w + gap*2, servo_holder_l + gap*2, servo_holder_h*2]);
				
				// buttress
				translate([servo_holder_w/2+gap,servo_holder_l + gap*2, base_plate_h + gap])
				{
					davel_buttress(servo_holder_w + gap*2, [0,1,0],[0,0,1], servo_holder_h - base_plate_h);
				}
			}
		}
	}
}

module cable_hole(leg,z)
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

module cable_holes()
{
	for (i=[0:5])
		cable_hole(i);
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
