/**
 * 
 */
package com.settinghead.wenwentu.service.extraction;

import com.settinghead.wenwentu.service.model.WebArticle;

/**
 * @author settinghead
 * 
 */
public class MauiExtractor extends ArticleExtractor {

	public MauiExtractor(WebArticle article) {
		super(article);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.settinghead.wenwentu.service.extraction.ArticleExtractor#extract()
	 */
	@Override
	protected void extractInternal() {

		try {
			MauiTTUWrapper.getInstance().extractTopics(getArticle());
		} catch (Exception e) {
			System.err.println(e.getMessage() + "; URL: "
					+ getArticle().getUrl());
		}
	}

}
