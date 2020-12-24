<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.io.*"%>
<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">

  <title>手動設定電器開關</title>

<style>

.wrap{
	text-align: center;
}
.container{
  margin:0 auto;
  width: 600px;
}

/* toggle in label designing */
.toggle {
	position: relative;
	display: inline-block;
	width: 80px;
	height: 40px;
	background-color: red;
	border-radius: 30px;
	border: 1px solid gray;
}

/* After slide changes */
.toggle:after {
	content: '';
	position: absolute;
	width: 40px;
	height: 40px;
	border-radius: 50%;
	background-color: gray;
	top: 1px;
	left: 1px;
	transition: all 0.5s;
}

/* Toggle text */
p {
	font-family: Arial, Helvetica, sans-serif;
	font-weight: bold;
}

/* Checkbox cheked effect */
.checkbox:checked+.toggle::after {
	left: 39px;
}

/* Checkbox cheked toggle label bg color */
.checkbox:checked+.toggle {
	background-color: green;
}

/* Checkbox vanished */
.checkbox {
	display: none;
}
</style>

</head>

<body>

<div class="wrap">

	<h2>手動設定電器開關</h2>
	<h3>
		請選擇電器並填入適當的值
		</h3>
		
		<br>

		<form name="f1" method="get" action="#">
			<select name="mec">
				<option value="-1">請選擇</option>
				<option value="0">冷氣機</option>
				<option value="1">除濕機</option>
				<option value="2">空氣清淨機</option>
			</select> 
			<input type="checkbox" name="switch" id="switch" class="checkbox" checked="checked" value="Y"/>
			<label for="switch" class="toggle"><p>OFF&nbsp;&nbsp;ON</p> </label>
			<br></div>
			<div class="container">
			<br> <input type="radio" name="set" value="Only"> <label>僅止一次</label><br>
			<br> <input type="radio" name="set" value="dat"> <label>日期&nbsp;</label><input
				type="date" name="da"><br>
			<br> <input type="radio" name="set" value="rep"> <label>重覆</label>&nbsp;
			<input type="checkbox" name="sun" value="Sun"><label>
				星期日</label> <input type="checkbox" name="mon" value="Mon"><label>
				星期一</label> <input type="checkbox" name="tue" value="Tue"><label>
				星期二</label> <input type="checkbox" name="wen" value="Wen"><label>
				星期三</label> <input type="checkbox" name="thu" value="Thu"><label>
				星期四</label> <input type="checkbox" name="fri" value="Fri"><label>
				星期五</label> <input type="checkbox" name="sat" value="Sat"><label>
				星期六</label><br>
			<br></div>
			<div class="wrap">
			<table style='border: 3px #cccccc solid;margin:auto' border='1' cellpadding='10' >
				<caption>設定時間</caption>
				<tr>
					<th>開啟時間</th>
					<th>關閉時間</th>
				</tr>
				<tr>
					<td><input type=time name="on_time" /></td>
					<td><input type=time name="off_time" /></td>
				</tr>
			</table>
			<br>
			<br> <input type='hidden' name='begin' value='ok' /> <input
				type="reset" value="取消"> <input type="submit" value="設定">
		</form>
		<br>
		<br>

		<button name="home" type="submit" onclick="location.href='index.jsp'">回首頁</button><br><br></div>

		<%
			String begin = request.getParameter("begin");
			String toggle = request.getParameter("switch");

			String sDriver = "org.mariadb.jdbc.Driver";
			String url = "jdbc:mariadb://localhost:3306/smart_home";
			String user = "wst";
			String password = "1qaz@wsx";

			if (begin != null) {

				String mec = request.getParameter("mec");//0,1,2
				String c = request.getParameter("set");
				String d = request.getParameter("da");
				String on_time = request.getParameter("on_time");//17:20
				String off_time = request.getParameter("off_time");//17:20

				Connection dbCon = null;
				Statement stmt = null;
				ResultSet result = null;
				String query = null;

				StringBuilder sb = new StringBuilder();

				Class.forName(sDriver);
				dbCon = DriverManager.getConnection(url, user, password);
				stmt = dbCon.createStatement();

				if (c!=null && c.equals("Only")) {//out.print(c);//"Only"
					if (!on_time.isEmpty()) {
						query = "INSERT INTO home000 (schedule, devices, Date, weekday, Time, switch) VALUES ('enable',"
								+ mec + "," + "null,'Only','" + on_time + "','On')";
						System.out.println(query);
						result = stmt.executeQuery(query);
					}
					if (!off_time.isEmpty()) {
						query = "INSERT INTO home000 (schedule, devices, Date, weekday, Time, switch) VALUES ('enable',"
								+ mec + "," + "null,'Only','" + off_time + "','Off')";
						System.out.println(query);
						result = stmt.executeQuery(query);
					}

				} else if (c!=null && c.equals("dat")) {//out.print(c);//"dat"//out.print(d);//2020-12-16
					if (!on_time.isEmpty()) {
						query = "INSERT INTO home000 (schedule, devices, Date, weekday, Time, switch) VALUES ('enable',"
								+ mec + ",'" + d + "',null,'" + on_time + "','On')";
						System.out.println(query);
						result = stmt.executeQuery(query);
					}
					if (!off_time.isEmpty()) {
						query = "INSERT INTO home000 (schedule, devices, Date, weekday, Time, switch) VALUES ('enable',"
								+ mec + ",'" + d + "',null,'" + off_time + "','Off')";
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
						query = "INSERT INTO home000 (schedule, devices, Date, weekday, Time, switch) VALUES ('enable',"
								+ mec + ",null,'" + sb + "','" + rep_on_time + "','On')";
						System.out.println(query);
						result = stmt.executeQuery(query);
					}
					if (!rep_off_time.isEmpty()) {
						query = "INSERT INTO home000 (schedule, devices, Date, weekday, Time, switch) VALUES ('enable',"
								+ mec + ",null,'" + sb + "','" + rep_off_time + "','Off')";
						System.out.println(query);
						result = stmt.executeQuery(query);
					}

				}else if(toggle!=null && toggle.equals("Y")){					
					query = "UPDATE home000 SET schedule='enable',devices=" + mec 
							+ ",weekday='Now',switch='On' WHERE id=" + mec;
					//out.print(query);
					result = stmt.executeQuery(query);
				}else{
					query = "UPDATE home000 SET schedule='enable',devices=" + mec 
							+ ",weekday='Now',switch='Off' WHERE id=" + mec;
					//out.print(query);
					result = stmt.executeQuery(query);
				}
				
				String sql_device = "select * from home000"+" WHERE devices="+mec;
				result = stmt.executeQuery(sql_device);
				StringBuilder result_sql = new StringBuilder();
				
				result_sql.append("<div class='wrap'><TABLE style='border: 3px #cccccc solid;margin:auto' border='1' cellpadding='10'><TR>");
				result_sql.append("<TH>編號</TH>");
				result_sql.append("<TH>排程啟用/關閉</TH>");
				result_sql.append("<TH>家電</TH>");
				result_sql.append("<TH>日期</TH>");
				result_sql.append("<TH>重覆</TH>");
				result_sql.append("<TH>時間</TH>");
				result_sql.append("<TH>電器開關</TH>");
				result_sql.append("</TR>");
				
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
						
						result_sql.append("<TR><TD>");
						result_sql.append(result.getInt("id"));
						result_sql.append("</TD>");
						result_sql.append("<TD>");
						result_sql.append(result.getString("schedule"));
						result_sql.append("</TD>");
						
						result_sql.append("<TD>");
						result_sql.append(machine);
						result_sql.append("</TD>");
						
						result_sql.append("<TD>");
						if(result.getString("Date")==null){
							result_sql.append("");
						}else{
							result_sql.append(result.getString("Date"));
						}
						result_sql.append("</TD>");
						result_sql.append("<TD>");
						if(result.getString("weekday")==null){
							result_sql.append("");
						}else{
							result_sql.append(result.getString("weekday"));
						}
						result_sql.append("</TD>");
						result_sql.append("<TD>");
						result_sql.append(result.getString("Time"));
						result_sql.append("</TD>");
						result_sql.append("<TD>");
						result_sql.append(result.getString("switch"));
						result_sql.append("</TD></TR>");

					}
					
				}
				result_sql.append("</TABLE>\n<br><br><br></div>");
				String result_final = result_sql.toString();
				out.print(result_final);
				
			}
			
		%>
	
</body>
</html>