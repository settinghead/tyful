package com.settinghead.wenwentu.service.model;

import java.io.StringWriter;
import java.util.List;
import java.util.logging.Logger;

import org.codehaus.jackson.map.ObjectMapper;

public abstract class Task {
	protected Logger logger = Logger.getLogger(this.getClass().getName());

	public abstract String getKey();

	public abstract String perform();

	public abstract int getExpiration();
	
	protected String toJsonStr(List<ShopItem> l) {
		ObjectMapper mapper = new ObjectMapper();
		StringWriter sw = new StringWriter();
		try {
			mapper.writeValue(sw, l);
		} catch (Exception e) {
			logger.warning(e.getMessage());
		}
		return sw.toString();
	}
}
