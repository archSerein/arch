/* ************************************************************************
> File Name:     primes.c
> Author:        serein
> mail:	   serein012039@gmail.com
> Created Time:  2023年11月20日 星期一 23时02分21秒
> Description:   
 ************************************************************************/

#include "kernel/types.h"
#include "user/user.h"


void get_primes(int pipes[2])
{
    int pipes2[2];
    int num;
    int tag = read(pipes[0], &num, 4);

    if (!tag)
    {
        close(pipes[0]);
        exit(0);
    }

    printf("prime %d\n", num);

    pipe(pipes2);

    int pid = fork();
    if (pid == 0)
    {
        close(pipes2[1]);
        close(pipes[0]);
        get_primes(pipes2);
    }
    else if (pid > 0)
    {
        int m;
        close(pipes2[0]);

        while (read(pipes[0], &m, 4))
        {
            if (m % num)
            {
                write(pipes2[1], &m, 4);
            }
        }

        close(pipes[0]);
        close(pipes2[1]);

        wait(0);
    }
    else
    {
        printf("fork error\n");
        exit(pid);
    }
}

int main(int argc, char **argv)
{
    int pipes[2];
    int i;

    pipe(pipes);
    for (i = 2; i <= 35; i++)
    {
        write(pipes[1], &i, 4);
    }

    close(pipes[1]);
    get_primes(pipes);
    exit(0);
}


