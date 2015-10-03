include <raspicam.scad>;
internals = true;
translate([-11,0,0]) rotate(90, [0,1,0]) front_plate();
shell();
translate([house_length + 0.5, 0,0]) rotate(90, [0,1,0]) back_plate();
translate([house_length/2, outer_radius + 10,0])
rotate(90,[0,0,1]) rotate(-90,[0,1,0]) mount();
translate([house_length/2, -outer_radius-10,0]) rotate(-90,[0,0,1]) rotate(-90,[0,1,0]) mount();
