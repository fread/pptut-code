import scala.actors.Actor;
import java.util.concurrent._;

class ComputeActor(func : Double => Double) extends Actor {
  def act = {
    Actor.loop {
      Actor.receive {
	case "exit" => {
	  exit()
	}
	case (d : Double) => {
	  val result = func(d)
	  sender ! result
	}
      }
    }
  }
}

class SumActor extends Actor {
  var totalSum = 0.0
  var totalElements = 0

  def act = {
    Actor.loop {
      Actor.receive {
	case (xs : Array[Double]) => {
	  totalElements = xs.length

	  for (d <- xs) {
	    val ca = new ComputeActor(math.sqrt)
	    ca.start()
	    ca ! d
	  }
	}
	case (result : Double) => {
	  totalSum += result
	  totalElements -= 1
	  sender ! "exit"
	  if (totalElements == 0) {
	    println(totalSum)
	    this ! "exit"
	  }
	}
	case "exit" => {
	  exit
	}
      }
    }
  }
}

object ActorTest {
  def main(args : Array[String]) = {
    val sumActor = new SumActor()
    val test = Array[Double](2.0, 4.0, 9.0)

    sumActor.start()
    sumActor ! test
  }
}
