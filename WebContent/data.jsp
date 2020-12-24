<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>環境資料參考</title>
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
<div class="wrap">
	<h1>環境資料參考</h1>

	<button name="home" type="submit" onclick="location.href='index.jsp'">回首頁</button></div>
	<br>
	<br>
	<%
		Connection dbCon = null;
		Statement stmt = null;
		ResultSet rs_all = null, rs_now = null;

		String sDriver = "org.mariadb.jdbc.Driver";
		String url = "jdbc:mariadb://localhost:3306/smart_home";
		String user = "wst";
		String password = "1qaz@wsx";
		StringBuilder sb = new StringBuilder();

		Class.forName(sDriver);
		dbCon = DriverManager.getConnection(url, user, password);
		stmt = dbCon.createStatement();

		Date dNow = new Date( );
	    SimpleDateFormat ft = new SimpleDateFormat ("yyyy-MM-dd");
	    String today = ft.format(dNow)+"%";
		String sql_all = "select * from home000_sensors";
		String sql_now = "(SELECT celsius,humidity,PM2_5 FROM home000_sensors WHERE datetime LIKE '"+today+"' ORDER BY id DESC LIMIT 1) "
				+ "UNION SELECT MAX(celsius),MAX(humidity),MAX(PM2_5) FROM home000_sensors WHERE datetime LIKE '"+today
				+ "' UNION SELECT MIN(celsius),MIN(humidity),MIN(PM2_5) FROM home000_sensors WHERE datetime LIKE '"+today
				+ "' UNION SELECT AVG(celsius),AVG(humidity),AVG(PM2_5) FROM home000_sensors WHERE datetime LIKE '"+today+"'";

		rs_now = stmt.executeQuery(sql_now);

		sb.append("<TABLE style='border: 3px #cccccc solid;margin:0 auto;' border='1' cellpadding='10'><TR>");
		sb.append("<TH colspan='4'>今日</TH></TR>");
		
		sb.append("<TR><TH></TH>");
		sb.append("<TH>溫度(攝式)</TH>");
		sb.append("<TH>濕度(%)</TH>");
		sb.append("<TH>pm2.5(μg/m3)</TH></TR>");
		
		int itemCount=1;
		
		
		while (rs_now.next()) {
			
			switch (itemCount) {
			case 1:
				sb.append("<TR><TH>現在</TH>");
				
				break;
			case 2:
				sb.append("<TR><TH>最高</TH>");
				break;
			case 3:
				sb.append("<TR><TH>最低</TH>");
				break;
			case 4:
				sb.append("<TR><TH>平均</TH>");
				break;
			}
			sb.append("<TD>");
			sb.append(rs_now.getFloat("celsius"));
			sb.append("</TD>");
			sb.append("<TD>");
			sb.append(rs_now.getFloat("humidity"));
			sb.append("</TD>");
			sb.append("<TD>");
			sb.append(rs_now.getFloat("PM2_5"));
			sb.append("</TD>");
			sb.append("</TR>");
			itemCount++;
		}
		
		sb.append("</TABLE>\n<br><br><br>");

		rs_all = stmt.executeQuery(sql_all);

		sb.append("<TABLE style='border: 3px #cccccc solid;margin:0 auto;' border='1' cellpadding='10'><TR>");
		sb.append("<TH>編號</TH>");
		sb.append("<TH>日期</TH>");
		sb.append("<TH>溫度(攝式)</TH>");
		sb.append("<TH>濕度(%)</TH>");
		sb.append("<TH>pm2.5(μg/m3)</TH>");
		sb.append("</TR>");

		while (rs_all.next()) {

			sb.append("<TD>");
			sb.append(rs_all.getInt("id"));
			sb.append("</TD>");
			sb.append("<TD>");
			sb.append(rs_all.getDate("datetime"));
			sb.append("</TD>");
			sb.append("<TD>");
			sb.append(rs_all.getFloat("celsius"));
			sb.append("</TD>");
			sb.append("<TD>");
			sb.append(rs_all.getFloat("humidity"));
			sb.append("</TD>");
			sb.append("<TD>");
			sb.append(rs_all.getFloat("PM2_5"));
			sb.append("</TD>");

			sb.append("</TR>");
		}

		sb.append("</TABLE>\n<br><br><br>");

		String result = sb.toString();
		out.print(result);
	%>

</body>
</html>