package com.settinghead.tyful.service;

import com.settinghead.tyful.service.task.WordListTask;

public class WordListService {

	/**
	 * @param args
	 */
	public static void main(String[] args) {

		TyfulService<WordListTask> service = new TyfulService<WordListTask>(
				WordListTask.class);
		service.run(20);
	}

}
