// Raspberry Pi Camera Case & Stand - Copyright Lars Christensen
//
// License: CC BY-SA 2.0
// https://creativecommons.org/licenses/by-sa/2.0/legalcode
//
// This case was designed for the Rasperry Pi 1 Model B, because that
// the one i had lying around for this project. I power it via the pin
// header 5V pin using a DC-DC buck converter and an external 9V DC
// power supply. The camera ribbon cable is slighly skewed inside the
// case, because I wanted the case to be small and it doesn't line up
// well.

$fn = 128;
// $fs = 0.1;
// $fa = 6;
epsilon = 0.01;

led_radius = 2.5;
led_ring_radius = 40.0;
led_spacing = 10.0;

// frame mount screw sizes
mount_screw_shaft_diameter = 4 + 0.25;
mount_nut_diameter = 8;
mount_screw_head_diameter = 8;
mount_screw_head_height = 2;

// case screw sizes (for mounting front and back plates)
case_screw_thread_diameter = 2.5;
case_screw_shaft_diameter = 3 + 0.1;
case_screw_length = 13;
case_screw_head_diameter = 5.5;
case_screw_head_height = 2;

// camera screw sizes
cam_screw_thread_diameter = 1.75;

internals = false;

use <rpi.scad>;
use <cam.scad>;

module camera_hole(depth = 100.0) {
     border = 3.0;
     left_cutout = 8.0;
     pcb_outer_margin = 0.5;

     module screw_holes() {
	  translate([2,2,0]) cylinder(h = 3.5, d = cam_screw_thread_diameter);
	  translate([2,23,0]) cylinder(h = 3.5, d = cam_screw_thread_diameter);
	  translate([14.5,2,0]) cylinder(h = 3.5, d = cam_screw_thread_diameter);
	  translate([14.5,23,0]) cylinder(h = 3.5, d = cam_screw_thread_diameter);
     }

     module screw_supports() {
	  translate([2,2,0]) cylinder(h = 3.5, d = 4.0);
	  translate([2,23,0]) cylinder(h = 3.5, d = 4.0);
	  translate([14.5,2,0]) cylinder(h = 3.5, d = 4.0);
	  translate([14.5,23,0]) cylinder(h = 3.5, d = 4.0);
     }

     module lens_hole() {
	  translate([24 - 5.5 - 7.5/2, 25.0 / 2, -1.0])
	       cylinder(h = 15.0, d = 7.5); // outer lens ring
     }

     module top_connector() {
     	  translate([0, (25.0 - left_cutout)/2, 0.0])
	       cube([border + epsilon, left_cutout, 1.5]);
     }

     module main_pcb_hole() {
	  translate([-pcb_outer_margin, -pcb_outer_margin, -(depth-epsilon)])
	       cube([24.0 + 2 * pcb_outer_margin, 25.0 + 2 * pcb_outer_margin, depth]); // PCB and bottom components
     }

     module inner_camera_hole() {
	   difference() {
	       translate([border, border, -0.1])
		    cube([24 - 2 * border, 25.0 - 2 * border, 3.5 + 0.1]);
	       screw_supports();
	  }
     }


     module cable_hole() {
	  translate([24.0 - border - epsilon, (25.0-16.0)/2, -(depth-epsilon)])
	       cube([15.0, 16.0, depth]);
     }
     
     translate([-(24-9.5),-25/2, -3.5])
     union() {
	  inner_camera_hole();
	  main_pcb_hole();
	  top_connector();
	  screw_holes();
	  lens_hole();
	  cable_hole();
     }
}

module ir_led_cutout() {
     module ring(count, radius) {
	  for (i = [0:count - 1]) {
	       rotate(i * 360 / count, v=[0,0,1])
		    translate([radius, 0, 0])
		    cylinder(d = 5.0, h = 20.0, center = true);
	  }
     }
     ring(9, 25.0);
     ring(12, 35.0);
}

outer_radius = 45;

module hollow_cylinder(r1, r2, h) {
     difference() {
	  cylinder(r = r1, h = h);
	  translate([0,0,-1])
	       cylinder(r = r2, h = h + 2);
     }
}

