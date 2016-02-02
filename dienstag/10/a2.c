#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "mpi.h"

int main(int argc, char*argv[]) {
	MPI_Init(&argc, &argv);
	int my_rank;
	MPI_Comm_rank(MPI_COMM_WORLD, &my_rank);

	if (my_rank < 2) {
		int other_rank = 1 - my_rank;
		int tag= 0;
		// char message[]= "Hello";
		char message[8192];
		strcpy(message, "Hello");
		MPI_Status status;

		char receive_buffer[8192];

/* int MPI_Sendrecv(const void *sendbuf, int sendcount, MPI_Datatype sendtype, */
/* 		 int dest, int sendtag, void *recvbuf, int recvcount, */
/* 		 MPI_Datatype recvtype, int source, int recvtag, */
/* 		 MPI_Comm comm, MPI_Status *status) */
		MPI_Sendrecv(message, 8192, MPI_CHAR,
			     other_rank, tag, receive_buffer, 8192,
			     MPI_CHAR, other_rank, tag,
			     MPI_COMM_WORLD, &status);

		printf("%s\n", receive_buffer);
	}

	MPI_Finalize();
	return EXIT_SUCCESS;
}
