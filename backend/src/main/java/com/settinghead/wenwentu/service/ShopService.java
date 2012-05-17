package com.settinghead.wenwentu.service;

import com.settinghead.wenwentu.service.model.ShopTask;

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
		for (int i = 0; i < 20; i++)
			service.runSingleServiceThread();
	}

}
