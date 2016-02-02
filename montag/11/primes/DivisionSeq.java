package primes;

import java.util.*;
import java.util.concurrent.*;

public class DivisionSeq {
	public static boolean isPrime(int n) {
		if (n < 2) return false;

		for (int i = 2; i <= Math.sqrt(n); ++i) {
			if (n % i == 0) return false;
		}

		return true;
	}

	public static int countPrimesParallel(int threads, int target) throws Exception {
		int globalCount = 0;
		ExecutorService pool = Executors.newFixedThreadPool(threads);
		List<FutureTask<Integer>> futures = new ArrayList<>();

		for (int t = 0; t < threads; t++) {
			final int start = t * target / threads;
			final int end   = (t+1) * target / threads;
			Callable<Integer> callable = new Callable<Integer>(){
					public Integer call() {
						int count = 0;
						for (int i = start; i < end; ++i) {
							if (isPrime(i)) ++count;
						}
						return count;
					}
				};
			FutureTask<Integer> task = new FutureTask<>(callable);
			futures.add(task);
			pool.submit(task);
		}

		for (FutureTask<Integer> ft : futures) {
			globalCount += ft.get();
		}

		pool.shutdown();
		return globalCount;
	}

	public static void main(String[] args) throws Exception {
		final int target = 50000000;
		int count = 0;

		for (int threads = 1; threads < 10; threads++) {

			final long startTime = System.currentTimeMillis();

			count = countPrimesParallel(threads, target);

			final long endTime = System.currentTimeMillis();

			System.out.println("Duration for interval [2, " + target + "] is "
					   + (endTime - startTime) + " ms\n" + count + " primes");
		}
	}
}
