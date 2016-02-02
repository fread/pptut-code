package vacation;

import java.util.HashMap;
import java.util.Map;

public class VacationReservationSystem {

	private final Map<String, EmployeeVacationRecord> records = new HashMap<String, EmployeeVacationRecord>();

	public boolean tryTakeVacation(String name, Month month)
		throws VacationSystemException, InterruptedException {

		EmployeeVacationRecord employee = records.get(name);
		if (employee == null)
			throw new VacationSystemException("Employee " + name + " not found.");
		EmployeeVacationRecord buddy = employee.getBuddy();
		if (buddy == null)
			return false; // no buddy assigned => vacation not permitted

		EmployeeVacationRecord first;
		EmployeeVacationRecord second;

		if (employee.getName().compareTo(buddy.getName()) < 0) {
			first = employee;
			second = buddy;
		} else {
			first = buddy;
			second = employee;
		}

		synchronized(first) {
			synchronized(second) {
				if (buddy.isOnVacation(month)) {
					return false;
				} else {
					employee.setVacationState(month, true);
					return true;
				}
			}
		}
	}

	public void createVacationRecords(String name, String buddyName) throws VacationSystemException {
		// In this simple example, we assume employee names are unique.
		if (name.equals(buddyName) || records.get(name) != null || records.get(buddyName) != null) {
			throw new VacationSystemException("Names have to be unique.");
		}

		EmployeeVacationRecord employee = new EmployeeVacationRecord(name);
		EmployeeVacationRecord buddy = new EmployeeVacationRecord(buddyName, employee);
		records.put(name, employee);
		records.put(buddyName, buddy);
	}

	public synchronized void printVacationsForMonth(Month month) {
		System.out.println("Vacations for " + month.toString());
		for (String name : records.keySet()) {
			EmployeeVacationRecord employee = records.get(name);
			String vacString = employee.isOnVacation(month) ? "on vacation" : "working";
			System.out.println(name + " is " + vacString);
		}
		System.out.println("###################################################");
	}

	public synchronized void resetAllVacations() {
		for (String name : records.keySet()) {
			EmployeeVacationRecord employee = records.get(name);
			employee.resetAllVacations();
		}
	}

	public synchronized boolean[] getVacationsForMonth(Month month) {
		boolean[] vacations = new boolean[records.size()];

		int i = 0;
		for (EmployeeVacationRecord vacRecord : records.values()) {
			vacations[i] = vacRecord.isOnVacation(month);
			i++;
		}
		return vacations;
	}
}
