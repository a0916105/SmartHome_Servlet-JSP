<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import= "java.sql.*" %>
<%@ page import= "java.io.*" %>
	
	
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>自動監測開關</title>
<style>

.wrap{
	text-align: center;
}
.container{
  margin:0 auto;
  width: 600px;
}
</style>
</head>
<body>

	<div class="container">
	<form action="#" method="get">

		<input type="checkbox" name="check" value="Y"
			style="width: 25px; height: 25px;">
		<lable> 設定自動開啟條件</lable>
		<br>
		<br>
		<br> <label>溫度高於：</label> <input type="text" name="Celsius_On">&nbsp;&nbsp;
		<label>溫度低於：</label> <input type="text" name="Celsius_Off"><br>
		<br> <label>濕度高於：</label> <input type="text" name="Humidity_On">&nbsp;&nbsp;
		<label>濕度低於：</label> <input type="text" name="Humidity_Off"><br>
		<br> <label>PM2.5高於：</label> <input type="text" name="PM2_5_On">&nbsp;&nbsp;
		<label>PM2.5低於：</label> <input type="text" name="PM2_5_Off"><br><br>
		<input type='hidden' name='begin' value='ok' />
		<input type="reset" value="取消">
		<input type="submit" value="送出"><br> <br>
	</form>
	<button name="home" type="submit" onclick="location.href='index.jsp'">回首頁</button></div>
	<br>
	<br>
	
	<%	
	String begin = request.getParameter("begin");
	//System.out.print("before"+begin);
	
	String sDriver = "org.mariadb.jdbc.Driver";
		String url = "jdbc:mariadb://localhost:3306/smart_home";
		String user = "wst";
		String password = "1qaz@wsx";
		
	if(begin!=null){//System.out.print("done"+begin);
	
		String c = request.getParameter("check");

		Connection dbCon = null;
		Statement stmt = null;
		ResultSet result = null;

		StringBuilder sb = new StringBuilder();

		Class.forName(sDriver);
		dbCon = DriverManager.getConnection(url, user, password);
		stmt = dbCon.createStatement();

		if (c == null) {

			String sql_N = "UPDATE home000_settings SET " + "Auto='N'" + " WHERE item='set_values'";
			result = stmt.executeQuery(sql_N);
			
		}else if (c != null) {
			
			if (c.equals("Y")) {
				String c_On = request.getParameter("Celsius_On");
				String c_Off = request.getParameter("Celsius_Off");
				String h_On = request.getParameter("Humidity_On");
				String h_Off = request.getParameter("Humidity_Off");
				String p_On = request.getParameter("PM2_5_On");
				String p_Off = request.getParameter("PM2_5_Off");					
					
					StringBuilder temp=new StringBuilder("Auto='Y'");
					
					
					if(!c_On.equals(""))
						temp.append((temp.length()==0 ? "":",")+("Celsius_On=" + c_On));
					else
						temp.append((temp.length()==0 ? "":",")+("Celsius_On=" + null));
					
					if(!c_Off.equals(""))
						temp.append((temp.length()==0 ? "":",")+("Celsius_Off=" + c_Off));
					else
						temp.append((temp.length()==0 ? "":",")+("Celsius_Off=" + null));
					
					if(!h_On.equals(""))
						temp.append((temp.length()==0 ? "":",")+("Humidity_On=" + h_On));
					else
						temp.append((temp.length()==0 ? "":",")+("Humidity_On=" + null));					
					
					if(!h_Off.equals(""))
						temp.append((temp.length()==0 ? "":",")+("Humidity_Off=" + h_Off));
					else
						temp.append((temp.length()==0 ? "":",")+("Humidity_Off=" + null));					
					
					if(!p_On.equals(""))
						temp.append((temp.length()==0 ? "":",")+("PM2_5_On=" + p_On));
					else
						temp.append((temp.length()==0 ? "":",")+("PM2_5_On=" + null));					
					
					if(!p_Off.equals(""))
						temp.append((temp.length()==0 ? "":",")+("PM2_5_Off=" + p_Off));
					else
						temp.append((temp.length()==0 ? "":",")+("PM2_5_Off=" + null));
									
					// SQL
					String sql_Y = "UPDATE home000_settings SET " + temp
							+ " WHERE item='set_values'";
					System.out.print(sql_Y);
					result = stmt.executeQuery(sql_Y);
				//}
			}
		}
		
		sb.append("<TABLE style='border: 3px #cccccc solid;margin:0 auto;' border='1' cellpadding='10'><TR>");
		sb.append("<TH>自動開關</TH>");
		sb.append("<TH>溫度高於</TH>");
		sb.append("<TH>溫度低於</TH>");
		sb.append("<TH>濕度高於</TH>");
		sb.append("<TH>濕度低於</TH>");
		sb.append("<TH>PM2.5高於</TH>");
		sb.append("<TH>PM2.5低於</TH>");
		sb.append("</TR>");
		
		String query = "select * from home000_settings";
		
		// Execute a query
		Connection con = DriverManager.getConnection(url, user, password);
		PreparedStatement pstmt = con.prepareStatement(query);
		ResultSet rs = pstmt.executeQuery();
		
		while (rs.next()) {

			sb.append("<TR>");
			sb.append("<TD>");
			sb.append(rs.getString("Auto"));
			sb.append("</TD>");
			sb.append("<TD>");
			sb.append(rs.getString("Celsius_On"));
			sb.append("</TD>");
			sb.append("<TD>");
			sb.append(rs.getString("Celsius_Off"));
			sb.append("</TD>");
			sb.append("<TD>");
			sb.append(rs.getString("Humidity_On"));
			sb.append("</TD>");
			sb.append("<TD>");
			sb.append(rs.getString("Humidity_Off"));
			sb.append("</TD>");
			sb.append("<TD>");
			sb.append(rs.getString("PM2_5_On"));
			sb.append("</TD>");
			sb.append("<TD>");
			sb.append(rs.getString("PM2_5_Off"));
			sb.append("</TD>");
			sb.append("</TR>");
		}

		sb.append("</TABLE>\n<br><br><br>");
				
		String result_final = sb.toString();
		out.print(result_final);
	}%>
	
</body>
</html>