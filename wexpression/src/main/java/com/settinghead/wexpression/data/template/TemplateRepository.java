package com.settinghead.wexpression.data.template;

/**
 * 
 */

import java.util.ArrayList;
import java.util.List;

import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.settinghead.wexpression.services.TemplateService;

import flex.messaging.io.amf.ASObject;

/**
 * @author settinghead
 * 
 */
@Repository
public class TemplateRepository {

	private SessionFactory sessionFactory;

	@Autowired
	public void setSessionFactory(SessionFactory factory) {
		sessionFactory = factory;
	}

	@Transactional
	public void saveTemplate(Template list) {
		// for (Word word : list.getList())
		// sessionFactory.getCurrentSession().save(word);
		sessionFactory.getCurrentSession().save(list);
		System.out.println("Template saved: " + list.getId());
	}

	@Transactional
	@Cacheable(value = "templateCache")
	public Template getTemplate(String id) {
		return (Template) sessionFactory.getCurrentSession()
				.createQuery("from Template where id=?").setString(0, id)
				.list().get(0);
	}

	@SuppressWarnings("unchecked")
	@Transactional
	public List<Template> getAllTemplates() {
		List<Template> result = new ArrayList<Template>();
		for (Object o : sessionFactory.getCurrentSession()
				.createQuery("from Template").list()) {
			result.add((Template) o);
		}
		return result;
	}
}
