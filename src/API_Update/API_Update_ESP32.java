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
 * Servlet implementation class API_Update_ESP32
 */
@WebServlet("/API_Update_ESP32")
public class API_Update_ESP32 extends HttpServlet {
	// JDBC 驅動名及資料庫 URL
//	static final String JDBC_DRIVER = MariaDB_Cert.JDBC_DRIVER;
//	static final String DB_URL = MariaDB_Cert.DB_URL;

	// 資料庫的使用者名與密碼，需要根據自己的設定
//	static final String USER = MariaDB_Cert.USER;
//	static final String PASS = MariaDB_Cert.PASS;

	protected String databaseUpdate(String id, String schedule, String ac, String dh, String ap) {
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

			// SQL
			//馬上啟動或關閉
			if (ac==null && dh==null && ap==null) {
				query = "UPDATE home000 SET schedule='" + schedule + "' WHERE id=" + id;
			//紀錄裝置開或關
			}else if (id==null && schedule==null) {
				query = "UPDATE home000_settings SET AC=" + ac + ",DH=" + dh + ",AP=" + ap + " WHERE item='set_values'";
			}
			

			// Execute a query
			PreparedStatement pstmt = con.prepareStatement(query);
			pstmt.executeUpdate();

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
		String schedule = request.getParameter("schedule");
		String id = request.getParameter("id");
		String ac = request.getParameter("AC");
		String dh = request.getParameter("DH");
		String ap = request.getParameter("AP");
		
		//指定服務器響應給瀏覽器的編碼
		response.setContentType("text/html; charset=UTF-8");
		
		//響應信息通過out對象輸出到網頁上
		PrintWriter out = response.getWriter();
		
		out.println("<html><body>");
		out.println(schedule);
		out.println(id);
		out.println(ac);
		out.println(dh);
		out.println(ap);
		
		query = databaseUpdate(id, schedule, ac, dh, ap);

		// show
		out.println(query);//大部分寫入資料庫失敗，最後會顯示null
		out.println("</body></html>");
		
		// 測試網址
		//馬上啟動或關閉
		//localhost:8080/SmartHome/API_Update_ESP32?schedule=disable&id=8
		//紀錄裝置開或關
		//localhost:8080/SmartHome/API_Update_ESP32?AC=1&DH=1&AP=1
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
