#include <stdlib.h>
#include <stdio.h>
#define BIG_ENOUGH 100

// compile with:
// gcc -o test test_dc_lib.c lib.c dc_lib.s -g


void my_dc(long *calc_stack);


int main() {
    long a = -13;
    long b = 4;
    printf("%ld div %ld: %ld\n", a, b, (long)(divide(a,b)));
    printf("%ld div %ld: %ld\n", a, b, (long)(a / b));
    long *calc_stack = (long *)malloc(BIG_ENOUGH*sizeof(long)); 
    calc_stack[0] = 5l;
    calc_stack[1] = 7l;
    calc_stack[2] = 2l;
    printf("dcon: %ld%ld\n", calc_stack[1], calc_stack[0]);
    printf("dcon: %ld\n", (long)dcon(&calc_stack[2])); 
    calc_stack[0] = 6l;
    calc_stack[1] = 8l;
    calc_stack[2] = 4l;
    calc_stack[3] = 5l;
    calc_stack[4] = 4l;
    printf("dcon: %ld%ld%ld%ld\n", calc_stack[3], calc_stack[2], calc_stack[1], calc_stack[0]);
    printf("dcon: %ld\n", (long)dcon(&calc_stack[4])); 
    long x = 4l;
    long p = 3l;
    printf("%ld to the %ld: %ld\n", x, p, (long)(power(x,p)));
    x = 5l;
    p = 7l;
    printf("%ld to the %ld: %ld\n", x, p, (long)(power(x,p)));
}
