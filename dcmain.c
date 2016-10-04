#include <stdlib.h>
#include <stdio.h>
#define BIG_ENOUGH 100

void my_dc(long *calc_stack);

int main() {
    long *calc_stack = (long *)malloc(BIG_ENOUGH*sizeof(long)); 
    //printf("calc stack address: %ld", (long)calc_stack);
    my_dc(calc_stack);
}
