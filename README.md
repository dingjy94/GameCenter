# GameCenter
Game recommendation system based on Steam Data

ALS Algorithm

```RecommenderBuilder.scala``` is the core program of the ALS model. It input the (userID, gameID, ratign) format data, train the ALS model and output the recommend results in (userID, game1, game2, game3, ..., game10) format. Also, it can evaluate the model with MSE.

Experimental Setting

We built our spark cluster on AWS to train model. More than 10G user data will transfer to cluster. 
Our AWS cluster include four m3.large ec2 instances, one as master node and other three as data nodes. DFS size is 88.57GB, each nodes’ capacity is 29.52GB, with 2 cores and memory size is 6.1 GB.
The operating system of our cluster is Amazon Linux AMI 2017.09.1 (HVM), Apach Hadoop version is 2.4 and Apache Spark version is 2.0.
For the data, we choose users whose id is smaller than 76561198000000000 and their game rating as our training dataset, and other users’ game rating as testing dataset.
