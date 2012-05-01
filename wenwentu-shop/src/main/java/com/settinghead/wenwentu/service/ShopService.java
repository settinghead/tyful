package com.settinghead.wenwentu.service;

import java.net.URI;
import java.net.URISyntaxException;
import java.util.List;
import java.util.logging.Logger;

import java.io.StringWriter;

import org.codehaus.jackson.map.ObjectMapper;

import com.settinghead.wenwentu.service.model.ShopItem;
import com.settinghead.wenwentu.service.model.ShopTask;

import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;
import redis.clients.jedis.JedisPoolConfig;
import redis.clients.jedis.Protocol;

public class ShopService {

	/**
	 * 
	 */
	static Logger logger = Logger.getLogger(ShopService.class.getName());

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		runShopService();
	}

	private static void runShopService() {
		logger.info("Starting word list service. ");
		try {
			URI redisURI = new URI(System.getenv("REDISTOGO_URL"));
			final JedisPool pool = new JedisPool(new JedisPoolConfig(),
					redisURI.getHost(), redisURI.getPort(),
					Protocol.DEFAULT_TIMEOUT, redisURI.getUserInfo().split(":",
							2)[1]);
			Jedis jedis = pool.getResource();

			try {
				while (true) {
					String message;
					while ((message = jedis.rpop("shop_q")) == null)
						Thread.sleep(300);
					logger.info(message);
					ObjectMapper mapper = new ObjectMapper();
					ShopTask task;
					try {
						task = mapper.readValue(message, ShopTask.class);
						List<ShopItem> shop = ShopPredictor.getShop(task.getUserId(), task.getTemplateId());
						
							StringWriter sw = new StringWriter();
							mapper.writeValue(sw, shop);
							jedis.set(
									"shop_" + task.getUserId(), sw.toString());
							logger.info("shop_" + task.getUserId() + "predicted.");
					} catch (Exception e) {
						logger.warning(e.getMessage());
					}

				}

			} catch (InterruptedException e) {
				logger.warning(e.getMessage());
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
}
