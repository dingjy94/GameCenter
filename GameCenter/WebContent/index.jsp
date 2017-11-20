<%@ page language="java" import="java.util.*,java.sql.*,java.io.*" %>

<%
	Class.forName("oracle.jdbc.driver.OracleDriver").newInstance();
	Connection con=DriverManager.getConnection("jdbc:oracle:thin:@oracle.cise.ufl.edu:1521:orcl", cs_ufid, password); 
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

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>GameCenter</title>

    <!-- Bootstrap core CSS -->
    <link href="vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

    <!-- Custom styles for this template -->
    <link href="css/4-col-portfolio.css" rel="stylesheet">
	
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
			}
		}
	}
}
</script>
	
	
  </head>

  <body>
  

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
				<div class="form-group">
					<input type="search" placeholder="type interested games" class="form-control form-control-lg">
					<button class="btn btn-lg btn-warning" type="button">Search</button>
				</div>
				<!-- /form-group -->
			</form>
			<!-- /.max-width on this form -->
		</div>
		<!-- /.featurette-inner (display:table-cell) -->
	</div>
		
		
      <div class="row">
        <div class="col-lg-3 col-md-4 col-sm-6 portfolio-item">
          <div class="card h-100">
            <a href="#"><img class="card-img-top" src="<% out.print("http://cdn.akamai.steamstatic.com/steam/apps/" + appid[0] + "/header.jpg"); %>" 
            onclick="location.href = 'http://store.steampowered.com/app/<% out.print(appid[0]); %>';"
            alt=""></a>
            <div class="card-body">
              <h4 class="card-title">
                <a href="#" onclick="location.href = 'http://store.steampowered.com/app/<% out.print(appid[0]); %>';"><% out.print(name[0]); %></a>
              </h4>
			  <p class="card-text"><% out.print("Tags: " + tags[0]); %></p>
			  <p class="card-text"><% out.print("Score: " + score_rank[0]); %></p>
			  <p class="card-text"><% out.print("Price: $" + price[0]); %></p>
              </div>
          </div>
        </div>
        <div class="col-lg-3 col-md-4 col-sm-6 portfolio-item">
          <div class="card h-100">
            <a href="#"><img class="card-img-top" src="<% out.print("http://cdn.akamai.steamstatic.com/steam/apps/" + appid[1] + "/header.jpg"); %>" 
            onclick="location.href = 'http://store.steampowered.com/app/<% out.print(appid[1]); %>';"
            alt=""></a>
            <div class="card-body">
              <h4 class="card-title">
                <a href="#" onclick="location.href = 'http://store.steampowered.com/app/<% out.print(appid[1]); %>';"><% out.print(name[1]); %></a>
              </h4>
			  <p class="card-text"><% out.print("Tags: " + tags[1]); %></p>
			  <p class="card-text"><% out.print("Score: " + score_rank[1]); %></p>
			  <p class="card-text"><% out.print("Price: $" + price[1]); %></p>
              </div>
          </div>
        </div>
        <div class="col-lg-3 col-md-4 col-sm-6 portfolio-item">
          <div class="card h-100">
            <a href="#"><img class="card-img-top" src="<% out.print("http://cdn.akamai.steamstatic.com/steam/apps/" + appid[2] + "/header.jpg"); %>" 
            onclick="location.href = 'http://store.steampowered.com/app/<% out.print(appid[2]); %>';"
            alt=""></a>
            <div class="card-body">
              <h4 class="card-title">
                <a href="#" onclick="location.href = 'http://store.steampowered.com/app/<% out.print(appid[2]); %>';"><% out.print(name[2]); %></a>
              </h4>
			  <p class="card-text"><% out.print("Tags: " + tags[2]); %></p>
			  <p class="card-text"><% out.print("Score: " + score_rank[2]); %></p>
			  <p class="card-text"><% out.print("Price: $" + price[2]); %></p>
            </div>
          </div>
        </div>
        <div class="col-lg-3 col-md-4 col-sm-6 portfolio-item">
          <div class="card h-100">
            <a href="#"><img class="card-img-top" src="<% out.print("http://cdn.akamai.steamstatic.com/steam/apps/" + appid[3] + "/header.jpg"); %>" 
            onclick="location.href = 'http://store.steampowered.com/app/<% out.print(appid[3]); %>';"
            alt=""></a>
            <div class="card-body">
              <h4 class="card-title">
               <a href="#" onclick="location.href = 'http://store.steampowered.com/app/<% out.print(appid[3]); %>';"><% out.print(name[3]); %></a>
              </h4>
			  <p class="card-text"><% out.print("Tags: " + tags[3]); %></p>
			  <p class="card-text"><% out.print("Score: " + score_rank[3]); %></p>
			  <p class="card-text"><% out.print("Price: $" + price[3]); %></p>
              </div>
          </div>
        </div>
        <div class="col-lg-3 col-md-4 col-sm-6 portfolio-item">
          <div class="card h-100">
            <a href="#"><img class="card-img-top" src="<% out.print("http://cdn.akamai.steamstatic.com/steam/apps/" + appid[4] + "/header.jpg"); %>" 
            onclick="location.href = 'http://store.steampowered.com/app/<% out.print(appid[4]); %>';"
            alt=""></a>
            <div class="card-body">
              <h4 class="card-title">
               <a href="#" onclick="location.href = 'http://store.steampowered.com/app/<% out.print(appid[4]); %>';"><% out.print(name[4]); %></a>
              </h4>
			  <p class="card-text"><% out.print("Tags: " + tags[4]); %></p>
			  <p class="card-text"><% out.print("Score: " + score_rank[4]); %></p>
			  <p class="card-text"><% out.print("Price: $" + price[4]); %></p>
            </div>
          </div>
        </div>
        <div class="col-lg-3 col-md-4 col-sm-6 portfolio-item">
          <div class="card h-100">
            <a href="#"><img class="card-img-top" src="<% out.print("http://cdn.akamai.steamstatic.com/steam/apps/" + appid[5] + "/header.jpg"); %>" 
            onclick="location.href = 'http://store.steampowered.com/app/<% out.print(appid[5]); %>';"
            alt=""></a>
            <div class="card-body">
              <h4 class="card-title">
               <a href="#" onclick="location.href = 'http://store.steampowered.com/app/<% out.print(appid[5]); %>';"><% out.print(name[5]); %></a>
              </h4>
			  <p class="card-text"><% out.print("Tags: " + tags[5]); %></p>
			  <p class="card-text"><% out.print("Score: " + score_rank[5]); %></p>
			  <p class="card-text"><% out.print("Price: $" + price[5]); %></p>
			</div>
          </div>
        </div>
        <div class="col-lg-3 col-md-4 col-sm-6 portfolio-item">
          <div class="card h-100">
            <a href="#"><img class="card-img-top" src="<% out.print("http://cdn.akamai.steamstatic.com/steam/apps/" + appid[6] + "/header.jpg"); %>" 
            onclick="location.href = 'http://store.steampowered.com/app/<% out.print(appid[6]); %>';"
            alt=""></a>
            <div class="card-body">
              <h4 class="card-title">
                <a href="#" onclick="location.href = 'http://store.steampowered.com/app/<% out.print(appid[6]); %>';"><% out.print(name[6]); %></a>
              </h4>
			  <p class="card-text"><% out.print("Tags: " + tags[6]); %></p>
			  <p class="card-text"><% out.print("Score: " + score_rank[6]); %></p>
			  <p class="card-text"><% out.print("Price: $" + price[6]); %></p>
            </div>
          </div>
        </div>
        <div class="col-lg-3 col-md-4 col-sm-6 portfolio-item">
          <div class="card h-100">
            <a href="#"><img class="card-img-top" src="<% out.print("http://cdn.akamai.steamstatic.com/steam/apps/" + appid[7] + "/header.jpg"); %>" 
            onclick="location.href = 'http://store.steampowered.com/app/<% out.print(appid[7]); %>';"
            alt=""></a>
            <div class="card-body">
              <h4 class="card-title">
               <a href="#" onclick="location.href = 'http://store.steampowered.com/app/<% out.print(appid[7]); %>';"><% out.print(name[7]); %></a>
              </h4>
			  <p class="card-text"><% out.print("Tags: " + tags[7]); %></p>
			  <p class="card-text"><% out.print("Score: " + score_rank[7]); %></p>
			  <p class="card-text"><% out.print("Price: $" + price[7]); %></p>
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

  </body>

</html>
<%	rs.close();
	stmt.close();
	con.close();%>