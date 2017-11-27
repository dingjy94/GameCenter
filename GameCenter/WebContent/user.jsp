<%@ page language="java"  contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*,java.sql.*,java.io.*" %>
<%

	int[] appid = (int[]) request.getAttribute("appid");
	String[] name = (String[]) request.getAttribute("name");
	int[] score_rank = (int[]) request.getAttribute("score_rank");
	float[] price = (float[]) request.getAttribute("price");
	String[] tags = (String[]) request.getAttribute("tags");
	
	int showgame = 4;
	if(appid == null) appid = new int[showgame];
	if(name == null) name = new String[showgame];
	if(score_rank == null) score_rank = new int[showgame];
	if(price == null) price = new float[showgame];
	if(tags == null) tags = new String[showgame];
	
	String steamid = request.getParameter("steamid");
		//(long) request.getAttribute("user");
	
%> 

<!DOCTYPE html>
<html lang="en">

  <head>
  
 <script LANGUAGE="JavaScript">
  	
  	function getGame() {
  		console.log("getGame run")
  		var xmlhttp = new XMLHttpRequest();
  		var steamid = document.getElementById("user").getAttribute("steamid");
		xmlhttp.open("GET", "http://localhost:8080/GameCenter/getGame?steamid="+steamid, true);
		xmlhttp.send(null);
		
		xmlhttp.onreadystatechange = function()
		{
			if(xmlhttp.readyState==4 && xmlhttp.status==200) {
				
				var str = xmlhttp.responseText;
				var unit = str.split("\n");
				for(i = 0; i != 4; ++i) {
					var res = unit[i].split("\t");
					var game = document.getElementById("game"+i);
					game.setAttribute("appid", res[0]);
					var image = document.getElementById("image"+i);
					image.setAttribute("src", "http://cdn.akamai.steamstatic.com/steam/apps/" + res[0] + "/header.jpg");
					image.setAttribute("onclick", "location.href = 'http://store.steampowered.com/app/"+res[0] + "'");
					document.getElementById("name"+i).innerHTML = 
						"<a href=\"#\" id=\"name"+i+"\" onclick=\"location.href = 'http://store.steampowered.com/app/"+res[0] + "'>"+res[1]+"</a>";
					document.getElementById("tag"+i).innerHTML = 
						"<p id=\"tag"+i+"\" class=\"card-text\">Tags: "+res[3]+"</p>";
					document.getElementById("score"+i).innerHTML = 
						"<p id=\"score"+i+"\" class=\"card-text\">Score: "+res[2]+"</p>";
					document.getElementById("price"+i).innerHTML = 
						"<p id=\"price"+i+"\" class=\"card-text\">Price: $"+res[4]+"</p></div>"
				}
			}
		}
		
  	}
	
	function change(num) {
		var appid = [];
		var steamid = document.getElementById("user").getAttribute("steamid");
		appid.push(document.getElementById("game0").getAttribute("appid"));
		appid.push(document.getElementById("game1").getAttribute("appid"));
		appid.push(document.getElementById("game2").getAttribute("appid"));
		appid.push(document.getElementById("game3").getAttribute("appid"));
		/*appid.push(document.getElementById("game4").getAttribute("appid"));
		appid.push(document.getElementById("game5").getAttribute("appid"));
		appid.push(document.getElementById("game6").getAttribute("appid"));
		appid.push(document.getElementById("game7").getAttribute("appid"));*/
		var xmlhttp = new XMLHttpRequest();
		xmlhttp.open("GET", "http://localhost:8080/GameCenter/Change2?num=" + num
				+"&steamid="+steamid
				+"&game0="+appid[0]+"&game1="+appid[1]
				+"&game2="+appid[2]+"&game3="+appid[3]
				//+"&game4="+appid[4]+"&game5="+appid[5]
				//+"&game6="+appid[6]+"&game7="+appid[7]
				,true);
		xmlhttp.send(null);
		xmlhttp.onreadystatechange = function()
		{
			if(xmlhttp.readyState==4 && xmlhttp.status==200){
				var str = xmlhttp.responseText;
				var res = str.split("\t");
				console.log(res);
				var game = document.getElementById("game"+num);
				game.setAttribute("appid", res[0]);
				var image = document.getElementById("image"+num);
				image.setAttribute("src", "http://cdn.akamai.steamstatic.com/steam/apps/" + res[0] + "/header.jpg");
				image.setAttribute("onclick", "location.href = 'http://store.steampowered.com/app/"+res[0] + "'");
				document.getElementById("name"+num).innerHTML = 
					"<a href=\"#\" id=\"name"+num+"\" onclick=\"location.href = 'http://store.steampowered.com/app/"+res[0] + "'>"+res[1]+"</a>";
				document.getElementById("tag"+num).innerHTML = 
					"<p id=\"tag"+num+"\" class=\"card-text\">Tags: "+res[3]+"</p>";
				document.getElementById("score"+num).innerHTML = 
					"<p id=\"score"+num+"\" class=\"card-text\">Score: "+res[2]+"</p>";
				document.getElementById("price"+num).innerHTML = 
					"<p id=\"price"+num+"\" class=\"card-text\">Price: $"+res[4]+"</p></div>"
					
			}
		}
		
	}
	</script>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>GameCenter</title>

    <!-- Bootstrap core CSS -->
    <link href="vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

    <!-- Custom styles for this template -->
    <link href="css/4-col-portfolio.css" rel="stylesheet">
	
	
  </head>

  <body onload="getGame()">
  
  <div id="main_block">

    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
		<div class="container">
			<a class="navbar-brand" href="#">GameCenter</a>
			<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
				<span class="navbar-toggler-icon"></span>
			</button>
			<div class="collapse navbar-collapse" id="navbarResponsive">
				<ul class="navbar-nav ml-auto">
					<li class="nav-item active">
						<a id="user" steamid="<% out.print(steamid); %>" class="nav-link" href="#"data-toggle="modal" data-target="#modalOnoff"> gamecenter </a>
					</li>
					<li class="nav-item active">
						<a id="user" onclick="location.href = 'index.jsp'" class="nav-link" href="#"data-toggle="modal" data-target="#modalOnoff"> back </a>
					</li>
				</ul>
			</div>
		</div>
	  
    </nav>
	
	<!-- Page Content -->
    <div class="container">
	  
	<div class="featurette">
		<div class="featurette-inner text-center">
			<form role="form" class="search has-button">
			<h3 class="no-margin-top h1">Game Recommend</h3>
			</form>
			<!-- /.max-width on this form -->
		</div>
		<!-- /.featurette-inner (display:table-cell) -->
	</div>
		
		
      <div class="row">
        <div id="game0" appid="<% out.print(appid[0]); %>" class="col-lg-3 col-md-4 col-sm-6 portfolio-item">
          <div class="card h-100">
            <a href="#"><img id="image0" class="card-img-top" src="<% out.print("http://cdn.akamai.steamstatic.com/steam/apps/" + appid[0] + "/header.jpg"); %>" 
            onclick="location.href = 'http://store.steampowered.com/app/<% out.print(appid[0]); %>';"
            alt=""></a>
            <div class="card-body">
              <h4 class="card-title">
                <a href="#" id="name0" onclick="location.href = 'http://store.steampowered.com/app/<% out.print(appid[0]); %>';"><% out.print(name[0]); %></a>
              </h4>
			  <p id="tag0" class="card-text"><% out.print("Tags: " + tags[0]); %></p>
			  <p id="score0" class="card-text"><% out.print("Score: " + score_rank[0]); %></p>
			  <p id="price0" class="card-text"><% out.print("Price: $" + price[0]); %></p>
              </div>
              <div class="card-body" style="text-align: center;">
              <button class="btn btn-primary" onclick="change(0, 0)">like</button>
              <button class="btn btn-primary" onclick="change(0, 1)">unlike</button>
              </div>
          </div>
        </div>
        <div id="game1" appid="<% out.print(appid[1]); %>" class="col-lg-3 col-md-4 col-sm-6 portfolio-item">
          <div class="card h-100">
            <a href="#"><img id="image1" class="card-img-top" src="<% out.print("http://cdn.akamai.steamstatic.com/steam/apps/" + appid[1] + "/header.jpg"); %>" 
            onclick="location.href = 'http://store.steampowered.com/app/<% out.print(appid[1]); %>';"
            alt=""></a>
            <div class="card-body">
              <h4 class="card-title">
                <a href="#" id="name1" onclick="location.href = 'http://store.steampowered.com/app/<% out.print(appid[1]); %>';"><% out.print(name[1]); %></a>
              </h4>
			  <p id="tag1" class="card-text"><% out.print("Tags: " + tags[1]); %></p>
			  <p id="score1" class="card-text"><% out.print("Score: " + score_rank[1]); %></p>
			  <p id="price1" class="card-text"><% out.print("Price: $" + price[1]); %></p>
              </div>
              <div class="card-body" style="text-align: center;">
              
              <button class="btn btn-primary" onclick="change(1, 0)">like</button>
              <button class="btn btn-primary" onclick="change(1, 1)">unlike</button>
              </div>
          </div>
        </div>
        <div id="game2" appid="<% out.print(appid[2]); %>" class="col-lg-3 col-md-4 col-sm-6 portfolio-item">
          <div class="card h-100">
            <a href="#"><img id="image2" class="card-img-top" src="<% out.print("http://cdn.akamai.steamstatic.com/steam/apps/" + appid[2] + "/header.jpg"); %>" 
            onclick="location.href = 'http://store.steampowered.com/app/<% out.print(appid[2]); %>';"
            alt=""></a>
            <div class="card-body">
              <h4 class="card-title">
                <a href="#" id="name2" onclick="location.href = 'http://store.steampowered.com/app/<% out.print(appid[2]); %>';"><% out.print(name[2]); %></a>
              </h4>
			  <p id="tag2" class="card-text"><% out.print("Tags: " + tags[2]); %></p>
			  <p id="score2" class="card-text"><% out.print("Score: " + score_rank[2]); %></p>
			  <p id="price2" class="card-text"><% out.print("Price: $" + price[2]); %></p>
            </div>
            <div class="card-body" style="text-align: center;">
              <button class="btn btn-primary" onclick="change(2, 0)">like</button>
              <button class="btn btn-primary" onclick="change(2, 1)">unlike</button>
              </div>
          </div>
        </div>
        <div id="game3" appid="<% out.print(appid[3]); %>" class="col-lg-3 col-md-4 col-sm-6 portfolio-item">
          <div class="card h-100">
            <a href="#"><img id="image3" class="card-img-top" src="<% out.print("http://cdn.akamai.steamstatic.com/steam/apps/" + appid[3] + "/header.jpg"); %>" 
            onclick="location.href = 'http://store.steampowered.com/app/<% out.print(appid[3]); %>';"
            alt=""></a>
            <div class="card-body">
              <h4 class="card-title">
               <a href="#" id="name3" onclick="location.href = 'http://store.steampowered.com/app/<% out.print(appid[3]); %>';"><% out.print(name[3]); %></a>
              </h4>
			  <p id="tag3" class="card-text"><% out.print("Tags: " + tags[3]); %></p>
			  <p id="score3" class="card-text"><% out.print("Score: " + score_rank[3]); %></p>
			  <p id="price3" class="card-text"><% out.print("Price: $" + price[3]); %></p>
              </div>
              <div class="card-body" style="text-align: center;">
              <button class="btn btn-primary" onclick="change(3, 0)">like</button>
              <button class="btn btn-primary" onclick="change(3, 1)">unlike</button>
              </div>
          </div>
        </div>
      </div>
      <!-- /.row -->
      

    </div>
    <!-- /.container -->

    <!-- Footer -->
    <footer class="py-5 bg-dark">
      <div class="container">
        <p class="m-0 text-center text-white">Copyright &copy; T17 GameCenter 2017</p>
      </div>
      <!-- /.container -->
    </footer>

    <!-- Bootstrap core JavaScript -->
    <script src="vendor/jquery/jquery.min.js"></script>
    <script src="vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
</div>
  </body>

</html>