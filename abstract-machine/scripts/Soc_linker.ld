ENTRY(_start)
PHDRS { text PT_LOAD; data PT_LOAD; }

MEMORY {
  mrom : ORIGIN = 0x20000000, LENGTH = 4K
  sram : ORIGIN = 0x0f000000, LENGTH = 8K
}

SECTIONS {
  
  /* _pmem_start and _entry_offset are defined in LDFLAGS */
  . = _pmem_start + _entry_offset;
  . = ORIGIN(mrom);
  .text : {
    . = ALIGN(4);  /* 确保指令对齐 */
    *(entry)
    *(.text*)
  } > mrom AT> mrom : text

  _etext = .;

  .rodata : {
    . = ALIGN(4);
    *(.rodata*)
    *(.srodata*)
  } > mrom 

  _sidata  = LOADADDR(.data);

  .data : {
     . = ALIGN(4);
      _sdata = .;
    *(.data*)
    *(.sdata*)
     . = ALIGN(4);
    _edata = .;
  } > sram AT> mrom : data

 
  /* _data = .; */
  .bss : {
	_bss_start = .;
    *(.bss*)
    *(.sbss*)
    *(.scommon)
  _ebss = .; 
  } >sram AT> mrom

  _stack_top = ALIGN(16);
  . = _stack_top + 4k ;
  _stack_pointer = .;

    /* _heap_start = _ebss;
   . = _heap_start + 0x800;
   _heap_end = .; */
  /* end = .; */
  _end = .;
  
  
}