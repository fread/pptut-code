package barrier;

class Main {
	public static void main(String[] args) throws Exception {
		final Barrier b = new Barrier(4);

		Runnable r = new Runnable(){
				public void run() {
					System.out.println("Hallo");
					try {
						b.await();
					} catch (InterruptedException e) {

					}
					System.out.println("Fertig");
				}
			};

		for (int i = 0; i < 3; i++) {
			Thread t = new Thread(r);
			t.start();
		}

		Thread.sleep(1000);
		b.freeAll();
	}
}
