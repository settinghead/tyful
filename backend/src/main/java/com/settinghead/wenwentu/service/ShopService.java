package com.settinghead.wenwentu.service;

import com.settinghead.wenwentu.service.task.ShopTask;

public class ShopService {

	/**
	 * 
	 */

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		GroffleService<ShopTask> service = new GroffleService<ShopTask>(
				ShopTask.class);
			service.run(20);
	}

}
