package com.settinghead.wexpression.services;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.flex.remoting.RemotingDestination;
import org.springframework.flex.remoting.RemotingInclude;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.googlecode.ehcache.annotations.Cacheable;
import com.settinghead.wexpression.data.WordList;
import com.settinghead.wexpression.data.WordListRepository;
import com.settinghead.wexpression.data.template.Template;
import com.settinghead.wexpression.data.template.TemplateRepository;

@Repository
@RemotingDestination
public class TemplateService {

	private TemplateRepository templateRepository;

	@Autowired
	public void setTemplateRepository(TemplateRepository repo) {
		this.templateRepository = repo;
	}

	@RemotingInclude
	@Transactional
	public Object getTemplate(String id) {
		Template t = templateRepository.getTemplate(id);
		return toObject(t.getData());

	}

	@RemotingInclude
	@Transactional
	public void saveTemplate(Object o) throws IOException {
		Template t = new Template();
		t.setData(toByteArray(o));
		templateRepository.saveTemplate(t);
	}

	private byte[] toByteArray(Object obj) throws IOException{
		byte[] bytes = null;
		ByteArrayOutputStream bos = new ByteArrayOutputStream();
		try {
			ObjectOutputStream oos = new ObjectOutputStream(bos);
			oos.writeObject(obj);
			oos.flush();
			oos.close();
			bos.close();
			bytes = bos.toByteArray();
		} catch (IOException ex) {
			throw ex;
		}
		return bytes;
	}

	private Object toObject(byte[] bytes) {
		Object obj = null;
		try {
			ByteArrayInputStream bis = new ByteArrayInputStream(bytes);
			ObjectInputStream ois = new ObjectInputStream(bis);
			obj = ois.readObject();
		} catch (IOException ex) {
			// TODO: Handle the exception
		} catch (ClassNotFoundException ex) {
			// TODO: Handle the exception
		}
		return obj;
	}
}