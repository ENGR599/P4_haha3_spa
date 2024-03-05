BASE_DIR 	:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

.PHONY: setup
setup:
	gowin_driver on

flash:
	cd /l/gowin/Programmer/bin/; ./programmer_cli --device GW1N-9C -r 2 --fsFile $(BASE_DIR)/switches_bitstream.fs
