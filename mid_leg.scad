include <include_servo_holder.scad>

rotate([0,90,0])
{
	%servo_holder(false);
	rotate([0,0,0])	// per prova
	joint_arm();
}