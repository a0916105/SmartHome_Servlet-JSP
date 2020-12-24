package API_Show;

public class Setting {
	private String item; 
	private String auto; 
	private String celsius_On; 
	private String celsius_Off; 
	private String humidity_On;
	private String humidity_Off;
	private String pm2_5_On;
	private String pm2_5_Off;
	private Integer ac,dh,ap;
	
	public Setting(String item, String auto, String celsius_On, String celsius_Off, String humidity_On,
			String humidity_Off, String pm2_5_On, String pm2_5_Off) {
		this.item = item;
		this.auto = auto;
		this.celsius_On = celsius_On;
		this.celsius_Off = celsius_Off;
		this.humidity_On = humidity_On;
		this.humidity_Off = humidity_Off;
		this.pm2_5_On = pm2_5_On;
		this.pm2_5_Off = pm2_5_Off;
	}

	public Setting(Integer ac, Integer dh, Integer ap) {
		this.ac=ac;
		this.dh=dh;
		this.ap=ap;
	}	
}