module screw_holes(d) {
     translate([0,0,-1])
     for (i = [0:2]) {
	  rotate(360/3 * i, [0,0,1])
	       translate([outer_radius - thickness - 1.5, 0, 0])
	       cylinder(d = d, h = house_length);
     }
}

screw_support_r = 10;
screw_support_move_dist = outer_radius-3+screw_support_r-case_screw_head_diameter/2-3;
screw_support_cone_length = 30;
case_screw_move_dist = outer_radius-3-case_screw_head_diameter/2;

module screw_support_cone() {
     intersection() {
	  for (i=[0:2]) {
	       rotate(360/3*i, [0,0,1])
		    translate([screw_support_move_dist,0,0])
		    cylinder(screw_support_cone_length, screw_support_r / 3, screw_support_r);
	  }
	  cylinder(r = outer_radius - 0.1, h = screw_support_cone_length);
     }
}

module screw_support(hole_diameter, length) {
     intersection() {
	  for (i=[0:2]) {
	       rotate(360/3*i, [0,0,1])
		    difference() {
		    translate([screw_support_move_dist,0,0])
			 cylinder(r = screw_support_r, h = length);
		    translate([case_screw_move_dist,0,-1])
			 cylinder(d = hole_diameter, h = length + 2);
	       }
	  }
	  cylinder(r = outer_radius - 0.1, h = length);
     }
}

front_inner_depth = 5;

module front_plate() {
     front_thickness = 1.0;
     front_extra = 4.5;
     front_depth = front_inner_depth + front_extra + front_thickness;

     difference() {
	  union() {
	       rotate(180,[0,0,1])
		    rotate(180,[1,0,0])
		    translate([0,0,-front_thickness])
		    difference() {
		    translate([0,0,-front_extra])
			 cylinder(r = outer_radius, h = front_extra + front_thickness);
		    camera_hole();
		    rotate(45, [0,0,1])
			 ir_led_cutout();
	       }
	       hollow_cylinder(outer_radius, outer_radius - 3, front_extra + front_thickness + front_inner_depth);
	  }
     }
     translate([0,0,front_thickness + front_extra])
     rotate(10,[0,0,1])
     screw_support(case_screw_thread_diameter, front_inner_depth - 0.25);

     if (internals) {
	  translate([14.25,-12.5,10])
	  rotate(180,[0,1,0])
	  rpi_camera();
     }
}

rpi_length = 85;
rpi_width = 56;
rpi_height = 22; // excessive
gap = 0.25;
module rpi_cutout() {
     neg_cut = 30;
     pos_cut = 30;

     module support() {
	  w = 5;
	  difference() {
	       translate([-neg_cut,0,-1]) cube([neg_cut-gap+5, 5, 3.5+5+1+gap]);
	       translate([-gap,-1,-3]) cube([w+1,w+2,5+gap+3]);
	  }
     }

     sd_offset1 = 18;
     sd_offset2 = 42;
     supportw = 5;
     union() {
	  translate([0,0,-3.5])
	       difference() {
	       translate([-neg_cut+0.01,-gap,-20])
		    cube([rpi_length + neg_cut + gap, rpi_width+2*gap, rpi_height+20]);
	       translate([-neg_cut,-10,-20-gap])
		    cube([neg_cut + 10,rpi_width+20,20]);
	       translate([0,sd_offset1-supportw-1,0]) support();
	       translate([0,sd_offset2+1,0]) support();
	       translate([-neg_cut-1,-5+1,-30+3.5-gap]) cube([rpi_length+neg_cut+2,5,30]);
	       translate([-neg_cut-1,rpi_width-1,-30+3.5-gap]) cube([rpi_length+neg_cut+2,5,30]);
	       translate([-gap-neg_cut,-4,5+gap]) cube([37+neg_cut,5,1.5+2*gap]); // left ridge above pcb
	       translate([-gap-neg_cut,rpi_width-1,5+gap]) cube([rpi_length+neg_cut+5,5,1.5+2*gap]);
	  }
	  translate([rpi_length-1,24-gap,1.5+0.5-gap]) cube([pos_cut+1,15+2*gap,15.5+2*gap]); // USB port
	  translate([rpi_length-1,1.5-gap,1.5-gap]) cube([pos_cut+1,16+2*gap,13.25+2*gap]); // Ethernet port
	  translate([37-gap,-2,1.5+0.5-gap]) cube([rpi_length-37+2*gap,2+1,5.5+2*gap]); // HDMI */
	  translate([-rpi_inset-1,-50,1.5+0.5+5.5+3]) cube([rpi_length+rpi_inset+2*gap+2,50,rpi_height]); // left cutout
	  translate([42-gap,56-1,3.5+1.5]) cube([rpi_length-42+2*gap,8+1,9]); // composite
	  translate([61-gap,56,4.5-gap]) cube([rpi_length-61+2*gap,3.25+gap,6.75+2*gap]); // audio
     }
}

