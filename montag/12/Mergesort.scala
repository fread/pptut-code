import scala.concurrent.forkjoin._;

object Mergesort {
  def main(args : Array[String]) = {
    val test = List(3,1,4,1,5,9,2)
    println(new MergeSort(test).invoke)
  }
}


class MergeSort(x : List[Int]) extends RecursiveTask[List[Int]] {

  def compute : List[Int] = {
    if (x.length == 1) {
      return x
    } else {
      val (left, right) = x.splitAt(x.length / 2)

      val leftSort = new MergeSort(left)
      val rightSort = new MergeSort(right)

      leftSort.fork()
      val rightResult = rightSort.invoke()

      return merge(leftSort.join(), rightResult)
    }
  }

  def merge(left : List[Int], right : List[Int]) : List[Int] = {
    // left match {
    //   case Nil => ...
    //   case l1 :: leftRest => ...
    // }

    if (left.length == 0 || right.length == 0) {
      return left ++ right
    } else {
      if (left(0) < right(0)) {
	return left(0) :: merge(left.tail, right)
      } else {
	return right(0) :: merge(left, right.tail)
      }
    }
  }
}
