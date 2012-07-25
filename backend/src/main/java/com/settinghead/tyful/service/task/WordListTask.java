package com.settinghead.tyful.service.task;

import java.io.StringWriter;
import java.util.List;

import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.map.annotate.JsonSerialize.Inclusion;

import com.settinghead.tyful.service.FacebookRetriever;
import com.settinghead.tyful.service.model.Word;

public class WordListTask extends Task {
	private String token;
	private String uid;
	private int user_id;
	private String provider;
	private String targetId;

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
		return "wl_" + this.getProvider() + "_" + this.getUid() + "_"
				+ this.getTargetId();
	}

	@Override
	public String perform() throws Exception {
		ObjectMapper mapper = new ObjectMapper();
		mapper.setSerializationInclusion(Inclusion.NON_NULL);

		FacebookRetriever retriever = new FacebookRetriever();
		List<Word> wordList = retriever.getWordsForUser(this.getTargetId(),
				this.getUid(), this.getToken());

		StringWriter sw = new StringWriter();
		try {
			mapper.writeValue(sw, wordList);
		} catch (Exception e) {
		}
		return sw.toString();
	}

	/**
	 * @return the targetId
	 */
	public String getTargetId() {
		return targetId;
	}

	/**
	 * @param targetId
	 *            the targetId to set
	 */
	public void setTargetId(String targetId) {
		this.targetId = targetId;
	}

	@Override
	public int getExpiration() {
		// expires in 24 hours
		return 86400;
	}

}