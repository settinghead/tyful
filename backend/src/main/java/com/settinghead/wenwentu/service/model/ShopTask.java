package com.settinghead.wenwentu.service.model;

import java.util.List;


public class ShopTask extends Task {

	private int userId;
	private String templateId;

	/**
	 * @return the userId
	 */
	public int getUserId() {
		return userId;
	}

	/**
	 * @param userId
	 *            the userId to set
	 */
	public void setUserId(int userId) {
		this.userId = userId;
	}

	/**
	 * @return the templateId
	 */
	public String getTemplateId() {
		return templateId;
	}

	/**
	 * @param templateId
	 *            the templateId to set
	 */
	public void setTemplateId(String templateId) {
		this.templateId = templateId;
	}

	@Override
	public String getKey() {
		return "shop_" + this.getUserId() + "_" + this.getTemplateId();
	}

	@Override
	public String perform() {
		List<ShopItem> shop = ShopPredictor.getShop(this.getUserId(),
				this.getTemplateId());
		return toJsonStr(shop);
	}

	@Override
	public int getExpiration() {
		return 86400;
	}
}
