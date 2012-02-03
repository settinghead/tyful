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
import com.settinghead.wexpression.data.FacebookFriendListRepository;
import com.settinghead.wexpression.data.FriendList;

@Repository
@RemotingDestination
public class FacebookFriendService {
	private SessionFactory sessionFactory;

	@Autowired
	public void setSessionFactory(SessionFactory factory) {
		sessionFactory = factory;
	}

	private FacebookFriendListRepository fbFriendListRepository;

	@Autowired
	public void setFacebookFriendListRepository(
			FacebookFriendListRepository repo) {
		this.fbFriendListRepository = repo;
	}

	@SuppressWarnings("unchecked")
	@RemotingInclude
	@Cacheable(cacheName = "facebookFriendListRepository")
	@Transactional
	public FriendList getFacebookFriends(String clientId) {

		return fbFriendListRepository.getFacebookFriends(clientId);

	}

}