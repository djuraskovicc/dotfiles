# slstatus version
VERSION = 1.0

# customize below to fit your system

# paths
PREFIX = /usr/local
MANPREFIX = $(PREFIX)/share/man

X11INC = /usr/X11R6/include
X11LIB = /usr/X11R6/lib

# flags
CPPFLAGS = -I$(X11INC) -D_DEFAULT_SOURCE -D_XOPEN_SOURCE=700L -DVERSION=\"${VERSION}\"
CFLAGS   = -std=c99 -pedantic -Wall -Wno-deprecated-declarations -O3 -march=znver3 -mtune=native -pipe \
					 -fstack-protector-strong -D_FORTIFY_SOURCE=2

LDFLAGS  = -L$(X11LIB) -s
LDLIBS   = -lX11

# compiler and linker
CC = cc
