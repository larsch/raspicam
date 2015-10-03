include <raspicam.scad>;
offset = outer_radius * 1.2;
rotate(360/3,[0,0,1])
translate([offset,0,0])
rotate(-360/3,[0,0,1])
front_plate();
translate([offset,0,0])
rotate(-90, [0,1,0])
shell();
rotate(2*360/3,[0,0,1])
translate([offset,0,0])
rotate(-2*360/3,[0,0,1])
back_plate();
