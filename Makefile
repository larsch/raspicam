common = case/raspicam.scad case/rpi.scad case/pin_headers.scad

SCAD_FLAGS = -D\\$$fs=0.5 -D\\$$fa=4
SCAD_PNG_FLAGS = $(SCAD_FLAGS) --imgsize=2048,2048

all: images/internals.png images/build.png images/print.png images/frame.png \
	stl/print.stl stl/frame.stl

images/internals.png: case/internals.scad $(common)
	openscad $(SCAD_PNG_FLAGS) -o temp.png --camera=400,-120,50,80,0,0 case/internals.scad
	convert temp.png -resize 512x512 images/internals.png
	rm temp.png

images/build.png: case/build.scad $(common)
	openscad $(SCAD_PNG_FLAGS) -o temp.png case/build.scad
	convert temp.png -resize 512x512 images/build.png
	rm temp.png

images/print.png: case/print.scad case/raspicam.scad
	openscad $(SCAD_PNG_FLAGS) -o temp.png case/print.scad
	convert temp.png -resize 512x512 images/print.png
	rm temp.png

images/frame.png: case/frame.scad case/raspicam.scad
	openscad $(SCAD_PNG_FLAGS) -o temp.png case/frame.scad
	convert temp.png -resize 512x512 images/frame.png
	rm temp.png

stl/%.stl: case/%.scad
	openscad -o $@ $(SCAD_FLAGS) -r $<

clean:
	rm -rf images/*.png stl/*.stl
