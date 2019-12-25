include <include_constants.scad>

shaft_gap = 0.2;

shaft();

module shaft()
{
	$fa = shaft_fa;
	$fs = shaft_fs;
	
	translate([-shaft_base1_l / 2 + shaft_gap, -shaft_base1_l / 2 + shaft_gap, 0])
		cube([shaft_base1_l - shaft_gap * 2, shaft_base1_l - shaft_gap * 2, shaft_base1_h]);

	translate([0, 0, shaft_base1_h])
		cylinder(d=shaft_base2_d - shaft_gap * 2, h=shaft_base2_h);
	
	translate([0, 0, shaft_base1_h + shaft_base2_h])
		cylinder(d=shaft_d - shaft_gap * 2, h=shaft_h);
}