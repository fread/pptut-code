package vacation;

/* From Java 1.8 onwards, this is part of the API (however, the index is zero-based). It is supplied here only to ensure backwards compatibility. */
public enum Month {

	JANUARY(0),
	FEBRUARY(1),
	MARCH(2),
	APRIL(3),
	MAY(4),
	JUNE(5),
	JULY(6),
	AUGUST(7),
	SEPTEMBER(8),
	OCTOBER(9),
	NOVEMBER(10),
	DECEMBER(11);
	private int value;

	private Month(int i) {
		value = i;
	}

	public int getValue() {
		return value;
	}
}
