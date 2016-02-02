#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "mpi.h"

/* int MPI_Send(const void *buf, int count, MPI_Datatype datatype, int dest, */
/* 	     int tag, MPI_Comm comm); */
/* int MPI_Recv(void *buf, int count, MPI_Datatype datatype, */
/*             int source, int tag, MPI_Comm comm, MPI_Status *status) */


void my_int_sum_reduce(int *sendbuf, int *recvbuf, int count,
		       int root, MPI_Comm comm)
{
	int size, rank;
	MPI_Comm_size(MPI_COMM_WORLD, &size);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);

	if (rank == root) {
		memcpy(recvbuf, sendbuf, count * sizeof(int));
		int temp[count];

		for (int i = 0; i < size; i++) {
			if (i == root) continue;

			MPI_Recv(temp, count, MPI_INT, i, 0, comm, MPI_STATUS_IGNORE);

			for (int j = 0; j < count; j++) {
				recvbuf[j] += temp[j];
			}
		}
	} else {
		MPI_Send(sendbuf, count, MPI_INT, root, 0, comm);
	}
}

int main(int argc, char*argv[]) {
	MPI_Init(&argc, &argv);

	int size, rank;
	MPI_Comm_size(MPI_COMM_WORLD, &size);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	int sendbuffer[4];
	int recvbuffer[4];
	for (int i = 0; i < 4; i++) {
		sendbuffer[i] = 100 + (10 * rank) + i;
	}

       /* int MPI_Reduce(const void *sendbuf, void *recvbuf, int count, */
       /* 		      MPI_Datatype datatype, MPI_Op op, int root, */
       /*                MPI_Comm comm) */
	my_int_sum_reduce(sendbuffer, recvbuffer, 4, 0, MPI_COMM_WORLD);

	if (rank == 0) {
		for (int i = 0; i < 4; i++) {
			printf("%d ", recvbuffer[i]);
		}
		printf("\n");
	}

	MPI_Finalize();

	return EXIT_SUCCESS;
}
