/**
 * 
 */
package com.settinghead.wexpression.data;

import org.hibernate.SessionFactory;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.googlecode.ehcache.annotations.Cacheable;

/**
 * @author settinghead
 * 
 */
@Repository
public class FacebookFriendListRepository {

	private SessionFactory sessionFactory;

	@Autowired
	public void setSessionFactory(SessionFactory factory) {
		sessionFactory = factory;
	}

	@Transactional
	public void saveFriendList(String clientId, FriendList friendList) {
		sessionFactory.getCurrentSession().save(friendList);
	}

	@Transactional
	public FriendList getFacebookFriends(String clientId) {

		return (FriendList) sessionFactory.getCurrentSession()
				.createQuery("from FriendList where id=?")
				.setString(0, clientId).list().get(0);

	}
}
