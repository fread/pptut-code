import scala.concurrent.forkjoin._

object Mergesort {
  def main(args : Array[String]) = {
    val test = List[Int](3,1,4,1,5,9,2)
    val s = new Sorter(test)
    println(s.invoke())
  }
}

class Sorter(list : List[Int]) extends RecursiveTask[List[Int]] {

  def compute() : List[Int] = {
    if (list.length <= 1) {
      return list
    } else {
      val (left, right) = list.splitAt(list.length / 2)

      val sorterLeft = new Sorter(left)
      val sorterRight = new Sorter(right)

      sorterLeft.fork()
      val rightSorted = sorterRight.invoke()
      val leftSorted = sorterLeft.join()

      return merge(leftSorted, rightSorted)
    }
  }

  def merge(a : List[Int], b : List[Int]) : List[Int] = {
    (a, b) match {
      case (Nil, b) => b
      case (a, Nil) => a
      case (a1::arest, b1::brest) =>
	if (a1 < b1) {
	  a1::merge(arest, b)
	} else {
	  b1::merge(a, brest)
	}
    }
  }
}
