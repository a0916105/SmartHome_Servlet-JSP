package API_Show;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.naming.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

import com.google.gson.Gson;
import com.wst.MariaDB_Cert;

/**
 * Servlet implementation class API_Show_Sensors
 */
@WebServlet("/API_Show_Sensors")
public class API_Show_Sensors extends HttpServlet {
	// JDBC 驅動名及資料庫 URL
//	static final String JDBC_DRIVER = MariaDB_Cert.JDBC_DRIVER;
//	static final String DB_URL = MariaDB_Cert.DB_URL;
		
	// 資料庫的使用者名與密碼，需要根據自己的設定
//	static final String USER = MariaDB_Cert.USER;
//	static final String PASS = MariaDB_Cert.PASS;

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Connection con = null;
		String query = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		//json
		Gson gson = null;
		String json = null;
		
		try {
			// 接收時也要使用 UTF-8 編碼字串
			request.setCharacterEncoding("UTF-8");

			// 獲取請求數據
			String sensors = request.getParameter("sensors");
			
//			Class.forName(JDBC_DRIVER);// 用來在執行時期動態載入Class
			
			//使用JNDI來載入操作資料庫的相關設定
			Context context = new InitialContext();
			DataSource ds = (DataSource)context.lookup("java:comp/env/jdbc/mariaDB");

			// Open a connection
//			con = DriverManager.getConnection(DB_URL, USER, PASS);// 從DriverManager取得Connection
			con = ds.getConnection();

			if (sensors == null) {
				query = "select * from home000_sensors";
	
				// Execute a query
				pstmt = con.prepareStatement(query);
				rs = pstmt.executeQuery();
	
				List<Sensors> newslist = new ArrayList<Sensors>();
	
				while (rs.next()) {
					int id = rs.getInt("id");
					String celsius = rs.getString("celsius");
					String humidity = rs.getString("humidity");
					String pm2_5 = rs.getString("PM2_5");
					String datetime = rs.getString("datetime");
	
					Sensors news = new Sensors(id, celsius, humidity, pm2_5, datetime);
					newslist.add(news);
				}
				
				//close
				pstmt.close();
				rs.close();
				con.close();
				
				//json
				gson = new Gson();
				json = gson.toJson(newslist);
			} else if (sensors.equals("today")) {
				Date dNow = new Date( );
			    SimpleDateFormat ft = new SimpleDateFormat ("yyyy-MM-dd");
			    String today = ft.format(dNow)+"%";
				query = "(SELECT celsius,humidity,PM2_5 FROM home000_sensors WHERE datetime LIKE ? ORDER BY id DESC LIMIT 1) "
						+ "UNION SELECT MAX(celsius),MAX(humidity),MAX(PM2_5) FROM home000_sensors WHERE datetime LIKE ? "
						+ "UNION SELECT MIN(celsius),MIN(humidity),MIN(PM2_5) FROM home000_sensors WHERE datetime LIKE ? "
						+ "UNION SELECT AVG(celsius),AVG(humidity),AVG(PM2_5) FROM home000_sensors WHERE datetime LIKE ?";
				
				// Execute a query
				pstmt = con.prepareStatement(query);
				for (int i = 1; i <= 4; i++)
					pstmt.setString(i, today);				
				rs = pstmt.executeQuery();
	
				List<Sensors> newslist = new ArrayList<Sensors>();
				int itemCount=1;
				while (rs.next()) {
					String item = null;
					switch (itemCount) {
						case 1:
							item="Now";
							break;
						case 2:
							item="Max";
							break;
						case 3:
							item="Min";
							break;
						case 4:
							item="Avg";
							break;
					}
					String celsius = rs.getString("celsius");
					String humidity = rs.getString("humidity");
					String pm2_5 = rs.getString("PM2_5");
						
					Sensors news = new Sensors(item, celsius, humidity, pm2_5);
					newslist.add(news);
					itemCount++;
				}
				
				//close
				pstmt.close();
				rs.close();
				con.close();
				
				//json
				gson = new Gson();
				json = gson.toJson(newslist);
			}

			// 輸出到界面
			response.setContentType("text/html; charset=UTF-8");
			PrintWriter out = response.getWriter();
			
			out.println(json);

		} catch (Exception e) {
			System.out.println(e);
		}
		
		//測試網址
		//顯示Sensors所有資料
		//localhost:8080/SmartHome/API_Show_Sensors
		//顯示Sensors今日最新、最大、最小、平均
		//localhost:8080/SmartHome/API_Show_Sensors?sensors=today
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
