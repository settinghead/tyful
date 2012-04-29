package com.settinghead.wenwentu.service;

import java.net.URI;
import java.net.URISyntaxException;
import java.util.List;
import java.util.logging.Logger;

import java.io.IOException;
import java.io.StringWriter;

import org.codehaus.jackson.JsonParseException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;

import com.restfb.types.Post;

import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;
import redis.clients.jedis.JedisPoolConfig;
import redis.clients.jedis.JedisPubSub;
import redis.clients.jedis.Protocol;

public class WordListService {

	/**
	 * 
	 */
	private static final long serialVersionUID = 7273080441350794168L;
	static Logger logger = Logger.getLogger(WordListService.class.getName());

	/**
	 * @param args
	 */
	public static void main(String[] args) {
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
					URI redisURI = new URI(System.getenv("REDISTOGO_URL"));
					final JedisPool pool = new JedisPool(new JedisPoolConfig(),
							redisURI.getHost(), redisURI.getPort(),
							Protocol.DEFAULT_TIMEOUT, redisURI.getUserInfo()
									.split(":", 2)[1]);
					Jedis jedis = pool.getResource();

					try {
						JedisPubSub jedissubSub = new JedisPubSub() {

							@Override
							public void onUnsubscribe(String channel,
									int subscribedChannels) {
								// TODO Auto-generated method stub

							}

							@Override
							public void onSubscribe(String channel,
									int subscribedChannels) {
								// TODO Auto-generated method stub

							}

							@Override
							public void onPUnsubscribe(String pattern,
									int subscribedChannels) {
								// TODO Auto-generated method stub

							}

							@Override
							public void onPSubscribe(String pattern,
									int subscribedChannels) {
								// TODO Auto-generated method stub

							}

							@Override
							public void onPMessage(String pattern,
									String channel, String message) {
								logger.info(message);
								ObjectMapper mapper = new ObjectMapper();
								Task task;
								try {
									task = mapper
											.readValue(message, Task.class);
									Jedis jedis2 = pool.getResource();
									if (jedis2.get("wl_" + task.getProvider()
											+ "_") == null) {
										List<Post> messages = FacebookRetriever
												.getMessages(task.getUid(),
														task.getToken());
										List<Word> wordList = FacebookRetriever
												.parseWordList(task.getUid(),
														task.getToken(),
														messages);
										StringWriter sw = new StringWriter();
										mapper.writeValue(sw, wordList);
										jedis2.set("wl_" + task.getProvider()
												+ "_" + task.getUid(),
												sw.toString());
										logger.info("wl_" + task.getProvider()
												+ "_" + task.getUid()
												+ " written to cache.");
									}
								} catch (Exception e) {
									logger.warning(e.getMessage());
								}

							}

							@Override
							public void onMessage(String channel, String message) {
							}
						};
						jedis.psubscribe(jedissubSub, "q_facebook");

					} finally {
						// / ... it's important to return the Jedis instance to
						// the pool
						// once you've finished using it
						pool.returnResource(jedis);
					}
				} catch (URISyntaxException e) {
					// URI couldn't be parsed. Handle exception
				}
			}
		}).run();
	}
}
