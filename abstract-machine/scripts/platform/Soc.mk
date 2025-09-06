AM_SRCS := riscv/Soc/start.S \
           riscv/Soc/trm.c \
		   riscv/Soc/spi.c\
		   riscv/Soc/flash_read.c

CFLAGS    += -fdata-sections -ffunction-sections
CFLAGS    += -I$(AM_HOME)/am/src/riscv/Soc/include
LDSCRIPTS += $(AM_HOME)/scripts/Soc_linker.ld
LDFLAGS   += --defsym=_pmem_start=0x20000000 --defsym=_entry_offset=0x0
LDFLAGS   += --gc-sections -e _start

MAINARGS_MAX_LEN = 64
MAINARGS_PLACEHOLDER = The insert-arg rule in Makefile will insert mainargs here.
CFLAGS += -DMAINARGS_MAX_LEN=$(MAINARGS_MAX_LEN) -DMAINARGS_PLACEHOLDER=\""$(MAINARGS_PLACEHOLDER)"\"

insert-arg: image
	@echo "insert-arging"
	@python3 $(AM_HOME)/tools/insert-arg.py $(IMAGE).bin $(MAINARGS_MAX_LEN) "$(MAINARGS_PLACEHOLDER)" "$(mainargs)"

image: image-dep
	@$(OBJDUMP) -d $(IMAGE).elf > $(IMAGE).txt
	@echo + OBJCOPY "->" $(IMAGE_REL).bin
	@$(OBJCOPY) -S --set-section-flags .bss=alloc,contents -O binary $(IMAGE).elf $(IMAGE).bin

run: insert-arg
	@echo "Running"
	$(MAKE) -C $(NPC_HOME) ISA=$(ISA) run IMG=$(IMAGE).bin


.PHONY: insert-arg
