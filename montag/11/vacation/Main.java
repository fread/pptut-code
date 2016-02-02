package vacation;

import java.util.concurrent.BrokenBarrierException;
import java.util.concurrent.CyclicBarrier;

public class Main {

	public static void main(String[] args) throws Exception {

		VacationReservationSystem vacSystem = new VacationReservationSystem();

		// register employees
		vacSystem.createVacationRecords("Manuel", "Martin");
		vacSystem.createVacationRecords("Erik", "Misha");

		CyclicBarrier barrier = new CyclicBarrier(5);

		// create thread for employees
		EmployeeThread[] threads = new EmployeeThread[4];
		threads[0] = new EmployeeThread("Manuel", vacSystem, barrier);
		threads[1] = new EmployeeThread("Martin", vacSystem, barrier);
		threads[2] = new EmployeeThread("Erik", vacSystem, barrier);
		threads[3] = new EmployeeThread("Misha", vacSystem, barrier);

		// start threads
		for (int i = 0; i < threads.length; i++) {
			threads[i].start();
		}

		// ENTER DESIRED AMOUNT OF RUNS
		int totalRuns = 100000;

		// perform test runs
		int correctRuns = 0;
		for (int i = 0; i < totalRuns; i++) {

			if (i % 10 == 0) System.out.print(i + "\r");

			vacSystem.resetAllVacations();
			barrier.await();
			// here, employees make their reservations
			barrier.await();

			// check the state: two employees should have successfully reserved their vacation, while their buddies are blocked
			if (validateVacations(vacSystem, 2, 2))
				correctRuns++;
		}

		// report result
		if (correctRuns < totalRuns)
			System.out.println("There were problems in " + (totalRuns - correctRuns) + " of " + totalRuns + " runs.");
		else
			System.out.println("All " + totalRuns + " runs completed correctly.");

		// were done here, interrupt threads
		for (int i = 0; i < threads.length; i++) {
			threads[i].interrupt();
		}

		// wait for proper shutdown of threads
		for (int i = 0; i < threads.length; i++) {
			threads[i].join();
		}
	}

	private static boolean validateVacations(VacationReservationSystem vacSystem, int expectedWorking, int expectedVacation) {
		boolean[] vacations = vacSystem.getVacationsForMonth(Month.APRIL);
		int working = 0;
		int vacation = 0;
		for (boolean onVacation : vacations) {
			if (onVacation)
				vacation++;
			else
				working++;
		}

		if (expectedWorking != working || expectedVacation != vacation) {
			System.out.println("Unexpected state of vacation reservations!");
			vacSystem.printVacationsForMonth(Month.APRIL);
			return false;
		}
		return true;
	}

	private static class EmployeeThread extends Thread {

		private String name;
		private VacationReservationSystem vacSystem;
		private CyclicBarrier barrier;

		public EmployeeThread(String name, VacationReservationSystem vacSystem, CyclicBarrier barrier) {
			this.name = name;
			this.vacSystem = vacSystem;
			this.barrier = barrier;
		}

		@Override
		public void run() {
			while (!isInterrupted()) {
				try {
					barrier.await();
					vacSystem.tryTakeVacation(name, Month.APRIL);
					barrier.await();
				} catch (VacationSystemException e) {
					System.out.println("Thread for " + name + " faild due to unexpected exception!");
					e.printStackTrace();
					interrupt();
				} catch (InterruptedException | BrokenBarrierException e) {
					/*
					 * Thread was interrupted or the barrier broke (because another thread waiting for the barrier was
					 * interrupted). In both cases it is safe for us to gracefully quit.
					 */
					interrupt();
				}
			}
		}
	}
}
