package API_Show;

public class Home {
	private int id;
	private String schedule; 
	private int devices; 
	private String date; 
	private String weekday; 
	private String time; 
	private String onOff;
	
	public Home(int id, String schedule, int devices, String date, String weekday, String time, String onOff) {
		this.id = id;
		this.schedule = schedule;
		this.devices = devices;
		this.date = date;
		this.weekday = weekday;
		this.time = time;
		this.onOff = onOff;
	}	
}