thickness = 3.0;
rpi_inset = 18+gap;
house_length = rpi_inset + rpi_length + 2*gap;
raspi_position = [ rpi_inset, -27.5, -26 ];
raspi_lower = 26;

module outer_cylinder() {
     cylinder(r = outer_radius, h = house_length);
}

module outer_cone() {
     translate([0,0,-5])
     cylinder($fn = 32, 15, 25, mount_screw_shaft_diameter/2 + 3);
     /* cylinder($fn = 32, 10, 20, 5); */
}

module shell() {
     module frame_mount() {
	  module outer_cones() {
	       difference() {
		    union() {
			 translate([house_length/2, outer_radius - 5,0])
			      rotate(-90,[1,0,0])
			      outer_cone();
			 translate([house_length/2, -(outer_radius - 5),0])
			      rotate(90,[1,0,0])
			      outer_cone();
		    }
		    rotate(90,[0,1,0])
			 cylinder(r = outer_radius - 1, h = house_length);
	       }
	  }

	  module nut() {
	       linear_extrude(height = 10)
	       circle($fn = 6, d = mount_nut_diameter);
	  }

	  module inner_cone() {
	       difference() {
		    cylinder(10, 27, mount_nut_diameter/2 + 3);
		    translate([0, 0, 10 - 2.5])
			 nut();
	       }
	  }
	  module inner_cones() {
	       intersection() {
		    union() {
			 translate([house_length/2, outer_radius + 3,0])
			      rotate(90,[1,0,0])
			      inner_cone();
			 translate([house_length/2, -(outer_radius + 3),0])
			      rotate(-90,[1,0,0])
			      inner_cone();
		    }
		    rotate(90,[0,1,0])
			 cylinder(r = outer_radius - thickness + 1, h = house_length);
	       }
	  }
	  difference() {
	       union() {
		    outer_cones();
		    inner_cones();
	       }
	  }
     }
     module frame_mount_screw_cutout() {
	  translate([house_length/2,1.5*outer_radius,0])
	       rotate(90, [1,0,0])
	       cylinder(d = mount_screw_shaft_diameter + 0.1, h = 3 * outer_radius);
     }	  

     module power_mount() {
	  module mount_cylinder() {
	       module screw_support() {
		    difference() {
			 cylinder(100, 10, 1.25+2.5);
			 translate([0,0,100-5])
			      cylinder(d = 2.5, h = 102);
		    }
	       }	  
	       translate([7.25, 3+15, -100])
		    screw_support();
	       translate([7.25+30, 3, -100])
		    screw_support();
	  }
	  intersection() {
	       union() {
		    translate([house_length-30, 0, 26])
			 rotate(30, [0,1,0])
			 translate([0,-22,-10])
			 rotate(90, [0,1,0])
			 rotate(90, [0,0,1])
			 union() {
			 if (internals) {
			      power();
			 }
			 mount_cylinder();
		    }
	       }
	       rotate(90,[0,1,0])
		    outer_cylinder();
	  }
     }

     module shell_case() {
	  rotate(90, [0,1,0])
	       difference() {
	       outer_cylinder();
	       translate([0,0,-1])
		    cylinder(r = outer_radius - thickness, h = house_length + 2);
	  }
     }

     module raspi_mount() {
	  if (internals)
	       translate(raspi_position)
		    rpi();
	  intersection() {
	       translate(raspi_position)
		    difference() {
		    translate([-rpi_inset, -outer_radius, -thickness - 3.5])
			 cube([house_length-gap-0.01, 4*outer_radius+2,rpi_height + thickness - 1]);
		    rpi_cutout();
	       }
	       rotate(90,[0,1,0]) outer_cylinder();
	  }
     }
     
