/***************************************************************************************
* Copyright (c) 2014-2024 Zihao Yu, Nanjing University
*
* NEMU is licensed under Mulan PSL v2.
* You can use this software according to the terms and conditions of the Mulan PSL v2.
* You may obtain a copy of Mulan PSL v2 at:
*          http://license.coscl.org.cn/MulanPSL2
*
* THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
* EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
* MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
*
* See the Mulan PSL v2 for more details.
***************************************************************************************/

#include <dlfcn.h>
#include </home/yuanxiao/ysyx-workbench/nemu/tools/capstone/repo/include/capstone/capstone.h>
#include <common.h>

// 1. 定义函数指针类型
typedef cs_err (*cs_open_func_t)(cs_arch, cs_mode, csh*);
typedef size_t (*cs_disasm_func_t)(csh, const uint8_t*, size_t, uint64_t, size_t, cs_insn**);
typedef void (*cs_free_func_t)(cs_insn*, size_t);

// 2. 声明全局函数指针变量
static cs_open_func_t cs_open_dl = NULL;
static cs_disasm_func_t cs_disasm_dl = NULL;
static cs_free_func_t cs_free_dl = NULL;

static csh handle;

void init_disasm() {
    void *dl_handle;
    dl_handle = dlopen("/home/yuanxiao/ysyx-workbench/nemu/tools/capstone/repo/libcapstone.so.5", RTLD_LAZY);
    assert(dl_handle);

    // 3. 使用 dlsym 并强制转换
    cs_open_dl = (cs_open_func_t)dlsym(dl_handle, "cs_open");
    assert(cs_open_dl);

    cs_disasm_dl = (cs_disasm_func_t)dlsym(dl_handle, "cs_disasm");
    assert(cs_disasm_dl);

    cs_free_dl = (cs_free_func_t)dlsym(dl_handle, "cs_free");
    assert(cs_free_dl);

    cs_arch arch = CS_ARCH_RISCV;
    cs_mode mode = CS_MODE_RISCV32;

    int ret = cs_open_dl(arch, mode, &handle);
    assert(ret == CS_ERR_OK);


}

void disassemble(char *str, int size, uint64_t pc, uint8_t *code, int nbyte) {
    cs_insn *insn;
    size_t count = cs_disasm_dl(handle, code, nbyte, pc, 0, &insn);
    assert(count == 1);
    int ret = snprintf(str, size, "%s", insn->mnemonic);
    if (insn->op_str[0] != '\0') {
        snprintf(str + ret, size - ret, "\t%s", insn->op_str);
    }
    cs_free_dl(insn, count);
}