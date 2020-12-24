package API_Update;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import javax.naming.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

import com.wst.MariaDB_Cert;

/**
 * Servlet implementation class API_Update_settings
 */
@WebServlet("/API_Update_settings")
public class API_Update_settings extends HttpServlet {
	// JDBC 驅動名及資料庫 URL
//	static final String JDBC_DRIVER = MariaDB_Cert.JDBC_DRIVER;
//	static final String DB_URL = MariaDB_Cert.DB_URL;

	// 資料庫的使用者名與密碼，需要根據自己的設定
//	static final String USER = MariaDB_Cert.USER;
//	static final String PASS = MariaDB_Cert.PASS;

	protected String databaseUpdate(String auto, String celsius_On, String celsius_Off, String humidity_On, String humidity_Off,
					String pm2_5_On, String pm2_5_Off) {
		Connection con = null;
		String query = null;
	
		try {
			// 註冊 JDBC 驅動器
//			Class.forName(JDBC_DRIVER);
			//使用JNDI來載入操作資料庫的相關設定
			Context context = new InitialContext();
			DataSource ds = (DataSource)context.lookup("java:comp/env/jdbc/mariaDB");
			// 開啟一個連接
//			con = DriverManager.getConnection(DB_URL, USER, PASS);
			con = ds.getConnection();
			
			StringBuilder temp=new StringBuilder(auto==null ? "":("Auto='" + auto + "'"));
			if(celsius_On != null)
				temp.append((temp.length()==0 ? "":",")+("Celsius_On=" + celsius_On));
			if(celsius_Off != null)
				temp.append((temp.length()==0 ? "":",")+("Celsius_Off=" + celsius_Off));
			if(humidity_On != null)
				temp.append((temp.length()==0 ? "":",")+("Humidity_On=" + humidity_On));
			if(humidity_Off != null)
				temp.append((temp.length()==0 ? "":",")+("Humidity_Off=" + humidity_Off));
			if(pm2_5_On != null)
				temp.append((temp.length()==0 ? "":",")+("PM2_5_On=" + pm2_5_On));
			if(pm2_5_Off != null)
				temp.append((temp.length()==0 ? "":",")+("PM2_5_Off=" + pm2_5_Off));
			// SQL
			query = "UPDATE home000_settings SET " + temp + " WHERE item='set_values'";
	
			// Execute a query
			PreparedStatement pstmt = con.prepareStatement(query);
			int rowCount = pstmt.executeUpdate();
			
			if(rowCount==1)
				query+="\nUPDATE_settings_OK";
	
			// close
			pstmt.close();
			con.close();
	
		} catch (Exception e) {
			System.out.println(e);
		}
	
		// return sql語法
		return query;

	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String query = null;
		
		// 接收時也要使用 UTF-8 編碼字串
		request.setCharacterEncoding("UTF-8");

		// 獲取請求數據
		String auto = request.getParameter("Auto");
		String celsius_On = request.getParameter("Celsius_On");
		String celsius_Off = request.getParameter("Celsius_Off");
		String humidity_On = request.getParameter("Humidity_On");
		String humidity_Off = request.getParameter("Humidity_Off");
		String pm2_5_On = request.getParameter("PM2_5_On");
		String pm2_5_Off = request.getParameter("PM2_5_Off");
		
		//指定服務器響應給瀏覽器的編碼
		response.setContentType("text/html; charset=UTF-8");
		
		//響應信息通過out對象輸出到網頁上
		PrintWriter out = response.getWriter();
		
		out.println("<html><body>");
		out.println(auto);
		out.println(celsius_On);
		out.println(celsius_Off);
		out.println(humidity_On);
		out.println(humidity_Off);
		out.println(pm2_5_On);
		out.println(pm2_5_Off);
		
		query = databaseUpdate(auto,celsius_On,celsius_Off,humidity_On,humidity_Off,pm2_5_On,pm2_5_Off);
		
		// show
		out.println(query);//大部分寫入資料庫失敗，最後會顯示null
		out.println("</body></html>");
		
		// 測試網址(所有值都可以填或不填)
		//localhost:8080/SmartHome/API_Update_settings?Auto=N&Celsius_On=30.55&Celsius_Off=28.55&Humidity_On=57.55&Humidity_Off=48.55&PM2_5_On=20.55&PM2_5_Off=11.55
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
