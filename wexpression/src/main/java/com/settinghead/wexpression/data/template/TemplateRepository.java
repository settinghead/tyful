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
	public void saveTemplate(Template template, byte[] data) {
		sessionFactory.getCurrentSession().save(template);
		System.out.println("Template saved: " + template.getId());
	}

	@Transactional
	@Cacheable(value = "templateCache")
	public Template getTemplate(String id) {
		return (Template) sessionFactory.getCurrentSession()
				.createQuery("from Template where id=?").setString(0, id)
				.list().get(0);
	}

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
