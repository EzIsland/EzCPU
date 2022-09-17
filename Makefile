
PROJECT_NAME:=snuff
TOP_LEVEL_ENTITY:=top_level_entity
VLIB_NAME:=work

ROOT_DIR:=$(realpath $(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
BUILD_DIR:=$(ROOT_DIR)/build
PROJECT_DIR:=$(BUILD_DIR)/project
MODELSIM_DIR:=$(BUILD_DIR)/modelsim
TS_DIR:=$(BUILD_DIR)/ts
CREATE_PROJECT_FILE:=$(ROOT_DIR)/create_project.tcl

MAP_TS_FILE:=$(TS_DIR)/map.ts
FIT_TS_FILE:=$(TS_DIR)/fit.ts
PROJECT_TS_FILE:=$(TS_DIR)/project.ts
STA_TS_FILE:=$(TS_DIR)/sta.ts
ASM_TS_FILE:=$(TS_DIR)/asm.ts
VLIB_TS_FILE:=$(TS_DIR)/vlib.ts

SRC_DIR:=$(ROOT_DIR)/src
TEST_DIR:=$(ROOT_DIR)/test
SRC_FILES:=$(wildcard $(SRC_DIR)/*.vhd)
TEST_FILES:=$(wildcard $(TEST_DIR)/*.vhd)

getTSFileForSrc=$(patsubst $(ROOT_DIR)/%.vhd,$(TS_DIR)/%.ts,$(1))
getSrcFileForTS=$(patsubst $(TS_DIR)/%.ts,$(ROOT_DIR)/%.vhd,$(1))
getTSFileList=$(foreach file,$(SRC_FILES) $(TEST_FILES),$(call getTSFileForSrc,$(file)))
getTBNameList=$(foreach file,$(TEST_FILES),$(patsubst $(TEST_DIR)/%.vhd,%,$(file)))
getTBFileForName=$(TEST_DIR)/$(1).vhd
deps=$(foreach dep,$(1),$(call getTSFileForSrc,$(ROOT_DIR)/$(dep)))

.SECONDEXPANSION:

$(PROJECT_TS_FILE): $(CREATE_PROJECT_FILE) $(SRC_FILES)
	cd $(PROJECT_DIR) && quartus_sh --script=$< $(PROJECT_NAME) "$(SRC_FILES)" $(TOP_LEVEL_ENTITY)
	touch $@

$(MAP_TS_FILE) : $(PROJECT_TS_FILE)
	cd $(PROJECT_DIR) && quartus_map $(PROJECT_NAME)
	touch $@

$(FIT_TS_FILE) : $(MAP_TS_FILE)
	cd $(PROJECT_DIR) && quartus_fit $(PROJECT_NAME)
	touch $@

$(STA_TS_FILE) : $(FIT_TS_FILE)
	cd $(PROJECT_DIR) && quartus_sta $(PROJECT_NAME)
	touch $@

$(ASM_TS_FILE) : $(FIT_TS_FILE)
	cd $(PROJECT_DIR) && quartus_asm $(PROJECT_NAME)
	touch $@

pgm : $(ASM_TS_FILE)
	cd $(PROJECT_DIR) && quartus_pgm -c USB-Blaster -m JTAG -o p\;$(PROJECT_NAME).sof

$(VLIB_TS_FILE):
	cd $(MODELSIM_DIR) && vlib $(VLIB_NAME)
	touch $@

$(call getTSFileList) : $$(call getSrcFileForTS,$$@) $(VLIB_TS_FILE)
	cd $(MODELSIM_DIR) && vcom -2008 $^
	touch $@

$(call getTBNameList) : $$(call getTSFileForSrc,$$(call getTBFileForName,$$@))
	cd $(MODELSIM_DIR) && vsim -c $(VLIB_NAME).$@ -do "run -all; exit"

test : $(call getTBNameList)

clean_project:
	rm -rf $(PROJECT_DIR)
	mkdir $(PROJECT_DIR)

clean_modelsim:
	rm -rf $(MODELSIM_DIR)
	mkdir $(MODELSIM_DIR)

clean_ts:
	rm -rf $(TS_DIR)
	mkdir $(TS_DIR)
	mkdir $(TS_DIR)/src
	mkdir $(TS_DIR)/test

clean:
	rm -rf $(BUILD_DIR)
	mkdir $(BUILD_DIR)
	mkdir $(PROJECT_DIR)
	mkdir $(MODELSIM_DIR)
	mkdir $(TS_DIR)
	mkdir $(TS_DIR)/src
	mkdir $(TS_DIR)/test

project : $(PROJECT_TS_FILE)
map : $(MAP_TS_FILE)
fit : $(FIT_TS_FILE)
sta : $(STA_TS_FILE)
asm : $(ASM_TS_FILE)

.PHONY: project map fit sta asm pgm clean_project clean_modelsim clean_ts clean test


#### DEPENDENCY DESCRIPTION ####

$(SRC_DIR)/top_level_entity.vhd : $(call deps, src/counter.vhd)
$(TEST_DIR)/counter_tb.vhd : $(call deps, src/counter.vhd test/util_pkg.vhd)
