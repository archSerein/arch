/* ************************************************************************
> File Name:     xargs.c
> Author:        serein
> mail:	   serein012039@gmail.com
> Created Time:  2023年11月23日 星期四 15时49分50秒
> Description:   
 ************************************************************************/

#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/param.h"

int main(int argc, char** argv)
{
    char *p[MAXARG];

    int i;

    for(i = 1; i < argc; i++)
    {
        p[i-1] = argv[i];
    }

    p[argc - 1] = malloc(512);
    p[argc] = 0;

    while(gets(p[argc-1], 512) != 0)
    {
        if(p[argc - 1][strlen(p[argc - 1])-1] == '\n')
            p[argc - 1][strlen(p[argc - 1])-1] = '\0';
        if(fork() == 0)
        {
            exec(argv[1], p);
        }

        else {
            wait(0);
        }
    }
    exit(0);
}
