package com.settinghead.wenwentu.service.task;

import java.util.logging.Logger;

public abstract class Task {
	protected Logger logger = Logger.getLogger(this.getClass().getName());

	public abstract String getKey();

	public abstract String perform() throws Exception;

	public abstract int getExpiration();
	
	
}
