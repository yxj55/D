#include <common.h>
#include <isa.h>
#include<getopt.h>
#include <memory/paddr.h>

void init_isa();
void init_mem();
// void init_flash_mem();
void sim_init();
void init_sdb();
void init_disasm();
void init_difftest(char *ref_so_file, long img_size, int port);
void ftrace_elf(char * elf_file);

void sdb_set_batch_mode();

static char *diff_so_file = NULL;
static char *img_file = NULL;
static int difftest_port = 1234;

static long load_img() {
  //printf("load 进入成功\n");
  if (img_file == NULL) {
    Log("No image is given. Use the default build-in image.");
    return 4096; // built-in image size
  }

  FILE *fp = fopen(img_file, "rb");
  Assert(fp, "Can not open '%s'", img_file);

  fseek(fp, 0, SEEK_END);
  long size = ftell(fp);

  Log("The image is %s, size = %ld", img_file, size);

  fseek(fp, 0, SEEK_SET);
  int ret = fread(guest_to_host(RESET_VECTOR), size, 1, fp);
  assert(ret == 1);


  fclose(fp);
  return size;
}

static int parse_args(int argc, char *argv[]) {
 // printf("parse_args进入成功\n");
  
  
 
  //printf("argv[16]:%s\n",argv[5]);
  
  const struct option table[] = {
    {"batch"    , no_argument      , NULL, 'b'},
    {"log"      , required_argument, NULL, 'l'},
    {"diff"     , required_argument, NULL, 'd'},
    {"port"     , required_argument, NULL, 'p'},
    {"help"     , no_argument      , NULL, 'h'},
    {"ftrace"   , required_argument, NULL, 'f'},
    {0          , 0                , NULL,  0 },
  };
  
  int o;
  while ( (o = getopt_long(argc, argv, "-bhl:d:p:f:", table, NULL)) != -1) {
   // printf("o=%d\n",o);
    switch (o) {
     case 'f': printf("optarg :%s\n",optarg); ftrace_elf(optarg);break;
     case 'b': sdb_set_batch_mode(); break;
     // case 'p': sscanf(optarg, "%d", &difftest_port); break;
    //  case 'l': log_file = optarg; break;
    case 'd': diff_so_file = optarg; printf("right and diff_so_sile %s\n",diff_so_file); break;
      case 1: img_file = optarg;  return 0;
      default:
        printf("Usage: %s [OPTION...] IMAGE [args]\n\n", argv[0]);
        printf("\t-b,--batch              run with batch mode\n");
        printf("\t-l,--log=FILE           output log to FILE\n");
        printf("\t-d,--diff=REF_SO        run DiffTest with reference REF_SO\n");
        printf("\t-p,--port=PORT          run DiffTest with port PORT\n");
        printf("\n");
        exit(0);
    }
  }

  return 0;
}
void init_monitor(int argc, char *argv[]) {
  /* Perform some global initialization. */
  //printf("进入成功\n");
  /* Parse arguments. */
  parse_args(argc, argv);

  /* Set random seed. */
  //init_rand();

  /* Open the log file. */
  //init_log(log_file);
  sim_init();
  /* Initialize memory. */
  init_mem();
  // init_flash_mem();
  /* Initialize devices. */
  //IFDEF(CONFIG_DEVICE, init_device());

  /* Perform ISA dependent initialization. */
 init_isa();

  /* Load the image to memory. This will overwrite the built-in image. */
  long img_size = load_img();
printf("right\n\n");
  /* Initialize differential testing. */
init_difftest(diff_so_file, img_size, difftest_port);
printf("Yes!\n\n");
  /* Initialize the simple debugger. */
  init_sdb();

  IFDEF(CONFIG_ITRACE, init_disasm());

  /* Display welcome message. */
 // welcome();
}