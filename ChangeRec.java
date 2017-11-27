package gamecenter;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Random;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/Change2")
public class ChangeRec extends HttpServlet{
	public ChangeRec() {
    	super();
    }
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}
	
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("change2 run");
		String num = request.getParameter("num");
		String steamid = request.getParameter("steamid");
		int showgame = 4, gamenum = 5;
		String[] games = new String[showgame];
		
		HashSet<Integer> set = new HashSet<>();
		for(int i = 0; i != showgame; ++i) {
			set.add(Integer.valueOf(request.getParameter("game"+i)));
		}
		
		PrintWriter out = response.getWriter();
		Connection con = null;
		Statement stmt;
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			con=DriverManager.getConnection("jdbc:oracle:thin:@oracle.cise.ufl.edu:1521:orcl", "shwang", "B7hhp342e");
			stmt=con.createStatement();
			String query = "select * from game_rec where steamid = "+steamid;
			ResultSet  rs = stmt.executeQuery(query);
			
			if(rs.next()) {
				int[] appids = new int[gamenum];
				for(int i = 0; i != gamenum; ++i) {
					appids[i] = rs.getInt(i + 2);
				}
				rs.close();
				
				int[] remain = new int[gamenum - showgame];
				int index = 0;
				for(int i : appids) {
					if(!set.contains(i)) {
						remain[index++] = i;
					}
				}
				Random rand = new Random();
				int n = rand.nextInt(gamenum - showgame);
				int appid = appids[n];
				query = "select * from game_info where appid = "+appid;
				rs = stmt.executeQuery(query);
				rs.next();
				String name = rs.getString(2);
				int score_rank = rs.getInt(5);
				float price = ((float)rs.getInt(6)) / 100;
				
				rs.close();
				rs = stmt.executeQuery("select tags, approve from game_tag where appid = " + appid);
				StringBuilder sb = new StringBuilder();
				while(rs.next()) {
					sb.append(rs.getString(1)).append('(').append(rs.getInt(2)).append(')').append(", "); 
				}
				if(sb.length() > 1) sb.setLength(sb.length() - 2);
				
				String tags = sb.toString();
				StringBuilder res = new StringBuilder();
				res.append(appid).append('\t');
				res.append(name).append('\t');
				res.append(score_rank).append('\t');
				res.append(tags).append('\t');
				res.append(price);

				out.print(res);
				out.close();
				rs.close();
				stmt.close();
				con.close();
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
			
	}
}
