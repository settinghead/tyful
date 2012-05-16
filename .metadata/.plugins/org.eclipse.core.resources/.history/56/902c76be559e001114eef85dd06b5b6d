package com.settinghead.wenwentu.service;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;
import java.util.logging.Logger;

public class GroffleService {
	protected static Logger logger = Logger.getLogger(ShopService.class.getName());

	protected static Properties getPropertiesFromClasspath(String propFileName)
			throws IOException {
		// loading xmlProfileGen.properties from the classpath
		Properties props = new Properties();
		InputStream inputStream = GroffleService.class.getClassLoader()
				.getResourceAsStream(propFileName);

		if (inputStream == null) {
			throw new FileNotFoundException("property file '" + propFileName
					+ "' not found in the classpath");
		}

		props.load(inputStream);

		return props;
	}
}
