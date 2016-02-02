package primes;

import java.util.*;
import java.util.concurrent.*;

/*

interface Callable<T> {
	public T call();
}

interface FutureTask<T> {
	public T get();
}

 */

public class DivisionSeq {
	public static boolean isPrime(int n) {
		if (n < 2) return false;
		for (int i = 2; i <= Math.sqrt(n); ++i) {
			if (n % i == 0) return false;
		}
		return true;
	}

	private static int primesParallel(int target, int threads, int blocks) throws Throwable {
		int globalCount = 0;
		ExecutorService threadPool = Executors.newFixedThreadPool(threads);
		List<Future<Integer>> futures = new ArrayList<>();

		for (int i = 0; i < blocks; i++) {
			final int start = i * target / blocks;
			final int end   = (i+1) * target / blocks;

			Callable<Integer> callable = new Callable<Integer>(){
					public Integer call() {
						int count = 0;

						for (int i = start; i < end; i++) {
							if (isPrime(i))
								count++;
						}

						return count;
					}
				};
			futures.add(threadPool.submit(callable));
		}

		for (Future<Integer> f : futures) {
			globalCount += f.get();
		}

		threadPool.shutdown();
		return globalCount;
	}

	public static void main(String[] args) throws Throwable {
		final int target = 10000000;
		int count = 0;

		final long startTime = System.currentTimeMillis();
		count = primesParallel(target, 4, 20);
		final long endTime = System.currentTimeMillis();
		System.out.println("Duration for interval [2, " + target + "] is "
				   + (endTime - startTime) + " ms\n" + count + " primes");
	}
}
