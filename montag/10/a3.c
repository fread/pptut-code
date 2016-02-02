#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <mpi.h>

/* #include <mpi.h> */
/* int MPI_Send(const void *buf, int count, MPI_Datatype datatype, int dest, */
/* 	     int tag, MPI_Comm comm) */

/* int MPI_Recv(void *buf, int count, MPI_Datatype datatype, */
/* 	     int source, int tag, MPI_Comm comm, MPI_Status *status) */

void my_int_sum_reduce(int *sendbuffer, int *recvbuffer, int count,
			   int root, MPI_Comm comm)
{
	int size, rank;
	MPI_Comm_size(comm, &size);
	MPI_Comm_rank(comm, &rank);

	if (rank == root) {
		for (int i = 0; i < size; i++) {
			if (i == root) continue;

			MPI_Recv(recvbuffer, count, MPI_INT,
				 i, 0, comm, MPI_STATUS_IGNORE);

			for (int j = 0; j < count; j++) {
				sendbuffer[j] += recvbuffer[j];
			}
		}

		memcpy(recvbuffer, sendbuffer, count * sizeof(int));
	} else {
		MPI_Send(sendbuffer, count, MPI_INT, root, 0, comm);
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
		sendbuffer[i] = rank + (10*i);
	}

	my_int_sum_reduce(sendbuffer, recvbuffer, 4,
		   0, MPI_COMM_WORLD);

	if (rank == 0) {
		for (int i = 0; i < 4; i++) {
			printf("%d ", recvbuffer[i]);
		}
		printf("\n");
	}

	MPI_Finalize();

	return EXIT_SUCCESS;
}
