#include <stdlib.h>
#include <stdio.h>
#define BIG_ENOUGH 100

void my_dc(long *calc_stack);


int main() {
    /*
    long a = -79;
    long b = 8;
    printf("%ld mod %ld: %ld\n", a, b, (long)mod(a,b));
    printf("%ld mod %ld: %ld\n", a, b, (long)(a % b));
    */
    long *calc_stack = (long *)malloc(BIG_ENOUGH*sizeof(long)); 
    my_dc(calc_stack);
}
