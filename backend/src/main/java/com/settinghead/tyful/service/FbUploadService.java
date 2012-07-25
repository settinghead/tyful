package com.settinghead.tyful.service;

import com.settinghead.tyful.service.task.FbUploadTask;

public class FbUploadService {

	/**
	 * @param args
	 */
	public static void main(String[] args) {

		TyfulService<FbUploadTask> service = new TyfulService<FbUploadTask>(
				FbUploadTask.class);
		service.run(20);
	}

}
