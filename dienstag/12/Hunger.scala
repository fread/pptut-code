// Alle Termine 14:00

// Andreas: AVG -133
// Michael: AVG -134
// Jonas: Infobau -120
// Lucas: Infobau 301

object Hunger {
  val essen = "Bananen" :: "Brot" :: "Saumagen" :: Nil

  def main(args : Array[String]) = {
    for (i <- 0 until essen.length) {
      println("Bitte " + essen(i) + " kaufen!")
    }

    essen.foreach(e => println("Bitte " + e + " kaufen!"))
  }

  def add(x : Int, y : Int) = {
    x + y
  }
}
