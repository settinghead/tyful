/**
 * 
 */
package com.settinghead.wenwentu.service.extraction;

import java.util.Iterator;
import java.util.Set;

import org.arabidopsis.ahocorasick.AhoCorasick;
import org.arabidopsis.ahocorasick.SearchResult;

import com.settinghead.wenwentu.service.model.TermItem;
import com.settinghead.wenwentu.service.model.WebArticle;

/**
 * @author settinghead
 * 
 */
public class RescorekeywordExtractor extends ArticleExtractor {

	/**
	 * @param article
	 */
	public RescorekeywordExtractor(WebArticle article) {
		super(article);
		// TODO Auto-generated constructor stub
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.settinghead.wenwentu.service.extraction.ArticleExtractor#extract()
	 */
	@Override
	protected void extractInternal() {
		AhoCorasick tree = new AhoCorasick();
		Iterator<TermItem> iterator = getArticle().getKeywords().iterator();
		while (iterator.hasNext()) {
			TermItem term = iterator.next();
			String key = term.getKey();
			tree.add(key.getBytes(), key.getBytes());
		}
		getArticle().getKeywords().clear();
		tree.prepare();
		byte[] bytes = getArticle().getText().toLowerCase().getBytes();
		Iterator<SearchResult> rIterator = tree.search(bytes);
		while (rIterator.hasNext()) {
			SearchResult r = rIterator.next();
			Set outputs = r.getOutputs();
			String keyword = new String((byte[]) outputs.iterator().next())
					.trim().intern();
			// check boundaries
			if (keyword.length() > 0
					&& (r.getLastIndex() >= bytes.length || !Character
							.isLetterOrDigit((char) bytes[r.getLastIndex()]))
					&& (r.getLastIndex() - keyword.length() - 1 < 0 || !Character
							.isLetterOrDigit((char) bytes[r.getLastIndex()
									- keyword.length() - 1])))
				getArticle().getKeywords().addScore(keyword, 1);
		}
	}
}
