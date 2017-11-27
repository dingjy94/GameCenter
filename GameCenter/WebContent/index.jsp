<%@ page language="java" import="java.util.*,java.sql.*,java.io.*" %>

<%
	Class.forName("oracle.jdbc.driver.OracleDriver").newInstance();
	Connection con=DriverManager.getConnection("jdbc:oracle:thin:@oracle.cise.ufl.edu:1521:orcl", "shwang", "B7hhp342e"); 
	Statement stmt=con.createStatement(); 
	ResultSet rs = stmt.executeQuery("select * from (select * from game_info where score_rank = 100 order by dbms_random.value) where ROWNUM <= 8");
	int[] appid = new int[8];
	String[] name = new String[8];
	String[] developer = new String[8];
	String[] publisher = new String[8];
	int[] score_rank = new int[8];
	float[] price = new float[8];
	String[] tags = new String[8];
	for(int i = 0; rs.next(); ++i) {
		appid[i] = rs.getInt(1);
		name[i] = rs.getString(2);
		developer[i] = rs.getString(3);
		publisher[i] = rs.getString(4);
		score_rank[i] = rs.getInt(5);
		price[i] = ((float)rs.getInt(6)) / 100;
	}
	rs.close();
	for(int i = 0; i != 8; ++i) {
		rs = stmt.executeQuery("select tags, approve from game_tag where appid = " + appid[i]);
		StringBuilder sb = new StringBuilder();
		while(rs.next()) {
			sb.append(rs.getString(1)).append('(').append(rs.getInt(2)).append(')').append(", "); 
		}
		if(sb.length() > 1) sb.setLength(sb.length() - 2);
		tags[i] = sb.toString();
		rs.close();
	}
%>

