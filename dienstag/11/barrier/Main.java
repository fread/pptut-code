package barrier;

public class Main {
	public static void main(String[] args) {
		final IBarrier b = new Barrier(4);

		for (int i = 0; i < 4; i++) {
			Thread t = new Thread(new Runnable() {
					public void run() {
						System.out.println("vor Barriere (1)");
						try {
							b.await();
						} catch (InterruptedException e) {
							System.out.println("Interrupted!");
						}
						System.out.println("nach Barriere (1)");
					}
				});
			t.start();
		}

		for (int i = 0; i < 4; i++) {
			Thread t = new Thread(new Runnable() {
					public void run() {
						System.out.println("vor Barriere (2)");
						try {
							b.await();
						} catch (InterruptedException e) {
							System.out.println("Interrupted!");
						}
						System.out.println("nach Barriere (2)");
					}
				});
			t.start();
		}
	}
}
