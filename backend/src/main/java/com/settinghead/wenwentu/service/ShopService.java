package com.settinghead.tyful.service;

import com.settinghead.tyful.service.task.ShopTask;

public class ShopService {

	/**
	 * 
	 */

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		TyfulService<ShopTask> service = new TyfulService<ShopTask>(
				ShopTask.class);
			service.run(20);
	}

}
