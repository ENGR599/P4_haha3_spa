BASE_DIR 	:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
BITSTREAM 	:=switches.fs
GROUP       :=1
TARGET  	:=1

.PHONY: setup
setup:
	gowin_driver on

switches:
	cd /l/gowin/Programmer/bin/; ./programmer_cli --device GW1N-9C -r 2 --fsFile "$(BASE_DIR)/switches_bitstream.fs"

flash:
	cd /l/gowin/Programmer/bin/; ./programmer_cli --device GW1N-9C -r 2 --fsFile "$(BASE_DIR)/group_$(GROUP)/target_$(TARGET).fs"
