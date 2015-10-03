include <raspicam.scad>;
internals = true;
translate([-40,0,0]) rotate(90, [0,1,0]) front_plate();
shell();
translate([house_length + 40, 0,0]) rotate(90, [0,1,0]) back_plate();
translate([house_length/2, outer_radius + 20,0])
rotate(90,[0,0,1]) rotate(-90,[0,1,0]) mount();
translate([house_length/2, -outer_radius-20,0]) rotate(-90,[0,0,1]) rotate(-90,[0,1,0]) mount();
