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
		logger.info("Starting shop service. ");
		try {
			URI redisURI = new URI(System.getenv("REDISTOGO_URL"));
			final JedisPool pool = new JedisPool(new JedisPoolConfig(),
					redisURI.getHost(), redisURI.getPort(),
					Protocol.DEFAULT_TIMEOUT, redisURI.getUserInfo().split(":",
							2)[1]);
			Jedis jedis = pool.getResource();
			String dbStr = System.getenv("REDISTOGO_DB");
			if(dbStr!=null){
				jedis.select(Integer.parseInt(dbStr));
			}
			// set generic shop
			jedis.set("shop_generic", toJsonStr(ShopPredictor.getGenericShop()));

			try {
				while (true) {
					String message;
					while ((message = jedis.rpop("q_shop")) == null)
						Thread.sleep(300);
					logger.info(message);
					ObjectMapper mapper = new ObjectMapper();
					ShopTask task;
					try {
						task = mapper.readValue(message, ShopTask.class);
						List<ShopItem> shop = ShopPredictor.getShop(
								task.getUserId(), task.getTemplateId());
						String key = "shop_" + task.getUserId() + "_"
								+ task.getTemplateId();
						jedis.set(key, toJsonStr(shop));
						logger.info(key + "predicted.");
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

	private static String toJsonStr(List<ShopItem> l) {
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