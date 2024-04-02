#include "mips.h"
#include "pipe.h"
#include "shell.h"
#include <stdio.h>

#define DEBUG

void print_op(Pipe_Op *op)
{
    printf("%p\n", op);
}

void pipe_init()
{
    printf("pipe_init\n");
}

void pipe_cycle()
{
    printf("pipe_cycle\n");
}

void pipe_recover(int flush, uint32_t dest)
{
    printf("pipe_recover\n");
}

void pipe_stage_fetch()
{
    printf("pipe_stage_fetch\n");
}
void pipe_stage_decode()
{
    printf("pipe_stage_decode\n");
}
void pipe_stage_execute()
{
    printf("pipe_stage_execute\n");
}
void pipe_stage_mem()
{
    printf("pipe_stage_mem\n");
}
void pipe_stage_wb()
{
    printf("pipe_stage_wb\n");
}

