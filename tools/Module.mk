# I2C tools for Linux
#
# Copyright (C) 2007, 2012  Jean Delvare <jdelvare@suse.de>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.

TOOLS_DIR	:= tools

TOOLS_CFLAGS	:= -Wstrict-prototypes -Wshadow -Wpointer-arith -Wcast-qual \
		   -Wcast-align -Wwrite-strings -Wnested-externs -Winline \
		   -W -Wundef -Wmissing-prototypes -Iinclude
ifeq ($(USE_STATIC_LIB),1)
TOOLS_LDFLAGS	:= $(LIB_DIR)/$(LIB_STLIBNAME)
else
TOOLS_LDFLAGS	:= -L$(LIB_DIR) -li2c
endif

TOOLS_TARGETS	:= i2cping

#
# Programs
#

$(TOOLS_DIR)/i2cping: $(TOOLS_DIR)/i2cping.o $(TOOLS_DIR)/i2cbusses.o $(LIB_DEPS)
	$(CC) $(LDFLAGS) -o $@ $^ $(TOOLS_LDFLAGS)

#
# Objects
#

$(TOOLS_DIR)/i2cping.o: $(TOOLS_DIR)/i2cping.c $(TOOLS_DIR)/i2cbusses.h version.h $(INCLUDE_DIR)/i2c/smbus.h
	$(CC) $(CFLAGS) $(TOOLS_CFLAGS) -c $< -o $@

$(TOOLS_DIR)/i2cbusses.o: $(TOOLS_DIR)/i2cbusses.c $(TOOLS_DIR)/i2cbusses.h
	$(CC) $(CFLAGS) $(TOOLS_CFLAGS) -c $< -o $@

#
# Commands
#

all-tools: $(addprefix $(TOOLS_DIR)/,$(TOOLS_TARGETS))

strip-tools: $(addprefix $(TOOLS_DIR)/,$(TOOLS_TARGETS))
	$(STRIP) $(addprefix $(TOOLS_DIR)/,$(TOOLS_TARGETS))

clean-tools:
	$(RM) $(addprefix $(TOOLS_DIR)/,*.o $(TOOLS_TARGETS))

install-tools: $(addprefix $(TOOLS_DIR)/,$(TOOLS_TARGETS))
	$(INSTALL_DIR) $(DESTDIR)$(bindir) $(DESTDIR)$(man8dir)
	for program in $(TOOLS_TARGETS) ; do \
# 	$(INSTALL_PROGRAM) $(TOOLS_DIR)/$$program $(DESTDIR)$(bindir) ; \
# 	$(INSTALL_DATA) $(TOOLS_DIR)/$$program.8 $(DESTDIR)$(man8dir) ; done
	$(INSTALL_PROGRAM) $(TOOLS_DIR)/$$program $(DESTDIR)$(bindir) ; done

uninstall-tools:
	for program in $(TOOLS_TARGETS) ; do \
# 	$(RM) $(DESTDIR)$(bindir)/$$program ; \
# 	$(RM) $(DESTDIR)$(man8dir)/$$program.8 ; done
	$(RM) $(DESTDIR)$(bindir)/$$program ; done

all: all-tools

strip: strip-tools

clean: clean-tools

install: install-tools

uninstall: uninstall-tools
