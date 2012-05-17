package com.settinghead.wenwentu.service;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringWriter;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.List;
import java.util.Properties;
import java.util.logging.Logger;

import org.codehaus.jackson.map.ObjectMapper;

import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;
import redis.clients.jedis.JedisPoolConfig;
import redis.clients.jedis.Protocol;

import com.restfb.types.Post;
import com.settinghead.wenwentu.service.model.Task;
import com.settinghead.wenwentu.service.model.Word;
import com.settinghead.wenwentu.service.model.WordListStatus;
import com.settinghead.wenwentu.service.model.WordListTask;

public class GroffleService<T extends Task> {
	protected Logger logger = Logger.getLogger(this.getClass().getName());
	private Class<T> taskType;

	public GroffleService(Class<T> taskType) {
		this.taskType = taskType;
	}

	public void runSingleServiceThread() {
		logger.info("Starting word list service. ");
		new Thread(new Runnable() {

			@Override
			public void run() {
				try {
					String env = System.getenv("RAILS_ENV");
					if (env == null)
						env = "development";
					Properties props = getPropertiesFromClasspath("redis."
							+ env + ".properties");
					URI redisURI = new URI(props.getProperty("REDISTOGO_URL"));

					final JedisPool pool = new JedisPool(new JedisPoolConfig(),
							redisURI.getHost(), redisURI.getPort(),
							Protocol.DEFAULT_TIMEOUT,
							redisURI.getUserInfo() == null ? null : redisURI
									.getUserInfo().split(":", 2)[1]);

					Jedis jedis = pool.getResource();
					String dbStr = props.getProperty("REDISTOGO_DB");
					if (dbStr != null) {
						jedis.select(Integer.parseInt(dbStr));
						logger.info("DB: " + dbStr);
					}
					while (true) {
						String message;
						if ((message = jedis.lpop(taskType.getSimpleName()
								.toLowerCase() + "_q")) != null) {
							logger.info(message);
							ObjectMapper mapper = new ObjectMapper();
							T task = null;
							String key = null;
							try {
								task = mapper.readValue(message, taskType);
								key = task.getKey();
								String oldMessageStr = jedis.get(key);

								if (oldMessageStr == null) {
									jedis.setex(key, 600,
											"{\"status\":\"pending\"}");
									String result = task.perform();
									jedis.setex(key, task.getExpiration(),
											result);
									logger.info(key + " written to cache.");
								}
							} catch (Exception e) {
								logger.warning(e.getMessage());
								e.printStackTrace();
								if (task != null && key != null)
									jedis.del(key);
							}
						}

						try {
							Thread.sleep(300);
						} catch (InterruptedException e) {
							logger.severe(e.getMessage());
						}

					}

				} catch (URISyntaxException e) {
					logger.severe(e.getMessage());
					System.exit(1);
				} catch (IOException e) {
					logger.severe(e.getMessage());
					System.exit(1);
				}
			}
		}).start();
	}

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
