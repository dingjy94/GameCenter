# GameCenter
##Introduction

The purpose of this project is mainly focused to help people find the best game that are suitable for themselves. It is hard to find a proper game for most of the users to match their hobbies and abilities when they are exposed to large amounts of games. So we are going to fulfill the game recommendation system to solve this problem in order that helping users spends less time while discovering a suitable and filtering the appropriate game among the games’ store.

Game recommendation system based on Steam Data

ALS Algorithm

```RecommenderBuilder.scala``` is the core program of the ALS model. It input the (userID, gameID, ratign) format data, train the ALS model and output the recommend results in (userID, game1, game2, game3, ..., game10) format. Also, it can evaluate the model with MSE.

Data preprocessing 

We use Steam Spy which is Steam stats service based on Web API to get data about each steam game.  User data are found on the internet. After preprocessing, there are about 1 million items, 100k users and 10k games in our databases.

Experimental Setting

We built our spark cluster on AWS to train model. More than 10G user data will transfer to cluster. 
Our AWS cluster include four m3.large ec2 instances, one as master node and other three as data nodes. DFS size is 88.57GB, each nodes’ capacity is 29.52GB, with 2 cores and memory size is 6.1 GB.
The operating system of our cluster is Amazon Linux AMI 2017.09.1 (HVM), Apach Hadoop version is 2.4 and Apache Spark version is 2.0.
For the data, we choose users whose id is smaller than 76561198000000000 and their game rating as our training dataset, and other users’ game rating as testing dataset.

Experimental Result

The purpose of our experiment is to repeatedly change the variables (rank, number of iterations, lamda, alpha) of our ALS mode, and find the best variables combo, which has the smallest MSE. This variables combo will be used to train the final ALS model, which provide the recommendation result to our system. ```recommendResult.csv```shows the result of our project.

