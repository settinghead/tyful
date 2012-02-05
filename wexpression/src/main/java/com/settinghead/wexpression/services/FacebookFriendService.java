package com.settinghead.wexpression.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.flex.remoting.RemotingDestination;
import org.springframework.flex.remoting.RemotingInclude;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.googlecode.ehcache.annotations.Cacheable;
import com.settinghead.wexpression.data.FacebookFriendListRepository;
import com.settinghead.wexpression.data.FriendList;

@Repository
@RemotingDestination
public class FacebookFriendService {

	private FacebookFriendListRepository fbFriendListRepository;

	@Autowired
	public void setFacebookFriendListRepository(
			FacebookFriendListRepository repo) {
		this.fbFriendListRepository = repo;
	}

	@RemotingInclude
	@Cacheable(cacheName = "facebookFriendListRepository")
	@Transactional
	public FriendList getFacebookFriends(String clientId) {

		return fbFriendListRepository.getFacebookFriends(clientId);

	}

}