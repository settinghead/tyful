package com.settinghead.wenwentu.service;

public class Task {
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
	 * @param token the token to set
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
	 * @param uid the uid to set
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
	 * @param userId the userId to set
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
	 * @param provider the provider to set
	 */
	public void setProvider(String provider) {
		this.provider = provider;
	}
}
