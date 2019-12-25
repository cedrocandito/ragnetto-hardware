include <sg90.scad>

servo_holder_gap = 0.5;
servo_holder_wall_size = 2;


servo_holder_w = sg90_main_w + servo_holder_gap * 2 + servo_holder_wall_size * 2;
servo_holder_l = sg90_ledge_l + servo_holder_gap * 2 + servo_holder_wall_size * 2;
servo_holder_base_h = servo_holder_wall_size;
servo_holder_axis_x = -servo_holder_w / 2;
servo_holder_axis_y = -(sg90_ledge_l - sg90_main_l)/2 - sg90_tower_d/2 - servo_holder_gap - servo_holder_wall_size;
servo_holder_hole_extra = 2;


translate([servo_holder_axis_x, servo_holder_axis_y, -servo_holder_wall_size - servo_holder_gap])
	cube([servo_holder_w, servo_holder_l, servo_holder_base_h]);

translate([0,servo_holder_axis_y,-servo_holder_gap])
	servo_pillar();
translate([0,servo_holder_axis_y + servo_holder_l,-servo_holder_gap])
	rotate([0, 0, 180])
		servo_pillar();

%SG90();

module servo_pillar()
{
	l = (sg90_ledge_l - sg90_main_l) / 2;
	w = servo_holder_w;
	ledge_l = (sg90_ledge_l - sg90_main_l) / 2;
	hole_h = sg90_mount_screw_h  - sg90_ledge_h + servo_holder_hole_extra;
	
	h = sg90_ledge_z + servo_holder_gap;
	h1 = sg90_cable_z + sg90_cable_h + servo_holder_gap;
	h3 = hole_h;
	h2 = h - h1 - h3;

	difference()
	{
		translate([-w/2,0,0])
		{
			rotate([90,0,90])
			{
				linear_extrude(height=w)
				{
					polygon([
						[0, 0],
						[servo_holder_wall_size, 0],
						[servo_holder_wall_size, h1],
						[servo_holder_wall_size + ledge_l, h1 + h2],
						[servo_holder_wall_size + ledge_l, h1 + h2 + h3],
						[0, h1 + h2 + h3],
					]);
				}
			}
		}
		
		#translate([0, sg90_mount_hole_offset_y_from_axis - servo_holder_axis_y, h - hole_h])
			cylinder(d = sg90_mount_hole_d * 0.7, h = hole_h+0.1, $fa=5, $fs=0.1);
		
	}
}