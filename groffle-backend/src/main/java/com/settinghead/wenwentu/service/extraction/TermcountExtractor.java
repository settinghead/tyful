/**
 * 
 */
package com.settinghead.wenwentu.service.extraction;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.util.Scanner;
import java.util.Set;
import java.util.Vector;

import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.util.Version;

import com.settinghead.wenwentu.service.model.TermCountTable;
import com.settinghead.wenwentu.service.model.WebArticle;

/**
 * @author settinghead
 * 
 */
public class TermcountExtractor extends ArticleExtractor {

	private static final int NUMBER_OF_KEYWORDS_FOR_URL = 15;
	private static final Version LUCENE_VERSION = Version.LUCENE_34;
	private static Set<?> STOP_WORDS;

	public TermcountExtractor(WebArticle article) {
		super(article);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * com.settinghead.wenwentu.service.extraction.ArticleExtractor#extract()
	 */
	@Override
	protected void extractInternal() {
		String text = "";
		if (getArticle().getTitle() != null)
			text += getArticle().getTitle() + " ";
		if (getArticle().getText() != null)
			text += getArticle().getText();

		getArticle().getKeywords().addAll(
				TermCountTable.getMostFrequentTerms(new StandardAnalyzer(
						LUCENE_VERSION, getStopWords()), text,
						NUMBER_OF_KEYWORDS_FOR_URL));
	}

	/**
	 * Loads a set of predefined stopwords from a local file used for document
	 * indexing.
	 * 
	 * @return the set of stopwords.
	 */
	public static Set<?> getStopWords() {
		if (STOP_WORDS == null) {
			Vector<String> words = new Vector<String>();
			InputStream input = TermcountExtractor.class
					.getResourceAsStream("/stopwords_1000.txt");

			Scanner sc = new Scanner(input);
			while (sc.hasNextLine()) {
				words.add(sc.nextLine());
			}
			sc.close();
			STOP_WORDS = org.apache.lucene.analysis.StopFilter.makeStopSet(
					LUCENE_VERSION, words);
		} else
			return STOP_WORDS;
		return STOP_WORDS;
	}

}
