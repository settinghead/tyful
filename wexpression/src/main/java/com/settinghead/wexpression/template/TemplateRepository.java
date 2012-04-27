package com.settinghead.wexpression.template;

/**
 * 
 */

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

import org.apache.commons.io.IOUtils;
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
	private Logger logger = Logger.getLogger(this.getClass().getName());

	@Autowired
	public void setSessionFactory(SessionFactory factory) {
		sessionFactory = factory;
	}

	@Transactional
	public int saveTemplate(Template template, InputStream fileStream) {

		sessionFactory.getCurrentSession().save(template);
		FileOutputStream stream;
		// file size count
		int total = 0;

		try {
			stream = new FileOutputStream(idToTemplatePath(template.getId()));
			total = IOUtils.copy(fileStream, stream);
			stream.close();
			fileStream.close();

		} catch (FileNotFoundException e) {
			logger.severe(e.getMessage());
		} catch (IOException e) {
			logger.severe(e.getMessage());
		}

		logger.info("Template saved: " + template.getId());
		return total;
	}

	private String idToTemplatePath(String id) {

		return "/wexpression/templates/" + id + ".zip";
	}

	private String idToTemplatePreviewPath(String id) {

		return "/wexpression/templates/" + id + ".png";
	}

	@Transactional
	@Cacheable(value = "templateCache")
	public Template getTemplate(String id) {
		return (Template) sessionFactory.getCurrentSession()
				.createQuery("from Template where id=?").setString(0, id)
				.list().get(0);
	}

	@Transactional
	public InputStream getTemplateFile(String id) {
		FileInputStream stream = null;
		try {
			stream = new FileInputStream(idToTemplatePath(id));
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			logger.severe(e.getMessage());
		}
		return stream;
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

	public InputStream getTemplatePreview(String id) {
		File f = new File(idToTemplatePreviewPath(id));
		if (!f.exists()) {
			try {
				ZipFile file = new ZipFile(idToTemplatePath(id));
				ZipEntry e = null;
				if ((e = file.getEntry("/preview.png")) != null) {
					InputStream in = file.getInputStream(e);
					OutputStream out = new FileOutputStream(f);
					IOUtils.copy(in, out);
					out.close();
					in.close();
				}
			} catch (IOException e) {
				logger.severe(e.getMessage());
			}
		}

		try {
			return new FileInputStream(f);
		} catch (FileNotFoundException e) {
			logger.severe(e.getMessage());
			return null;
		}

	}
}
