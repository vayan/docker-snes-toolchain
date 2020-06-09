# i386 because if we use 64bit gcc some tools segault.
# trusty because some tools don't compile with latest gcc.
# didnt had time to debug so I just choose the oldest supported ubuntu that worked :)
FROM i386/ubuntu:trusty

RUN apt-get update && apt-get install make python linux-libc-dev binutils gcc g++ git wget -y

# I should probably check from time to time and update those commits (<- this will never happen...)
RUN git clone https://github.com/optixx/snes-sdk && git -C snes-sdk checkout 9fa04efab6b3c9817badf6c9ab2518e5572a6fba
RUN git clone https://github.com/alekmaul/pvsneslib && git -C pvsneslib checkout d04b86061a143384e1d2bf8ba7f5ee5e682a31c0
RUN git clone https://github.com/boldowa/snesbrr && git -C snesbrr checkout be3f210aef0e5992bb0ec6d139a0270145ced3b6

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

WORKDIR /pvsneslib/tools/bin2txt
RUN make all
RUN cp bin2txt.exe /d/snesdev/devkitsnes/tools/bin2txt

WORKDIR /pvsneslib/tools/smconv
RUN make all
RUN cp smconv.exe /d/snesdev/devkitsnes/tools/smconv

WORKDIR /snesbrr/src
RUN make all
RUN cp snesbrr /d/snesdev/devkitsnes/tools/snesbrr

RUN mkdir game
WORKDIR /game
