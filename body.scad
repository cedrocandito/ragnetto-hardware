include <include_constants.scad>
use <include_parts.scad>
use <davel/davel.scad>

$fa=1;
$fs=0.2;

body_r_bottom =55;
body_r_top = 62;
body_r_axes = 85;
body_h = servo_holder_h;
base_plate_h = servo_holder_wall_size_bottom;

body_shell_thickness = 2;
body_servo_holder_attachment_l = 10;

union()
{
	// base disc
	base_plate();		
	
	// walls
	difference()
	{
		scale_top = body_r_top / body_r_bottom;
		linear_extrude(height=body_h, scale=scale_top) shell_profile(body_r_bottom);
		linear_extrude(height=body_h + 0.01, scale = scale_top) shell_profile(body_r_bottom - body_shell_thickness);
	}

	// servo holders
	for (i=[0:5])
	{
		a = 360 / 6 * i;
		v = [cos(a) * body_r_axes, sin(a) * body_r_axes, -servo_holder_base_z];
		translate(v)
		{
			rotate([0,0,a + 90])
			{
				union()
				{
					// servo holder
					servo_holder(with_bevel=true, bevel_back=false);
					
					translate([-servo_holder_w/2, servo_holder_axis_y + servo_holder_l,servo_holder_base_z])
					{
						union()
						{
							// attachment block
							difference()
							{
								s = [servo_holder_w, body_servo_holder_attachment_l, servo_holder_h];
								// attachmen block cube
								cube(s);
								// attachment block bevel
								davel_box_bevel(s, r=bevel_r, front=false, back=false, top=false, $fs=bevel_fs);
							}
							
							// attachment block buttress
							davel_buttress_pos([servo_holder_w/2,body_servo_holder_attachment_l,base_plate_h], servo_holder_w, [0,1,0],[0,0,1], servo_holder_h - base_plate_h);
						}
					}
				}
			}
		}
	}

	// PCB pillars
	translate([-20,0,pwm_controller_pillar_h]) pwm_controller_pillars();
	translate([20,0,pwm_controller_pillar_h]) pwm_controller_pillars();
}

module base_plate()
{
	linear_extrude(height = base_plate_h) shell_profile(body_r_bottom);
}

module shell_profile(r)
{
	a_offset = asin(servo_holder_w/2 / r);
	step = 360/6;
	
	//p = [ for(i=[0:5]) [ cos(360/6 * i)*r, sin(360/6 * i)*r] ];
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
