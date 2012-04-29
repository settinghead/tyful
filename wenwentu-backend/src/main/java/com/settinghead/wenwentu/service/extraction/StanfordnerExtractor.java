/**
 * 
 */
package com.settinghead.wenwentu.service.extraction;

import java.util.Collection;
import com.settinghead.wenwentu.service.model.WebArticle;
import com.settinghead.wenwentu.service.ner.StanfordNERInstance;

/**
 * @author settinghead
 * 
 */
public class StanfordnerExtractor extends ArticleExtractor {

	// private static BlockingQueue<String> tasks = new
	// LinkedBlockingQueue<String>();

	StanfordNERInstance ner = new StanfordNERInstance();

	public StanfordnerExtractor(WebArticle article) {
		super(article);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.settinghead.wenwentu.service.extraction.ArticleExtractor #extract()
	 */
	@Override
	protected void extractInternal() {
		String text = "";
		if (getArticle().getTitle() != null)
			text += getArticle().getTitle() + " ";
		if (getArticle().getMetaDescription() != null)
			text += getArticle().getMetaDescription() + " ";
		if (getArticle().getText() != null)
			text += getArticle().getText();
		Collection<String> entities = ner.getNamedEntities(text);
		for (String entity : entities)
			getArticle().addKeyword(entity, 1);
	}

}
