
# HaHaV3
# gowin

PROJECT  	:= spa
TOP      	:= top
FAMILY   	:= GW1N-9C
DEVICE   	:= GW1N-UV9LQ144C6/I5
VERILOGS := vsrc/*.v
SYS_VERILOGS := vsrc/*.sv

all: impl/pnr/project.fs

clean:
	rm -rf $(PROJECT).fs $(PROJECT).json $(PROJECT)_pnr.json $(PROJECT).tcl abc.history impl yosys.log

load: gowin_load

gowin_build: impl/pnr/project.fs

$(PROJECT).tcl: pins.cst $(VERILOGS) $(SYSVERILOGS)
	@echo "set_device -name $(FAMILY) $(DEVICE)" > $(PROJECT).tcl
	@for VAR in $(VERILOGS); do echo $$VAR | grep -s -q "\.v$$" && echo "add_file $$VAR" >> $(PROJECT).tcl; done
	@for VAR in $(SYS_VERILOGS); do echo $$VAR | grep -s -q "\.sv$$" && echo "add_file $$VAR" >> $(PROJECT).tcl; done
	@echo "add_file pins.cst" >> $(PROJECT).tcl
	@echo "set_option -top_module $(TOP)" >> $(PROJECT).tcl
	@echo "set_option -verilog_std sysv2017" >> $(PROJECT).tcl
	@echo "set_option -vhdl_std vhd2008" >> $(PROJECT).tcl
	@echo "set_option -use_sspi_as_gpio 1" >> $(PROJECT).tcl
	@echo "set_option -use_mspi_as_gpio 1" >> $(PROJECT).tcl
	@echo "set_option -use_done_as_gpio 1" >> $(PROJECT).tcl
	@echo "set_option -use_ready_as_gpio 1" >> $(PROJECT).tcl
	@echo "set_option -use_reconfign_as_gpio 1" >> $(PROJECT).tcl
	@echo "set_option -use_i2c_as_gpio 1" >> $(PROJECT).tcl
	@echo "run all" >> $(PROJECT).tcl

impl/pnr/project.fs: $(PROJECT).tcl
	gw_sh $(PROJECT).tcl
