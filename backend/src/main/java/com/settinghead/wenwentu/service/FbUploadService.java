package com.settinghead.wenwentu.service;

import com.settinghead.wenwentu.service.task.FbUploadTask;

public class FbUploadService {

	/**
	 * @param args
	 */
	public static void main(String[] args) {

		GroffleService<FbUploadTask> service = new GroffleService<FbUploadTask>(
				FbUploadTask.class);
		service.run(20);
	}

}
