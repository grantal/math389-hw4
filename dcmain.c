#include <stdlib.h>
#include <stdio.h>
#define BIG_ENOUGH 100

// compile with:
// gcc -o dc dcmain.c lib.c my_dc.s dc_lib.s -g


void my_dc(long *calc_stack);


int main() {
    long *calc_stack = (long *)malloc(BIG_ENOUGH*sizeof(long)); 
    my_dc(calc_stack);
}
