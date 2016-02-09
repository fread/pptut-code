object Hunger {
  val essen = "Bananen" :: "Brot" :: "Saumagen" :: Nil

  def main(args : Array[String]) = {
    for (e <- essen) {
      println("Bitte " + e + " kaufen")
    }

    for (i <- 0 until essen.length) {
      println("Bitte " + essen(i) + " kaufen")
    }

    essen.foreach(e => println("Bitte " + e + " kaufen"))
  }
}
