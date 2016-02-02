#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <mpi.h>

int main(int argc, char*argv[]) {
	MPI_Init(&argc, &argv);
	int my_rank;
	MPI_Comm_rank(MPI_COMM_WORLD, &my_rank);

	if (my_rank < 2) {
		int other_rank = 1 - my_rank;
		int tag = 0;
		char message[] = "Hello";
		MPI_Status status;

		char recv_buffer[100];

		if (my_rank == 0) {
			MPI_Ssend(message, strlen(message) + 1, MPI_CHAR, other_rank,
				 tag, MPI_COMM_WORLD);
			MPI_Recv(recv_buffer, 100, MPI_CHAR, other_rank,
				 tag, MPI_COMM_WORLD, &status);
		} else {
			MPI_Recv(recv_buffer, 100, MPI_CHAR, other_rank,
				 tag, MPI_COMM_WORLD, &status);
			MPI_Ssend(message, strlen(message) + 1, MPI_CHAR, other_rank,
				 tag, MPI_COMM_WORLD);
		}

		printf("%s\n", recv_buffer);
	}

	MPI_Finalize();
	return EXIT_SUCCESS;
}
