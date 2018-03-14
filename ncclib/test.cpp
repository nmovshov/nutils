#include "ncclib.h"
int main()
{
    ncc::whoami();
    printf("working in %s\n",_getcwd(NULL,0));
    return 0;
}
