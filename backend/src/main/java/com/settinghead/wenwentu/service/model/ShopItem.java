package com.settinghead.tyful.service.model;

public class ShopItem {
	private String url;
	private String imageUrl;
	private boolean requireGeneration = false;
	private String name;
	private String description;
	/**
	 * @return the url
	 */
	public String getUrl() {
		return url;
	}
	/**
	 * @param url the url to set
	 */
	public void setUrl(String url) {
		this.url = url;
	}
	/**
	 * @return the imageUrl
	 */
	public String getImageUrl() {
		return imageUrl;
	}
	/**
	 * @param imageUrl the imageUrl to set
	 */
	public void setImageUrl(String imageUrl) {
		this.imageUrl = imageUrl;
	}
	/**
	 * @return the requireGeneration
	 */
	public boolean getRequireGeneration() {
		return requireGeneration;
	}
	/**
	 * @param requireGeneration the requireGeneration to set
	 */
	public void setRequireGeneration(boolean requireGeneration) {
		this.requireGeneration = requireGeneration;
	}
	/**
	 * @return the name
	 */
	public String getName() {
		return name;
	}
	/**
	 * @param name the name to set
	 */
	public void setName(String name) {
		this.name = name;
	}
	/**
	 * @return the description
	 */
	public String getDescription() {
		return description;
	}
	/**
	 * @param description the description to set
	 */
	public void setDescription(String description) {
		this.description = description;
	}

}