     difference() {
	  union() {
	       shell_case();
	       frame_mount();
	  }
	  frame_mount_screw_cutout();
     }

     raspi_mount();
     power_mount();
     screw_supports();

     module screw_supports() {
	  twist = 10;
	  rotate(twist,[1,0,0])
	       rotate(90,[0,1,0])
	       screw_support(case_screw_shaft_diameter, case_screw_length - front_inner_depth);
	  
	  rotate(-twist,[1,0,0]) union() {
	       translate([house_length - (case_screw_length-3),0,0])
	       rotate(90,[0,1,0])
	       screw_support(case_screw_thread_diameter, case_screw_length - 3 - 0.25);
	       translate([house_length - (case_screw_length-3) - screw_support_cone_length,0,0])
	       rotate(90,[0,1,0])
	       screw_support_cone();
	  }
     }
}

module back_plate() {
     module power_jack_cutcout() {
	  union() {
	       translate([0,0,-1])
	       intersection() {
		    cylinder(d = 7.5, h = 20);
		    cube([6.5, 20, 30], center = true);
	       }
	       translate([0,0,2]) cylinder(d = 10.25, h = 20);
	  }
     }
     module screw_hole() {
	  union() {
	       translate([0,0,2]) cylinder(d = case_screw_head_diameter, h = 2); // screw head
	       translate([0,0,-1]) cylinder(d = case_screw_shaft_diameter, h = 5); // screw hole
	  }
     }
     module screw_holes() {
	  union() {
	       for(i=[0:2]) {
		    rotate(360/3*i,[0,0,1])
			 translate([case_screw_move_dist,0,0])
			 screw_hole();
	       }
	  }
     }
     difference() {
	  cylinder(r = outer_radius, h = 3); // back plate
	  rotate(-10,[0,0,1])
	       screw_holes();
	  rotate(-90, [0,1,0])
	       translate([-house_length,raspi_position[1],raspi_position[2]])
	       rpi_cutout();
	  translate([-5,0,0]) power_jack_cutcout();
     }
}

module mount() {
     mount_thickness = 7.5;
     mount_curve_radius = 8;
     mount_height = outer_radius + 20;

     l = mount_height - mount_curve_radius;
     y = l / (2 * cos(30) * sin(60));
     translate([-y,0,0])
	  difference() {
	  hull()
	       for(i=[0:2])
		    rotate(i*360/3)
			 translate([y,0,0])
			 cylinder(h = mount_thickness, r = mount_curve_radius);
	  hull()
	       for(i=[0:2])
		    rotate(i*360/3)
			 translate([y - 1.5 * mount_curve_radius,0,-1])
			 cylinder(h = mount_thickness + 2, r = mount_curve_radius * 0.2);

	  translate([y,0,-1])
	       cylinder(d=mount_screw_shaft_diameter,mount_thickness+2);
	  translate([y,0,-1])
	       cylinder(d = mount_screw_head_diameter, h = mount_screw_head_height + 1);
	  translate([y,0,mount_thickness+10-3])
	       rotate(180,[1,0,0])
	       outer_cone();
     }
}

module power() {
     union() {
	  color("blue")
	       difference() {
	       cube([43.5,20.8,1.25]);
	       translate([7.25, 3+15, -1]) cylinder(d = 3.5, h = 5);
	       translate([7.25+30, 3, -1]) cylinder(d = 3.5, h = 5);
	  }
	  color("gray")
	       translate([4.1, 10, 1.25]) cylinder(h = 10.35, d = 8);
	  color("gray")
	       translate([39.1, 10, 1.25]) cylinder(h = 10.35, d = 8);
	  color("lightblue")
	       translate([25.8, 20.8-4.5, 1.25])
	       cube([9.5,4.5,10.1]);
	  translate([25.8 + 1.1, 20.8-1.2, 10.1+1.25]) cylinder(h = 1.65, d = 2.2);
	  color("darkgrey")
	       translate([21.6, 0.5, 1.25]) cube([12.1,12.1,7.75]);
     }
}
