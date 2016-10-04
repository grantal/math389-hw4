#include <stdio.h>

long mul(long n, long m) {
    return n*m;
}

long input_char() {
    char c;
    scanf("%c",&c);
    return (long)c;
}

void output_long(long v) {
    printf("%ld\n", v);
}
