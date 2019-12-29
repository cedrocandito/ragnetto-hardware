use <include_parts.scad>

rotate([0,90,0])
{
	%servo_holder(with_bevel=false);
	joint_arm(with_screw_holes=false);
}