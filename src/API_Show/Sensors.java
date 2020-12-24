package API_Show;

public class Sensors {
	private String item;
	private Integer id; 
	private String celsius; 
	private String humidity;
	private String pm2_5;
	private String datetime;
	
	public Sensors(Integer id, String celsius, String humidity, String pm2_5, String datetime) {
		this.id = id;
		this.celsius = celsius;
		this.humidity = humidity;
		this.pm2_5 = pm2_5;
		this.datetime = datetime;
	}

	public Sensors(String item, String celsius, String humidity, String pm2_5) {
		this.item=item;
		this.celsius = celsius;
		this.humidity = humidity;
		this.pm2_5 = pm2_5;
	}
	
}
