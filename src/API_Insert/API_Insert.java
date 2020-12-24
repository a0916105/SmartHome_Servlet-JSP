package API_Insert;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.Statement;

import javax.naming.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

import com.wst.MariaDB_Cert;

/**
 * Servlet implementation class API_InsertDate
 */
@WebServlet("/API_Insert")
public class API_Insert extends HttpServlet {
	// JDBC 驅動名及資料庫 URL
//	static final String JDBC_DRIVER = MariaDB_Cert.JDBC_DRIVER;
//	static final String DB_URL = MariaDB_Cert.DB_URL;

	// 資料庫的使用者名與密碼，需要根據自己的設定
//	static final String USER = MariaDB_Cert.USER;
//	static final String PASS = MariaDB_Cert.PASS;

	protected String databaseInsert(String schedule, String devices, String date, String weekday, String time,
			String onOff) {
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
			query = "INSERT INTO home000 (schedule, devices, Date, weekday, Time, switch) VALUES (" + "'" + schedule
					+ "'," + devices + "," + (date == null ? ("null,") : ("'" + date + "',"))
					+ (weekday == null ? ("null,") : ("'" + weekday + "',"))
					+ (time == null ? ("null,") : ("'" + time + "',")) + "'" + onOff + "')";

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
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String query = null;

		// 接收時也要使用 UTF-8 編碼字串
		request.setCharacterEncoding("UTF-8");

		// 獲取請求數據
		String schedule = request.getParameter("schedule");
		String devices = request.getParameter("devices");
		String date = request.getParameter("Date");
		String weekday = request.getParameter("weekday");
		String time = request.getParameter("Time");
		String onOff = request.getParameter("switch");

		// 指定服務器響應給瀏覽器的編碼
		response.setContentType("text/html; charset=UTF-8");

		// 響應信息通過out對象輸出到網頁上
		PrintWriter out = response.getWriter();
		out.println("<html><body>");

		// check
		out.println(schedule);
		out.println(devices);
		out.println(date);
		out.println(weekday);
		out.println(time);
		out.println(onOff);

		// 馬上啟動或關閉
		if ((weekday != null && weekday.equals("Now")) && schedule != null && devices != null && onOff != null && date == null
				&& time == null) {
			query = databaseInsert(schedule, devices, date, weekday, time, onOff);
		}
		// 限制 特定日期 和 重複定時 只能擇一
		else if ((schedule != null && devices != null && time != null && onOff != null)
				&& (date != null ^ weekday != null)) {
			query = databaseInsert(schedule, devices, date, weekday, time, onOff);
		}
		// show
		out.println(query);// 大部分寫入資料庫失敗，最後會顯示null
		out.println("</body></html>");

		// 測試網址
		// 特定日期：
		// localhost:8080/SmartHome/API_Insert?schedule=enable&devices=0&Date=2020-10-22&Time=23:20&switch=On
		// 重複定時：
		// localhost:8080/SmartHome/API_Insert?schedule=enable&devices=1&weekday=Sun,Mon,Tue,Wed,Thu,Fri,Sat&Time=23:25&switch=Off
		// Now：
		// localhost:8080/SmartHome/API_Insert?schedule=enable&devices=0&weekday=Now&switch=On
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
