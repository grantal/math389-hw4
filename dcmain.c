#include <stdlib.h>
#include <stdio.h>
#define BIG_ENOUGH 100

void my_dc(long *calc_stack);


int main() {
    long a = -8;
    long b = 2;
    printf("%ld div %ld: %ld\n", a, b, (long)(divide(a,b)));
    printf("%ld div %ld: %ld\n", a, b, (long)(a / b));
    long *calc_stack = (long *)malloc(BIG_ENOUGH*sizeof(long)); 
    my_dc(calc_stack);
}
