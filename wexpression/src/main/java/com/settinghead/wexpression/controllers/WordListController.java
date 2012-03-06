package com.settinghead.wexpression.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.settinghead.wexpression.data.WordList;
import com.settinghead.wexpression.data.WordListRepository;

@Controller
@RequestMapping("/wordlists/**")
public class WordListController {
	private WordListRepository wordListRepository;

	@Autowired
	public void setWordListRepository(WordListRepository repo) {
		this.wordListRepository = repo;
	}
	
	@RequestMapping(value = "/{wordListId}", method = RequestMethod.GET, produces = {
		      MediaType.APPLICATION_JSON_VALUE })
	@ResponseBody
	public WordList home(@PathVariable String wordListId) {
		return this.wordListRepository.getWordList(wordListId);
	}
}
