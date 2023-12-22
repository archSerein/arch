/*
 * =====================================================================================
 *
 *       Filename:  pingpong.c
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  2023年11月18日 09时10分08秒
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  YOUR NAME (), 
 *   Organization:  
 *
 * =====================================================================================
 */

#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main() {
    int pipe_id[2];
    int child_pid;

    if(pipe(pipe_id) == -1) {
        printf("alloc pipe error!");
    }

    if((child_pid = fork()) == -1) {
        printf("fork error!");
    }
    if(child_pid == 0){
        close(pipe_id[1]);

        char buffer[100];
        
        int read_buffer_size = read(pipe_id[0], buffer, sizeof(buffer));

        if(read_buffer_size == -1) {
            printf("read from pipe error!");
        }
        
        buffer[strlen(buffer) + 1] = '\0';

        printf("%d: received %s\n", getpid(),  buffer);

        close(pipe_id[0]);
    
        exit(0);
    }
    else {
        close(pipe_id[0]);

        char buffer[100] = "ping\0";
    
        int write_len =  write(pipe_id[1], buffer, strlen(buffer));
    
        if(write_len <= 0) {
            printf("write error");
        }
        
        wait(0);

        printf("%d: received pong\n", getpid());

        close(pipe_id[1]);
        
        exit(0);
    }
}
