#include <stdio.h>

int global[] = {1, 2, 3, 4, 5};

int *magic(int x[], int y) {
	printf("m");
	global[1] = *(global + y) + 3;
	return &x[y - 2];
}

int main() {
	printf("%i\n", *magic(&global[1],*(global + 1)));
	return 0;
}
