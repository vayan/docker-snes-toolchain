# docker-snes-toolchain

WRITEME: Description

# How to build your snes project with this docker toolchain:
# Create a project using this template: https://github.com/alekmaul/pvsneslib/tree/master/pvsneslib/template
# then run `docker run -it --rm -v$(pwd):/game vayan/snes-toolchain make` inside your project folder
# and your `game.sfc` should appear!
#
# if you have issue check that `DEVKITSNES` in your project Makefile is like the one in the template