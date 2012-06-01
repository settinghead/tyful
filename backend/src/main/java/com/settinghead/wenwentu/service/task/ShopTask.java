package com.settinghead.wenwentu.service.task;

import java.util.List;

import com.settinghead.wenwentu.service.model.ShopItem;
import com.settinghead.wenwentu.service.model.ShopPredictor;


public class ShopTask extends Task {

	private String userId;
	private String templateId;

	/**
	 * @return the userId
	 */
	public String getUserId() {
		return userId;
	}

	/**
	 * @param userId
	 *            the userId to set
	 */
	public void setUserId(String userId) {
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
