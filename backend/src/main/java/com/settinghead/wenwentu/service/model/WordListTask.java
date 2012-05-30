package com.settinghead.wenwentu.service.model;

import java.io.IOException;
import java.io.StringWriter;
import java.util.List;

import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;

import com.restfb.types.Post;
import com.settinghead.wenwentu.service.FacebookRetriever;

public class WordListTask extends Task {
	private String token;
	private String uid;
	private int user_id;
	private String provider;

	/**
	 * @return the token
	 */
	public String getToken() {
		return token;
	}

	/**
	 * @param token
	 *            the token to set
	 */
	public void setToken(String token) {
		this.token = token;
	}

	/**
	 * @return the uid
	 */
	public String getUid() {
		return uid;
	}

	/**
	 * @param uid
	 *            the uid to set
	 */
	public void setUid(String uid) {
		this.uid = uid;
	}

	/**
	 * @return the userId
	 */
	public int getUser_id() {
		return user_id;
	}

	/**
	 * @param userId
	 *            the userId to set
	 */
	public void setUser_id(int userId) {
		this.user_id = userId;
	}

	/**
	 * @return the provider
	 */
	public String getProvider() {
		return provider;
	}

	/**
	 * @param provider
	 *            the provider to set
	 */
	public void setProvider(String provider) {
		this.provider = provider;
	}

	@Override
	public String getKey() {
		return "wl_" + this.getProvider() + "_" + this.getUid();
	}

	@Override
	public String perform() {
		ObjectMapper mapper = new ObjectMapper();
		FacebookRetriever retriever = new FacebookRetriever();
		List<Word> wordList = retriever.getWordsForUser(this.getUid(), this.getToken());
		
		StringWriter sw = new StringWriter();
		try {
			mapper.writeValue(sw, wordList);
		} catch (Exception e){
		}
		return sw.toString();
	}

	@Override
	public int getExpiration() {
		return 14400;
	}
}
