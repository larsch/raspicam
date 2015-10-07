common = case/raspicam.scad case/rpi.scad case/pin_headers.scad

SCAD_FLAGS = --imgsize=2048,2048

all: images/internals.png images/build.png images/print.png images/frame.png

images/internals.png: case/internals.scad $(common)
	openscad $(SCAD_FLAGS) -o $(TEMP)/temp.png --camera=400,-120,50,80,0,0 case/internals.scad
	convert $(TEMP)/temp.png -resize 512x512 images/internals.png

images/build.png: case/build.scad $(common)
	openscad $(SCAD_FLAGS) -o $(TEMP)/temp.png case/build.scad
	convert $(TEMP)/temp.png -resize 512x512 images/build.png

images/print.png: case/print.scad case/raspicam.scad
	openscad $(SCAD_FLAGS) -o $(TEMP)/temp.png case/print.scad
	convert $(TEMP)/temp.png -resize 512x512 images/print.png

images/frame.png: case/frame.scad case/raspicam.scad
	openscad $(SCAD_FLAGS) -o $(TEMP)/temp.png case/frame.scad
	convert $(TEMP)/temp.png -resize 512x512 images/frame.png

clean:
	rm -rf images/*.png
