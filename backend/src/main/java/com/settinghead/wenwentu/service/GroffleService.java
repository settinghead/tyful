package com.settinghead.wenwentu.service;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.Properties;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.logging.Logger;

import org.codehaus.jackson.map.ObjectMapper;

import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;
import redis.clients.jedis.JedisPoolConfig;
import redis.clients.jedis.Protocol;

import com.settinghead.wenwentu.service.task.Task;

public class GroffleService<T extends Task> {
	protected Logger logger = Logger.getLogger(this.getClass().getName());
	private Class<T> taskType;
	private boolean SIGTERM = false;
	private AtomicInteger activeThreadCount = new AtomicInteger();

	public GroffleService(Class<T> taskType) {
		this.taskType = taskType;
		Runtime.getRuntime().addShutdownHook(new Thread(new Runnable() {
			@Override
			public void run() {
				SIGTERM = true;
			}
		}));
	}

	private void runSingleServiceThread() {
		logger.info("Starting " + taskType.getSimpleName() + " service. ");
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
					activeThreadCount.incrementAndGet();
					while (!SIGTERM) {
						Jedis jedis = pool.getResource();
						String dbStr = props.getProperty("REDISTOGO_DB");
						if (dbStr != null) {
							jedis.select(Integer.parseInt(dbStr));
							// logger.info("DB: " + dbStr);
						}
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
									if (key != null) {

										if (task.getExpiration() > 0)
											jedis.setex(key,
													task.getExpiration(),
													result);
										else
											jedis.set(key, result);

										logger.info(key + " written to cache.");
									}
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
						pool.returnResource(jedis);
					}
					activeThreadCount.decrementAndGet();

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

	public boolean stillActive() {
		return (!SIGTERM || activeThreadCount.get() > 0);
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

	public void run(int numThreads) {
		for (int i = 0; i < numThreads; i++)
			this.runSingleServiceThread();
		while (stillActive())
			try {
				Thread.sleep(500);
			} catch (InterruptedException e) {
				logger.severe(e.getMessage());
				System.exit(1);
			}
		System.exit(0);
	}

}
