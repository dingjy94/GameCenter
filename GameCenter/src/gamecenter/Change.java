package gamecenter;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/Change1")
public class Change extends HttpServlet{
	public Change() {
    	super();
    }
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}
	
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("change run");
		String num = request.getParameter("num");
		String game0 = request.getParameter("game0");
		String game1 = request.getParameter("game1");
		String game2 = request.getParameter("game2");
		String game3 = request.getParameter("game3");
		String game4 = request.getParameter("game4");
		String game5 = request.getParameter("game5");
		String game6 = request.getParameter("game6");
		String game7 = request.getParameter("game7");
		
		PrintWriter out = response.getWriter();
		Connection con = null;
		Statement stmt;
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			con=DriverManager.getConnection("jdbc:oracle:thin:@oracle.cise.ufl.edu:1521:orcl", "shwang", "B7hhp342e");
			stmt=con.createStatement();
			StringBuilder query = new StringBuilder();
			query.append("select * from (select * from game_info where score_rank = 100");
			query.append(" and appid != " + game0);
			query.append(" and appid != " + game1);
			query.append(" and appid != " + game2);
			query.append(" and appid != " + game3);
			query.append(" and appid != " + game4);
			query.append(" and appid != " + game5);
			query.append(" and appid != " + game6);
			query.append(" and appid != " + game7);
			query.append(" and appid != " + game7);
			query.append(" order by dbms_random.value) where ROWNUM = 1");
			System.out.println(query.toString());
			ResultSet  rs = stmt.executeQuery(query.toString());
			rs.next();
			int appid = rs.getInt(1);
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
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
			
	}
}
