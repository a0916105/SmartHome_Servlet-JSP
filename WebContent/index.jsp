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
<title>Smart Home</title>
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
	<h1>Smart Home</h1>

	<form name="f1" method="get" action="#">
		<select name="mec">
			<option value="-1">請選擇</option>
			<option value="0">冷氣機</option>
			<option value="1">除濕機</option>
			<option value="2">空氣清淨機</option>
		</select> <input type="submit" name="submit" value="選擇家電" />
		<br>
		
	</form>	
	
	<br>
	<br> 請選擇設定方式:
	<button name="auto" type="submit" onclick="self.location.href='auto.jsp'">自動</button>
	<button name="manual" type="submit" onclick="self.location.href='manual.jsp'">手動</button>	
	<br>
	<br>

	<a href="data.jsp" target="_blank">環境資料參考</a>
	</div>
	<br>
	<br>

	<%
		String s = request.getParameter("mec");
	String num = request.getParameter("number");
	System.out.println(num);
	if(num != null){
		Connection dbCon = null;
		Statement stmt = null;
		ResultSet result = null;

		String sDriver = "org.mariadb.jdbc.Driver";
		String url = "jdbc:mariadb://localhost:3306/smart_home";
		String user = "wst";
		String password = "1qaz@wsx";
		StringBuilder sb = new StringBuilder();

		Class.forName(sDriver);
		dbCon = DriverManager.getConnection(url, user, password);
		stmt = dbCon.createStatement();
		
		String c = request.getParameter("set");
		String d = request.getParameter("da");
		String on_time = request.getParameter("on_time");//17:20
		String off_time = request.getParameter("off_time");//17:20
		String query = null;

		if (c!=null && c.equals("Only")) {//out.print(c);//"Only"
			if (!on_time.isEmpty()) {
			query = "UPDATE home000 SET schedule='enable',devices=" + s + "," 
			+ "Date=null,weekday='Only',Time='" + on_time+"',"
			+ "switch='On'" + " WHERE id=" + num;
				System.out.println(query);
				result = stmt.executeQuery(query);
			}
			if (!off_time.isEmpty()) {
			query = "UPDATE home000 SET schedule='enable',devices=" + s + "," 
			+ "Date=null,weekday='Only',Time='" + off_time+"',"
			+ "switch='Off'" + " WHERE id=" + num;
				System.out.println(query);
				result = stmt.executeQuery(query);
			}

		} else if (c!=null && c.equals("dat")) {//out.print(c);//"dat"//out.print(d);//2020-12-16
			if (!on_time.isEmpty()) {
			query = "UPDATE home000 SET schedule='enable',devices=" + s + "," 
			+ "Date='" + d + "',weekday=null,Time='" + on_time+"',"
			+ "switch='On'" + " WHERE id=" + num;
				System.out.println(query);
				result = stmt.executeQuery(query);
			}
			if (!off_time.isEmpty()) {
			query = "UPDATE home000 SET schedule='enable',devices=" + s + "," 
			+ "Date='" + d + "',weekday=null,Time='" + off_time+"',"
			+ "switch='Off'" + " WHERE id=" + num;
				System.out.println(query);
				result = stmt.executeQuery(query);
			}
		} else if (c!=null && c.equals("rep")) {
			//out.print(c);//"rep"

			String w_sun = request.getParameter("sun");
			String w_mon = request.getParameter("mon");
			String w_tue = request.getParameter("tue");
			String w_wed = request.getParameter("wed");
			String w_thu = request.getParameter("thu");
			String w_fri = request.getParameter("fri");
			String w_sat = request.getParameter("sat");
			//out.print(w_sun);//Sun or null
			String rep_on_time = request.getParameter("on_time");//17:20
			String rep_off_time = request.getParameter("off_time");//17:20

			if (w_sun != null)
				sb.append(w_sun);
			if (w_mon != null)
				sb.append((sb.length() == 0 ? "" : ",") + w_mon);
			if (w_tue != null)
				sb.append((sb.length() == 0 ? "" : ",") + w_tue);
			if (w_wed != null)
				sb.append((sb.length() == 0 ? "" : ",") + w_wed);
			if (w_thu != null)
				sb.append((sb.length() == 0 ? "" : ",") + w_thu);
			if (w_fri != null)
				sb.append((sb.length() == 0 ? "" : ",") + w_fri);
			if (w_sat != null)
				sb.append((sb.length() == 0 ? "" : ",") + w_sat);

			if (!rep_on_time.isEmpty()) {
			query = "UPDATE home000 SET schedule='enable',devices=" + s + "," 
			+ "Date=null,weekday='" + sb + "',Time='" + rep_on_time+"',"
			+ "switch='On'" + " WHERE id=" + num;
				System.out.println(query);
				result = stmt.executeQuery(query);
			}
			if (!rep_off_time.isEmpty()) {
			query = "UPDATE home000 SET schedule='enable',devices=" + s + "," 
			+ "Date=null,weekday='" + sb + "',Time='" + rep_off_time+"',"
			+ "switch='Off'" + " WHERE id=" + num;
				System.out.println(query);
				result = stmt.executeQuery(query);
			}
		}
	}
		
		if (s != null) {
			out.print("<div class='wrap'><h3>輸入編號以修改排程</h3>");
			out.print("<form name='f1' method='get' action='#'>");
			out.print("<label>編號：</label> <input type='text' name='number'></div><br>");
			out.print("<br> <div class='container'><input type='radio' name='set' value='Only'> <label>僅止一次</label><br>");
			out.print("<br> <input type='radio' name='set' value='dat'> <label>日期&nbsp;</label><input type='date' name='da'><br>");
			out.print("<br> <input type='radio' name='set' value='rep'> <label>重覆</label>&nbsp;");
			out.print("<input type='checkbox' name='sun' value='Sun'><label>");
			out.print("星期日</label> <input type='checkbox' name='mon' value='Mon'><label>");
			out.print("星期一</label> <input type='checkbox' name='tue' value='Tue'><label>");
			out.print("星期二</label> <input type='checkbox' name='wen' value='Wen'><label>");
			out.print("星期三</label> <input type='checkbox' name='thu' value='Thu'><label>");
			out.print("星期四</label> <input type='checkbox' name='fri' value='Fri'><label>");
			out.print("星期五</label> <input type='checkbox' name='sat' value='Sat'><label>");
			out.print("星期六</label></div><br><br>");
			out.print("<div class='wrap'><table style='border: 3px #cccccc solid;margin:0 auto;' border='1' cellpadding='10'>");
			out.print("<caption>設定時間</caption>");
			out.print("<tr><th>開啟時間</th>");
			out.print("<th>關閉時間</th></tr>");
			out.print("<tr><td><input type=time name='on_time' /></td>");
			out.print("<td><input type=time name='off_time' /></td></tr>");
			out.print("</table><br><br> <input type='hidden' name='begin' value='ok' />");
			out.print("<input type='hidden' name='mec' value='"+s+"' />");
			out.print("<input type='reset' value='取消'> <input type='submit' value='設定'></form></div><br><br>");

			Connection dbCon = null;
			Statement stmt = null;
			ResultSet result = null;

			String sDriver = "org.mariadb.jdbc.Driver";
			String url = "jdbc:mariadb://localhost:3306/smart_home";
			String user = "wst";
			String password = "1qaz@wsx";
			StringBuilder sb = new StringBuilder();

			Class.forName(sDriver);
			dbCon = DriverManager.getConnection(url, user, password);
			stmt = dbCon.createStatement();

			Date dNow = new Date();
			SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
			String today = ft.format(dNow) + "%";
			String sql_device = "select * from home000"+" WHERE devices="+s;
			
			result = stmt.executeQuery(sql_device);
			
			sb.append("<form name=myname method=post action='API_Delete'>");
			sb.append("<TABLE style='border: 3px #cccccc solid;margin:0 auto;' border='1' cellpadding='10'><TR>");
			sb.append("<TH>編號</TH>");
			sb.append("<TH>排程啟用/關閉</TH>");
			sb.append("<TH>家電</TH>");
			sb.append("<TH>日期</TH>");
			sb.append("<TH>重覆</TH>");
			sb.append("<TH>時間</TH>");
			sb.append("<TH>電器開關</TH>");
			sb.append("<TH>刪除</TH>");
			sb.append("</TR>");
			
			while (result.next()) {
				int id = result.getInt("id");
				if (id >= 3) {
					
					int devices = result.getInt("devices");
					String machine="";
					
					switch (devices) {
					case 0:
						machine="冷氣機";
						break;
					case 1:
						machine="除濕機";
						break;
					case 2:
						machine="空氣清淨機";
						break;
					}
					
					sb.append("<TR><TD>");
					sb.append(id);
					sb.append("</TD>");
					sb.append("<TD>");
					sb.append(result.getString("schedule"));
					sb.append("</TD>");
					
					sb.append("<TD>");
					sb.append(machine);
					sb.append("</TD>");
					
					sb.append("<TD>");
					if(result.getString("Date")==null){
						sb.append("");
					}else{
					sb.append(result.getString("Date"));
					}
					sb.append("</TD>");
					sb.append("<TD>");
					if(result.getString("weekday")==null){
						sb.append("");
					}else{
						sb.append(result.getString("weekday"));
					}
					sb.append("</TD>");
					sb.append("<TD>");
					sb.append(result.getString("Time"));
					sb.append("</TD>");
					sb.append("<TD>");
					sb.append(result.getString("switch"));
					sb.append("</TD>");
					sb.append("<TD>");
					sb.append("<button type='submit' name='id' value='"+id+"'>刪除</button>");
					sb.append("</TD></TR>");

				}
				
			}
			sb.append("</TABLE><input type='hidden' name='mec' value='"+s+"' /></form>\n<br><br><br>");
			String result_final = sb.toString();
			out.print(result_final);
		}
	%>

</body>
</html>