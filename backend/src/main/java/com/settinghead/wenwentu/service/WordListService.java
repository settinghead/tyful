package com.settinghead.wenwentu.service;

import java.net.URI;
import java.net.URISyntaxException;
import java.util.List;
import java.util.Properties;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.logging.Logger;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringWriter;

import org.codehaus.jackson.JsonParseException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;

import com.restfb.types.Post;
import com.settinghead.wenwentu.service.model.Task;
import com.settinghead.wenwentu.service.model.Word;
import com.settinghead.wenwentu.service.model.WordListStatus;

import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;
import redis.clients.jedis.JedisPoolConfig;
import redis.clients.jedis.JedisPubSub;
import redis.clients.jedis.Protocol;

public class WordListService extends GroffleService {

	/**
	 * @param args
	 */
	public static void main(String[] args) {

		for (int i = 0; i < 20; i++)
			runWordListService();

		// Server server = new Server(Integer.valueOf(System.getenv("PORT")));
		// ServletContextHandler context = new ServletContextHandler(
		// ServletContextHandler.SESSIONS);
		// context.setContextPath("/");
		// server.setHandler(context);
		// context.addServlet(new ServletHolder(new WordListService()), "/*");
		// server.start();
		// server.join();
	}

	private static void runWordListService() {
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
						if ((message = jedis.lpop("q")) != null) {
							logger.info(message);
							ObjectMapper mapper = new ObjectMapper();
							Task task;
							try {
								task = mapper.readValue(message, Task.class);
								Jedis jedis2 = pool.getResource();
								String oldMessageStr = jedis2.get("wl_"
										+ task.getProvider() + "_");
								WordListStatus status = null;
								try {
									status = mapper.readValue(oldMessageStr,
											WordListStatus.class);
								} catch (Exception ex) {
								}

								if (oldMessageStr == null
										|| (status != null && status
												.getStatus().equals("pending"))) {
									jedis2.setex("wl_" + task.getProvider()
											+ "_" + task.getUid(), 600,
											"{\"status\":\"pending\"}");
									List<Post> messages = FacebookRetriever
											.getMessages(task.getUid(),
													task.getToken());
									List<Word> wordList = FacebookRetriever
											.parseWordList(task.getUid(),
													task.getToken(), messages);
									StringWriter sw = new StringWriter();
									mapper.writeValue(sw, wordList);
									jedis2.setex("wl_" + task.getProvider()
											+ "_" + task.getUid(), 14400,
											sw.toString());
									logger.info("wl_" + task.getProvider()
											+ "_" + task.getUid()
											+ " written to cache.");
								}
							} catch (Exception e) {
								logger.warning(e.getMessage());
							}
						}

						try {
							Thread.sleep(300);
						} catch (InterruptedException e) {
							logger.severe(e.getMessage());
						}

					}

				} catch (URISyntaxException e) {
					// URI couldn't be parsed. Handle exception
				} catch (IOException e) {
					// TODO Auto-generated catch block
					logger.severe(e.getMessage());
					System.exit(1);
				}
			}
		}).start();
	}
}
