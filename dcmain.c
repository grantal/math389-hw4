#include <stdlib.h>
#include <stdio.h>
#define BIG_ENOUGH 100

// compile with:
// gcc -o dc dcmain.c lib.c my_dc.s -g


void my_dc(long *calc_stack);


int main() {
    /*
    long a = -8;
    long b = 2;
    printf("%ld div %ld: %ld\n", a, b, (long)(divide(a,b)));
    printf("%ld div %ld: %ld\n", a, b, (long)(a / b));
    */
    long x = 4l;
    long p = 2l;
    printf("%ld to the %ld: %ld\n", x, p, (long)(pow(a,b)));
    long *calc_stack = (long *)malloc(BIG_ENOUGH*sizeof(long)); 
    /*
    calc_stack[0] = 2l;
    calc_stack[1] = 3l;
    calc_stack[2] = 5l;
    int i;
    printf("%ld, %ld\n", calc_stack[1], calc_stack[0]);
    printf("sum: %ld\n", dcon(&calc_stack[2])); 
    */
    my_dc(calc_stack);
}
