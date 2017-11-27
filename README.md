# GameCenter
Game recommendation system based on Steam Data

ALS Algorithm

```RecommenderBuilder.scala``` is the core program of the ALS model. It input the (userID, gameID, ratign) format data, train the ALS model and output the recommend results in (userID, game1, game2, game3, ..., game10) format. Also, it can evaluate the model with MSE.
