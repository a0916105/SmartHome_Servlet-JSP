package API_Show;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import javax.naming.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

import org.json.JSONArray;
import org.json.JSONObject;

import com.google.gson.Gson;
import com.wst.MariaDB_Cert;

/**
 * Servlet implementation class API_Show
 */
@WebServlet("/API_Show")
public class API_Show extends HttpServlet {
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
//			Class.forName(MariaDB_Cert.JDBC_DRIVER);// 用來在執行時期動態載入Class

			// Open a connection
//			String url = MariaDB_Cert.DB_URL;
//			String user = MariaDB_Cert.USER;
//			String password = MariaDB_Cert.PASS;
			//使用JNDI來載入操作資料庫的相關設定
			Context context = new InitialContext();
			DataSource ds = (DataSource)context.lookup("java:comp/env/jdbc/mariaDB");
//			Connection con = DriverManager.getConnection(url, user, password);// 從DriverManager取得Connection
			Connection con = ds.getConnection();
			
			// 接收時也要使用 UTF-8 編碼字串
			request.setCharacterEncoding("UTF-8");

			// 獲取請求數據
			String device = request.getParameter("device");
			
			String query = "select * from home000"+(device==null?"":(" WHERE devices="+device));

			// Execute a query
			PreparedStatement pstmt = con.prepareStatement(query);
			ResultSet rs = pstmt.executeQuery();

			List<Home> newslist = new ArrayList<Home>();

			while (rs.next()) {
				int id = rs.getInt("id");
				//0~2預留給3個裝置的NOW設定
				if (id >= 3) {
					String schedule = rs.getString("schedule");
					int devices = rs.getInt("devices");
					String date = rs.getString("Date");
					String weekday = rs.getString("weekday");
					String time = rs.getString("Time");
					String onOff = rs.getString("switch");

					Home news = new Home(id, schedule, devices, date, weekday, time, onOff);
					newslist.add(news);
				}				
			}
			
			//close
			pstmt.close();
			rs.close();
			con.close();
			

			//json
			Gson gson = new Gson();
			String json = gson.toJson(newslist);

			// 輸出到界面
			response.setContentType("text/html; charset=UTF-8");
			PrintWriter out = response.getWriter();
			
			out.println(json);

		} catch (Exception e) {
			System.out.println(e);
		}
		
		//測試網址
		//localhost:8080/SmartHome/API_Show
		//只顯示特定裝置
		//localhost:8080/SmartHome/API_Show?device=0
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
