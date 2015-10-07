include <raspicam.scad>;
translate([25,-25,0])
mount();
translate([-25,25,0])
rotate(180,[0,0,1]) mount();
