# st version
VERSION = 0.9.2

# Customize below to fit your system

# paths
PREFIX = /usr/local
MANPREFIX = $(PREFIX)/share/man

X11INC = /usr/X11R6/include
X11LIB = /usr/X11R6/lib

PKG_CONFIG = pkg-config

# includes and libs
INCS = -I$(X11INC) \
       `$(PKG_CONFIG) --cflags fontconfig` \
       `$(PKG_CONFIG) --cflags freetype2`
LIBS = -L$(X11LIB) -lm -lrt -lX11 -lutil -lXft -lXrender\
       `$(PKG_CONFIG) --libs fontconfig` \
       `$(PKG_CONFIG) --libs freetype2`

# flags
STCPPFLAGS = -DVERSION=\"$(VERSION)\" -D_DEFAULT_SOURCE -D_XOPEN_SOURCE=700L
STCFLAGS = -std=c99 -pedantic -Wall -Wno-deprecated-declarations -O3 -march=znver3 -mtune=native -pipe \
					 -fstack-protector-strong -D_FORTIFY_SOURCE=2 $(INCS) $(STCPPFLAGS)
STLDFLAGS = $(LIBS)

# compiler and linker
CC = cc
