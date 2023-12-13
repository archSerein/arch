/*
 * =====================================================================================
 *
 *       Filename:  sleep.c
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  2023年11月10日 16时58分48秒
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

int main(int argc, char** argv) {
    
    if(argc != 2) {
        printf("too few arguments\n");
    }
    
    if(argc > 2) {
        printf("too many arguments\n");
    }
    int time = atoi(argv[1]);
    
    sleep(time);
    exit(0);
}
