package com.settinghead.wexpression.services;

import java.util.ArrayList;
import java.util.List;

import javax.inject.Inject;

import org.hibernate.SessionFactory;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.flex.remoting.RemotingDestination;
import org.springframework.flex.remoting.RemotingInclude;
import org.springframework.social.connect.ConnectionRepository;
import org.springframework.social.facebook.api.Facebook;
import org.springframework.social.facebook.api.Reference;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.googlecode.ehcache.annotations.Cacheable;
import com.settinghead.wexpression.data.Word;
import com.settinghead.wexpression.data.WordList;
import com.settinghead.wexpression.data.WordListRepository;
import com.settinghead.wexpression.data.FriendList;

@Repository
@RemotingDestination
public class WordListService {
	private SessionFactory sessionFactory;

	@Autowired
	public void setSessionFactory(SessionFactory factory) {
		sessionFactory = factory;
	}

	private WordListRepository wordListRepository;

	@Autowired
	public void setWordListRepository(WordListRepository repo) {
		this.wordListRepository = repo;
	}

	@SuppressWarnings("unchecked")
	@RemotingInclude
	@Cacheable(cacheName = "wordListListRepository")
	@Transactional
	public WordList getWordList(String id) {
		WordList list = wordListRepository.getWordList(id);
		return list;

	}

}