package com.settinghead.wenwentu.service;

import com.settinghead.wenwentu.service.model.WordListTask;

public class WordListService {

	/**
	 * @param args
	 */
	public static void main(String[] args) {

		GroffleService<WordListTask> service = new GroffleService<WordListTask>(
				WordListTask.class);
		service.run(20);
	}

}
