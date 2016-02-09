import scala.actors.Actor

class ComputeActor(func : Double => Double) extends Actor {
  def act = {
    Actor.loop {
      Actor.receive {
	case x : Double => {
	  val result = func(x)
	  sender ! result
	}
	case "exit" => {
	  exit()
	}
      }
    }
  }
}

class SumActor extends Actor {
  var sum = 0.0
  var actors = new Array[Actor](0)
  var resultsReceived = 0

  def act = {
    Actor.loop {
      Actor.receive {
	case values : Array[Double] => {
	  actors = new Array[Actor](values.length)

	  for (i <- 0 until values.length) {
	    val ca = new ComputeActor(math.sqrt)
	    actors(i) = ca
	    ca.start()
	    ca ! values(i)
	  }
	}
	case result : Double => {
	  sum += result
	  resultsReceived = resultsReceived + 1

	  if (resultsReceived == actors.length) {
	    println(sum)
	    this ! "exit"
	  }
	}
	case "exit" => {
	  for (a <- actors) {
	    a ! "exit"
	  }
	  exit()
	}
      }
    }
  }
}

object Test {
  def main(args : Array[String]) = {
    val values = Array(1.0, 4.0, 9.0)
    val sa = new SumActor()
    sa.start()
    sa ! values
  }
}
