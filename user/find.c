/* ************************************************************************
> File Name:     find.c
> Author:        serein
> mail:	   serein012039@gmail.com
> Created Time:  2023年11月22日 星期三 21时40分22秒
> Description:   
 ************************************************************************/

#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"
#include "kernel/fcntl.h"

char* fmtname(char* path)
{
    char *p;

    for(p = path + strlen(path); p >= path && *p != '/'; p--)
        ;
    p++;
    return p;
}

void find(char* path, char* file)
{
    char buf[512];
    char *p;
    int fd;
    struct dirent de;
    struct stat st;

    if((fd = open(path, O_RDONLY)) < 0)
    {
        fprintf(2, "find: path can't open %s\n", path);
        return;
    }

    if(fstat(fd, &st) < 0)
    {
        close(fd);
        fprintf(2, "find: can not stat %s\n", path);
        return;
    }

    switch(st.type)
    {
        case T_DEVICE:
        case T_FILE:
            if(strcmp(fmtname(path), file) == 0)
                {
                    printf("%s\n", path);
                }
            break;
        case T_DIR:
          
           if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf)
           {
                printf("path is too long\n");
                break;
           }

            strcpy(buf, path);
            p = buf + strlen(buf);
            *p++ = '/';

            while(read(fd, &de, sizeof(de)) == sizeof(de))
            {
                if(de.inum == 0)
                    continue;

                memmove(p, de.name, DIRSIZ);
                p[DIRSIZ] = 0;

                if(stat(buf, &st) < 0)
                {
                    close(fd);
                    printf("find: can not stat %s\n", buf);
                    continue;
                }
                
                else if(st.type == T_DEVICE || st.type == T_FILE)
                {
                    if(strcmp(fmtname(buf), file) == 0)
                    {
                        printf("%s\n", buf);
                    }
                }

                else if(st.type == T_DIR && strcmp(".", fmtname(buf)) && strcmp("..", fmtname(buf)))
                    find(buf, file);
            }
            break;
    }

    close(fd);
}

int main(int argc, char** argv)
{
    if(argc != 3)
    {
        printf("too few or too much parameters\n");
        exit(0);
    }

    find(argv[1], argv[2]);

    exit(0);
}
