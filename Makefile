common = case/raspicam.scad case/rpi.scad case/pin_headers.scad

all: images/internals.png images/build.png images/print.png

images/internals.png: case/internals.scad $(common)
	openscad -o images/internals.png --camera=400,-120,50,80,0,0 case/internals.scad

images/build.png: case/build.scad $(common)
	openscad -o images/build.png case/build.scad

images/print.png: case/print.scad case/raspicam.scad
	openscad -o images/print.png case/print.scad

clean:
	rm -rf images/*.png
