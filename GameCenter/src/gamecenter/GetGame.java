package gamecenter;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@WebServlet("/getGame")
public class GetGame extends HttpServlet{
	public GetGame() {
    	super();
    }
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String steamid = request.getParameter("steamid");
		String query = "select * from game_rec where steamid = "+steamid;
		PrintWriter out = response.getWriter();
		Connection con = null;
		Statement stmt;
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			con=DriverManager.getConnection("jdbc:oracle:thin:@oracle.cise.ufl.edu:1521:orcl", "shwang", "B7hhp342e");
			stmt=con.createStatement();
			ResultSet rs = stmt.executeQuery(query);
			int gamenum = 5, showgame = 4;
			
			
			System.out.println("getGame run");
			int[] appid = new int[showgame];
			String[] name = new String[showgame];
			String[] developer = new String[showgame];
			String[] publisher = new String[showgame];
			int[] score_rank = new int[showgame];
			float[] price = new float[showgame];
			String[] tags = new String[showgame];
			
			if(rs.next()) {
				List<Integer> allid = new ArrayList<Integer>();
				for(int i = 0; i != gamenum; ++i) {
					allid.add(rs.getInt(i + 2));
				}
				rs.close();
				Collections.shuffle(allid);
			
				for(int i = 0; i != showgame; ++i) {
					appid[i] = allid.get(i);
				}
				
				for(int i = 0; i != showgame; ++i) {
					query = "select * from game_info where appid = "+appid[i];
					rs = stmt.executeQuery(query);
					rs.next();
					name[i] = rs.getString(2);
					developer[i] = rs.getString(3);
					publisher[i] = rs.getString(4);
					score_rank[i] = rs.getInt(5);
					price[i] = ((float)rs.getInt(6)) / 100;
					rs.close();
				}
				for(int i = 0; i != showgame; ++i) {
					rs = stmt.executeQuery("select tags, approve from game_tag where appid = " + appid[i]);
					StringBuilder sb = new StringBuilder();
					while(rs.next()) {
						sb.append(rs.getString(1)).append('(').append(rs.getInt(2)).append(')').append(", "); 
					}
					if(sb.length() > 1) sb.setLength(sb.length() - 2);
					tags[i] = sb.toString();
					rs.close();
				}
				
			}
			
			StringBuilder res = new StringBuilder();
			for(int i = 0; i != showgame; ++i) {
				res.append(appid[i]).append('\t');
				res.append(name[i]).append('\t');
				res.append(score_rank[i]).append('\t');
				res.append(tags[i]).append('\t');
				res.append(price[i]).append('\n');
			}
			System.out.println("steamid" + steamid);
			System.out.println(res);
			out.print(res.toString());
			out.close();
			
			rs.close();
			stmt.close();
			con.close();
		
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
