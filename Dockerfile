# i386 because if we use 64bit gcc some tools segault.
# trusty because some tools don't compile with latest gcc.
# didnt had time to debug so I just choose the oldest supported ubuntu that worked :)
FROM i386/ubuntu:trusty

RUN apt-get update && apt-get install make python linux-libc-dev binutils gcc g++ git wget -y

# Those repos don't change too much we should be ok with master.
# But just in case here the working commits as of 3/5/2020:
# optixx/snes-sdk -> 9fa04efab6b3c9817badf6c9ab2518e5572a6fba
# alekmaul/pvsneslib -> 1f705a3367d0031c1f74de29247ef8a24aff0d74
# yes the time I took to wrote this is more effort than just cloning those commits.
RUN git clone https://github.com/optixx/snes-sdk
RUN git clone https://github.com/alekmaul/pvsneslib

# /d/snesdev/ is the default `DEVKITSNES` path from the pvsneslib template
RUN mkdir -p /d/snesdev/pvsneslib
RUN wget -qO- https://github.com/alekmaul/pvsneslib/releases/download/2.3.2/devkitsnes-2.3.2.tar.bz2 | tar -xvjf - -C /d/snesdev/
RUN wget -qO- https://github.com/alekmaul/pvsneslib/releases/download/2.3.2/pvsneslib-2.3.2.tar.bz2 | tar -xvjf - -C /d/snesdev/pvsneslib/

# /d/snesdev/devkitsnes/bin/816-opt.py is expecting python to be in /c/Python27/python
RUN mkdir -p /c/Python27/ && ln -sf /usr/bin/python /c/Python27/python

# smconv is expecting g++ in /e/MinGW32/bin/g++
RUN mkdir -p /e/MinGW32/bin/ && ln -sf /usr/bin/g++ /e/MinGW32/bin/g++

WORKDIR /snes-sdk
# SNES9X is not compiling and not needed, we can disable it with SNES9X=0
RUN make all SNES9X=0
RUN make install SNES9X=0 DESTDIR= PREFIX=/d/snesdev/devkitsnes

WORKDIR /pvsneslib/tools/constify
RUN make all
RUN cp constify.exe /bin/constify

WORKDIR /pvsneslib/tools/snestools
RUN make all
RUN cp snestools.exe /d/snesdev/devkitsnes/tools/snestools

WORKDIR /pvsneslib/tools/gfx2snes
RUN make all
RUN cp gfx2snes.exe /d/snesdev/devkitsnes/tools/gfx2snes

COPY ./patches /patches

WORKDIR /pvsneslib/tools/bin2txt
RUN cp /patches/bin2txt.c /pvsneslib/tools/bin2txt/bin2txt.c
RUN make all
RUN cp bin2txt.exe /d/snesdev/devkitsnes/tools/bin2txt

WORKDIR /pvsneslib/tools/smconv
RUN make all
RUN cp smconv.exe /d/snesdev/devkitsnes/tools/smconv

RUN mkdir game
WORKDIR /game
