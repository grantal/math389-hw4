#define BIG_ENOUGH 100

void my_dc(long *calc_stack);

int main() {
    my_dc((long *)malloc(BIG_ENOUGH*sizeof(long)));
}
