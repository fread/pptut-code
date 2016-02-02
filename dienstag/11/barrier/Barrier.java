package barrier;

public class Barrier implements IBarrier {
	int threads;
	int threadsWaiting = 0;

	public Barrier(int threads) {
		this.threads = threads;
	}

	public synchronized void await() throws InterruptedException {
		while (threadsWaiting < 0) {
			wait();
		}

		threadsWaiting++;

		if (threadsWaiting < threads) {
			while (threadsWaiting > 0) {
				wait();
			}
			threadsWaiting++;
			notifyAll();
		} else {
			freeAll();
			threadsWaiting++;
		}
	}

	public void freeAll() {
		threadsWaiting = -threads;
		notifyAll();
	}
}
