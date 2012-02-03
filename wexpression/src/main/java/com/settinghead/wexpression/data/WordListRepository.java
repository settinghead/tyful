package com.settinghead.wexpression.data;

/**
 * 
 */

import org.hibernate.SessionFactory;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

/**
 * @author settinghead
 * 
 */
@Repository
public class WordListRepository {

	private SessionFactory sessionFactory;

	@Autowired
	public void setSessionFactory(SessionFactory factory) {
		sessionFactory = factory;
	}

	@Transactional
	public void saveWordList(WordList list) {
		// for (Word word : list.getList())
		// sessionFactory.getCurrentSession().save(word);
		sessionFactory.getCurrentSession().save(list);
	}

	@Transactional
	@Cacheable(value = "wordListCache")
	public WordList getWordList(String id) {
		return (WordList) sessionFactory.getCurrentSession()
				.createQuery("from WordList where id=?").setString(0, id)
				.list().get(0);
	}
}
