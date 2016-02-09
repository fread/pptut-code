import x10.io.Console;

class PiSequential {
  public static def main(args:Rail[String]) {
    val n:Int = Int.parse(args(0));
    val threads:Int = Int.parse(args(1));

    val h = 1.0 / n;
    var sum:Double = 0.0;

    finish for (t in 0..(threads-1)) async {
      var mySum:Double = 0.0;
      val start = (t * n / threads) + 1;
      val end = (t+1) * n / threads;

      for ([i] in start..end) {
	val x = h * (i - 0.5);
	mySum += (4.0 / (1.0 + x*x));
      }

      atomic sum += mySum;
    }

    val pi = h * sum;

    Console.OUT.println("The value of pi is " + pi);
  }
}
