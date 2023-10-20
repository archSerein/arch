#include "date.h"
#include "types.h"
#include "user.h"

int main(int argc, char* argv[])
{
    struct rtcdate r;
    if(date(&r))
    {
        printf(2,"date failed\n");
        exit();
    }
    printf(2,"%d-%d-%d %d : %d : %d\n",r.year,r.month,r.day,r.hour,r.minute,r.second);

    exit();
}