# 工具设置
VERILATOR = verilator
CXX = g++
MAKE = make

# Verilator 编译选项
VERILATOR_FLAGS += --cc --exe --build
VERILATOR_FLAGS += -O3 --x-assign fast --x-initial fast --noassert
VERILATOR_FLAGS += --trace  # 可选：生成波形支持

# 源文件设置
VSRC_DIR = vsrc
CSRC_DIR = csrc
TOP_MODULE = ysyx_25030093_top  # 修改为你的顶层模块名

# 自动查找所有 Verilog 文件
VSOURCES = $(shell find $(VSRC_DIR) -name "*.v")
CSOURCES = $(CSRC_DIR)/main.cpp

CXXFLAGS += -I$(shell pwd)/obj_dir  # 添加当前obj_dir
CXXFLAGS += -I../npc/obj_dir    
# 生成目标设置
OBJ_DIR = obj_dir
EXE = $(OBJ_DIR)/V$(TOP_MODULE)

# 默认目标
all: compile run

# 编译仿真程序
run:
	@echo "Verilating $(VSOURCES)..."
	$(VERILATOR) $(VERILATOR_FLAGS) \
		--top-module $(TOP_MODULE) \
		$(VSOURCES) $(CSOURCES)
	make -C obj_dir -f Vysyx_25030093_top.mk Vysyx_25030093_top
	@echo "Running simulation..."
	./obj_dir/Vysyx_25030093_top
	gtkwave dump.vcd

# 清理生成文件
clean:
	rm -rf $(OBJ_DIR) 
	rm -f *.vcd

.PHONY: all compile run wave clean
