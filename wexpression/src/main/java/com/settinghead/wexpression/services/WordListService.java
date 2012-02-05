package com.settinghead.wexpression.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.flex.remoting.RemotingDestination;
import org.springframework.flex.remoting.RemotingInclude;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.googlecode.ehcache.annotations.Cacheable;
import com.settinghead.wexpression.data.WordList;
import com.settinghead.wexpression.data.WordListRepository;

@Repository
@RemotingDestination
public class WordListService {


	private WordListRepository wordListRepository;

	@Autowired
	public void setWordListRepository(WordListRepository repo) {
		this.wordListRepository = repo;
	}

	@RemotingInclude
	@Cacheable(cacheName = "wordListListRepository")
	@Transactional
	public WordList getWordList(String id) {
		WordList list = wordListRepository.getWordList(id);
		return list;

	}

}