<!DOCTYPE html>
<html lang="en">

  <head>
  
  	<script LANGUAGE="JavaScript">
	function signin()
	{
		var email = document.getElementById("email").value;
		var password = document.getElementById("password").value;
		var xmlhttp = new XMLHttpRequest();
		xmlhttp.open("GET", "http://localhost:8080/GameCenter/Signin?email="+email+"&password="+password,true);
		xmlhttp.send(null);
		
		xmlhttp.onreadystatechange = function()
		{
			if(xmlhttp.readyState==4 && xmlhttp.status==200){
				if(xmlhttp.responseText == 0){
					alert("password not match");
				} else {
					window.location.href = xmlhttp.responseText;
				}
			}
		}
	}
	
	function change(num) {
		var appid = [];
		appid.push(document.getElementById("game0").getAttribute("appid"));
		appid.push(document.getElementById("game1").getAttribute("appid"));
		appid.push(document.getElementById("game2").getAttribute("appid"));
		appid.push(document.getElementById("game3").getAttribute("appid"));
		appid.push(document.getElementById("game4").getAttribute("appid"));
		appid.push(document.getElementById("game5").getAttribute("appid"));
		appid.push(document.getElementById("game6").getAttribute("appid"));
		appid.push(document.getElementById("game7").getAttribute("appid"));
		var xmlhttp = new XMLHttpRequest();
		xmlhttp.open("GET", "http://localhost:8080/GameCenter/Change1?num=" + num
		+"&game0="+appid[0]+"&game1="+appid[1]
		+"&game2="+appid[2]+"&game3="+appid[3]
		+"&game4="+appid[4]+"&game5="+appid[5]
		+"&game6="+appid[6]+"&game7="+appid[7],true);
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

  <body>
  
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
						<a class="nav-link" href="#"data-toggle="modal" data-target="#modalOnoff">Login</a>
					</li>
				</ul>
			</div>
		</div>
	  
    </nav>
	
	<!-- Page Content -->
    <div class="container">
	
	<div class="modal fade" id="modalOnoff" tabindex="-1" role="dialog" aria-labelledby="lbOnoff">
	  <div class="modal-dialog">
		<div class="modal-content">
		  <div class="modal-header">
			<h4 class="modal-title" id="lbOnoff">Sign In</h4>
		  </div>
		  <div class="modal-body">
			<div class="row">
			  <div class="col-md-8" >
				<form>
				  <div class="form-group"><label>Email</label><input id="email" type="text" class="form-control" required="true" placeholder="Email" value=""></div>
				  <div class="form-group"><label>Password</label><input id="password" type="password" class="form-control" required="true" placeholder="Password"></div>
				  <div class="form-group"><button class="btn btn-md btn-success btn-block" type='submit' onclick="signin()">Sign in</button></div>
				</form>
			  </div>
			</div>
		  </div>
		</div>
	  </div>
	</div>
	  
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
              <button class="btn btn-primary" onclick="change(0)">change</button>
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
              <button class="btn btn-primary" onclick="change(1)">change</button>
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
              <button class="btn btn-primary" onclick="change(2)">change</button>
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
              <button class="btn btn-primary" onclick="change(3)">change</button>
              </div>
          </div>
        </div>
        <div id="game4" appid="<% out.print(appid[4]); %>" class="col-lg-3 col-md-4 col-sm-6 portfolio-item">
          <div class="card h-100">
            <a href="#"><img id="image4" class="card-img-top" src="<% out.print("http://cdn.akamai.steamstatic.com/steam/apps/" + appid[4] + "/header.jpg"); %>" 
            onclick="location.href = 'http://store.steampowered.com/app/<% out.print(appid[4]); %>';"
            alt=""></a>
            <div class="card-body">
              <h4 class="card-title">
               <a href="#" id="name4" onclick="location.href = 'http://store.steampowered.com/app/<% out.print(appid[4]); %>';"><% out.print(name[4]); %></a>
              </h4>
			  <p id="tag4" class="card-text"><% out.print("Tags: " + tags[4]); %></p>
			  <p id="score4" class="card-text"><% out.print("Score: " + score_rank[4]); %></p>
			  <p id="price4" class="card-text"><% out.print("Price: $" + price[4]); %></p>
            </div>
            <div class="card-body" style="text-align: center;">
              <button class="btn btn-primary" onclick="change(4)">change</button>
              </div>
          </div>
        </div>
        <div id="game5" appid="<% out.print(appid[5]); %>" class="col-lg-3 col-md-4 col-sm-6 portfolio-item">
          <div class="card h-100">
            <a href="#"><img id="image5" class="card-img-top" src="<% out.print("http://cdn.akamai.steamstatic.com/steam/apps/" + appid[5] + "/header.jpg"); %>" 
            onclick="location.href = 'http://store.steampowered.com/app/<% out.print(appid[5]); %>';"
            alt=""></a>
            <div class="card-body">
              <h4 class="card-title">
               <a href="#" id="name5" onclick="location.href = 'http://store.steampowered.com/app/<% out.print(appid[5]); %>';"><% out.print(name[5]); %></a>
              </h4>
			  <p id="tag5" class="card-text"><% out.print("Tags: " + tags[5]); %></p>
			  <p id="score5" class="card-text"><% out.print("Score: " + score_rank[5]); %></p>
			  <p id="price5" class="card-text"><% out.print("Price: $" + price[5]); %></p>
			</div>
			<div class="card-body" style="text-align: center;">
              <button class="btn btn-primary" onclick="change(5)">change</button>
              </div>
          </div>
        </div>
        <div id="game6" appid="<% out.print(appid[6]); %>" class="col-lg-3 col-md-4 col-sm-6 portfolio-item">
          <div class="card h-100">
            <a href="#"><img id="image6" class="card-img-top" src="<% out.print("http://cdn.akamai.steamstatic.com/steam/apps/" + appid[6] + "/header.jpg"); %>" 
            onclick="location.href = 'http://store.steampowered.com/app/<% out.print(appid[6]); %>';"
            alt=""></a>
            <div class="card-body">
              <h4 class="card-title">
                <a href="#" id="name6" onclick="location.href = 'http://store.steampowered.com/app/<% out.print(appid[6]); %>';"><% out.print(name[6]); %></a>
              </h4>
			  <p id="tag6" class="card-text"><% out.print("Tags: " + tags[6]); %></p>
			  <p id="score6" class="card-text"><% out.print("Score: " + score_rank[6]); %></p>
			  <p id="price6" class="card-text"><% out.print("Price: $" + price[6]); %></p>
            </div>
            <div class="card-body" style="text-align: center;">
              <button class="btn btn-primary" onclick="change(6)">change</button>
              </div>
          </div>
        </div>
        <div id="game7" appid="<% out.print(appid[7]); %>" class="col-lg-3 col-md-4 col-sm-6 portfolio-item">
          <div class="card h-100">
            <a href="#"><img id="image7" class="card-img-top" src="<% out.print("http://cdn.akamai.steamstatic.com/steam/apps/" + appid[7] + "/header.jpg"); %>" 
            onclick="location.href = 'http://store.steampowered.com/app/<% out.print(appid[7]); %>';"
            alt=""></a>
            <div class="card-body">
              <h4 class="card-title">
               <a href="#" id="name7" onclick="location.href = 'http://store.steampowered.com/app/<% out.print(appid[7]); %>';"><% out.print(name[7]); %></a>
              </h4>
			  <p id="tag7" class="card-text"><% out.print("Tags: " + tags[7]); %></p>
			  <p id="score7" class="card-text"><% out.print("Score: " + score_rank[7]); %></p>
			  <p id="price7" class="card-text"><% out.print("Price: $" + price[7]); %></p>
            </div>
            <div class="card-body" style="text-align: center;">
              <button class="btn btn-primary" onclick="change(7)">change</button>
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
<%	rs.close();
	stmt.close();
	con.close();%>