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

import flex.messaging.io.amf.ASObject;

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
	public Template getTemplate(String id) {
		Template t = templateRepository.getTemplate(id);
		return t;
	}

	@RemotingInclude
	@Transactional
	public void saveTemplate(Template o) throws IOException {
		Template t = new Template();
		templateRepository.saveTemplate(t);
	}
}