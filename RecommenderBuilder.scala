package GameCenter

/**
  * Created by dingjy on 2017/11/21.
  */
import org.apache.spark.SparkConf
import org.apache.spark.SparkContext
import org.apache.spark.SparkContext._
import org.apache.spark.mllib.recommendation.MatrixFactorizationModel
import org.apache.spark.mllib.recommendation._
import org.apache.spark.internal.Logging
import org.apache.spark.rdd.RDD
import org.apache.spark.storage.StorageLevel
case class GameRating(userID: Int, gameID: Int, rating: Double) extends scala.Serializable
object RecommenderBuilder {

  def main(args: Array[String]): Unit = {
    val sc = new SparkContext(new SparkConf().setAppName("GameRecommender"))


    //get RDD
    val rawUserGameData = sc.textFile("/train/train.csv")

  //  model(sc, rawUserGameData)
    recommend(sc, rawUserGameData)
  }

  def buildRatings(rawUserGameData: RDD[String]): RDD[GameRating] = {
    rawUserGameData.map { line =>
      val Array(userID, gameID, rateS) = line.split(',').map(_.trim)
      var rate = rateS.toDouble
      var userIDS = userID.toLong - 76561197000000000L
      GameRating(userIDS.toInt, gameID.toInt, rate)
    }
  }
  def model(sc: SparkContext,
            rawUserGameData: RDD[String]): Unit = {
    val data = buildRatings(rawUserGameData)
    val ratings: RDD[Rating] = data.map { r=>
      Rating(r.userID, r.gameID, r.rating)
    }.cache()
    val model = ALS.train(ratings, 50, 10, 0.0001)
    ratings.unpersist()
    println("print first userFeature")
    println(model.userFeatures.mapValues(_.mkString(",")).first())

    for (userID <- Array(960267728, 960268176)) {
      checkRecommedResult(userID, rawUserGameData, model)
    }
    unpersist(model)

  }
  def model(sc: SparkContext,
            rawUserGameData: RDD[String]): Unit = {
    val data = buildRatings(rawUserGameData)
    val ratings: RDD[Rating] = data.map { r=>
      Rating(r.userID, r.gameID, r.rating)
    }.cache()
    val model = ALS.train(ratings, 50, 10, 0.0001)
    ratings.unpersist()
    println("print first userFeature")
    println(model.userFeatures.mapValues(_.mkString(",")).first())

    for (userID <- Array(960267728, 960268176)) {
      checkRecommedResult(userID, rawUserGameData, model)
    }
    unpersist(model)

  }

  def checkRecommedResult(userID: Int, rawUserGameData: RDD[String], model: MatrixFactorizationModel): Unit = {
    val recommendations = model.recommendProducts(userID, 5)
    val recommendGameIDs = recommendations.map(_.product).toSet
    val rawGamesUser = rawUserGameData.map(_.split(',')).
      filter {case Array(id, _, _) => id.trim.toLong == (userID.toLong + 76561197000000000L)}
    val GameIDsInt = rawGamesUser.map {case Array(_, gameID, _) => gameID.toInt}.collect().toSet
    println("user: " + userID + "rated game: ")
    GameIDsInt.foreach(println)
    println("user:" + userID + "recommend game: ")
    recommendGameIDs.foreach(println)
  }
  def recommend(sc: SparkContext,
                rawUserGameData: RDD[String]): Unit = {
    val data = buildRatings(rawUserGameData)
    val ratings: RDD[Rating] = data.map { r=>
      Rating(r.userID, r.gameID, r.rating)
    }.cache()
    val model = ALS.train(ratings, 50, 10, 0.0001)
    ratings.unpersist()
    //train ALS model
    val allResult = model.recommendProductsForUsers(5) map {
      case (userID, recommendations) => {
        var games = ""
        for (r <- recommendations) {
          games += r.product + ","
        }
        if (games.endsWith(","))
          games = games.substring(0, games.length-1)
        println(userID)
        (userID, games)
      }
    }
    allResult.saveAsTextFile("/recommend")
    unpersist(model)
  }
  def unpersist(model: MatrixFactorizationModel): Unit = {
    // At the moment, it's necessary to manually unpersist the RDDs inside the model
    // when done with it in order to make sure they are promptly uncached
    model.userFeatures.unpersist()
    model.productFeatures.unpersist()
  }
}
