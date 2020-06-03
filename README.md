# docker-snes-toolchain ![Docker Pulls](https://img.shields.io/docker/pulls/vayan/snes-toolchain?style=flat-square) ![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/vayan/snes-toolchain?style=flat-square)

A Docker toolchain to build your SNES games using pvsneslib on any machine <sub><sup>(with docker)</sup></sub>.

# How to use it?
* Create a project using this template: https://github.com/alekmaul/pvsneslib/tree/master/pvsneslib/template
* then run `docker run -it --rm -v$(pwd):/game vayan/snes-toolchain make` inside your project folder
* and your `game.sfc` should appear!

If you have issue check that `DEVKITSNES` in your project Makefile is like the one in the template.

# TODO
- [ ] Find a way to get make the final sfc filename configurable (hardcoded to `game.sfc` for now)
- [ ] Fix build on recent gcc
- [ ] Optimizes docker image size (164.57 MB for now...)
- [ ] Maybe an issue with SRAM with some project (see https://github.com/alekmaul/pvsneslib/issues/36) 
no easy way to edit `SNESHEADER` for now
