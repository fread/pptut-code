package barrier;

class Barrier implements IBarrier {
	private final int threads;

	private int waiting = 0;

	private boolean emptying = false;

	public Barrier(int threads) {
		this.threads = threads;
	}

	public synchronized void await() throws InterruptedException {
		while (emptying) {
			wait();
		}

		waiting++;

		if (waiting >= threads) {
			notifyAll();
			emptying = true;
		} else {
			while (!emptying) {
				wait();
			}
			waiting--;

			if (waiting <= 0) {
				emptying = false;
				notifyAll();
			}
		}
	}

	public synchronized void freeAll() {
		emptying = true;
		notifyAll();
	}
}
