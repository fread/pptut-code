package vacation;

public class EmployeeVacationRecord {

	private final String name;
	private final boolean[] vacations;
	private EmployeeVacationRecord buddy;

	public EmployeeVacationRecord(String name) {
		this.name = name;
		vacations = new boolean[12];
	}

	/**
	 * This constructor mutually sets the buddy relation.
	 */
	public EmployeeVacationRecord(String name, EmployeeVacationRecord buddy) {
		this(name);
		this.buddy = buddy;
		buddy.buddy = this;
	}

	public String getName() {
		return name;
	}

	public EmployeeVacationRecord getBuddy() {
		return buddy;
	}

	public boolean isOnVacation(Month month) {
		return vacations[month.getValue()];
	}

	public void setVacationState(Month month, boolean onVacation) {
		vacations[month.getValue()] = onVacation;
	}

	public void resetAllVacations() {
		for (int i = 0; i < 12; i++) {
			vacations[i] = false;
		}
	}
}
