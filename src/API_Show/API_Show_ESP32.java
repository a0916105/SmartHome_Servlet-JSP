package API_Show;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
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
 * Servlet implementation class API_Show_ESP32
 */
@WebServlet("/API_Show_ESP32")
public class API_Show_ESP32 extends HttpServlet {
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
			String devices = request.getParameter("devices");
			
//			Class.forName(JDBC_DRIVER);// 用來在執行時期動態載入Class
			
			//使用JNDI來載入操作資料庫的相關設定
			Context context = new InitialContext();
			DataSource ds = (DataSource)context.lookup("java:comp/env/jdbc/mariaDB");

			// Open a connection
//			con = DriverManager.getConnection(DB_URL, USER, PASS);// 從DriverManager取得Connection
			con = ds.getConnection();

			if (devices == null) {
				query = "select * from home000_settings";
	
				// Execute a query
				pstmt = con.prepareStatement(query);
				rs = pstmt.executeQuery();
	
				List<Setting> newslist = new ArrayList<Setting>();
	
				while (rs.next()) {
					String item = rs.getString("item");
					String auto = rs.getString("Auto");
					String celsius_On = rs.getString("Celsius_On");
					String celsius_Off = rs.getString("Celsius_Off");
					String humidity_On = rs.getString("Humidity_On");
					String humidity_Off = rs.getString("Humidity_Off");
					String pm2_5_On = rs.getString("PM2_5_On");
					String pm2_5_Off = rs.getString("PM2_5_Off");
	
					Setting news = new Setting(item, auto, celsius_On, celsius_Off, humidity_On, humidity_Off, pm2_5_On, pm2_5_Off);
					newslist.add(news);
				}
				
				//close
				pstmt.close();
				rs.close();
				con.close();
				
				//json
				gson = new Gson();
				json = gson.toJson(newslist);
			} else if (devices.equals("states")) {
				query = "SELECT AC,DH,AP FROM `home000_settings` WHERE item='set_values'";
				
				// Execute a query
				pstmt = con.prepareStatement(query);
				rs = pstmt.executeQuery();
	
				List<Setting> newslist = new ArrayList<Setting>();
	
				while (rs.next()) {
					int ac = rs.getInt("AC");
					int dh = rs.getInt("DH");
					int ap = rs.getInt("AP");
	
					Setting news = new Setting(ac, dh, ap);
					newslist.add(news);
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
		//顯示settings
		//localhost:8080/SmartHome/API_Show_ESP32
		//顯示devices狀態
		//localhost:8080/SmartHome/API_Show_ESP32?devices=states
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
