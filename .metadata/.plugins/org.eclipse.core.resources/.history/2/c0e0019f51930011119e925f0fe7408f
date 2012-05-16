/**
 * 
 */
package com.settinghead.wenwentu.service.model;

import java.io.Serializable;
import java.net.URL;
import java.util.HashSet;
import java.util.Set;

import org.codehaus.jackson.map.ObjectMapper;

import static com.settinghead.wenwentu.service.extraction.util.ExtractionHelpers.*;

/**
 * @author Xiyang Chen
 * 
 */
public class WebArticle implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 7491509728018079738L;
	private URL url;
	private String text;
	private String title;
	private TermCountTable keywords = new TermCountTable();
	private String thumbnailSrc;
	private String metaDescription;
	private String[] metaKeywords;
	private String rawHtml = null;
	private Set<String> extractorSignatures = new HashSet<String>();
	private boolean pendingChangeFlag;
	static ObjectMapper mapper = new ObjectMapper();

	public WebArticle(URL url) {
		setUrl(url);
	}

	public WebArticle() {
	}

	/**
	 * @return the url
	 */
	public URL getUrl() {
		return url;
	}

	/**
	 * @param url
	 *            the url to set
	 */
	public void setUrl(URL url) {
		this.url = url;
	}

	/**
	 * @return the text
	 */
	public String getText() {
		return text;
	}

	/**
	 * @param text
	 *            the text to set
	 */
	public void competeSetText(String text) {
		if (this.text == null || this.text.length() < text.length())
			this.text = text;
	}

	/**
	 * @return the title
	 */
	public String getTitle() {
		return title;
	}

	/**
	 * @param title
	 *            the title to set
	 */
	public void setTitle(String title) {
		this.title = title;

	}

	/**
	 * @return the keywords
	 */
	public TermCountTable getKeywords() {
		return keywords;
	}

	/**
	 * @param keywords
	 *            the keywords to set
	 */
	public void addKeyword(String keyword, double score) {
		this.keywords.addScore(keyword, score);
	}

	public void setMetaDescription(String metaDescription) {
		this.metaDescription = metaDescription;
	}

	public void setMetaKeywords(String metaKeywords) {
		this.metaKeywords = splitKeywords(metaKeywords);
	}

	/**
	 * @return the thumbnailSrc
	 */
	public String getThumbnailSrc() {
		return thumbnailSrc;
	}

	/**
	 * @param thumbnailSrc
	 *            the thumbnailSrc to set
	 */
	public void setThumbnailSrc(String thumbnailSrc) {
		this.thumbnailSrc = thumbnailSrc;
	}

	/**
	 * @return the metaDescription
	 */
	public String getMetaDescription() {
		return metaDescription;
	}

	/**
	 * @return the metaKeywords
	 */
	public String[] getMetaKeywords() {
		return metaKeywords;
	}

	public String toJsonString() {
		try {
			return mapper.writeValueAsString(this);
		} catch (Exception e) {
			return "{}";
		}
	}

	@Override
	public String toString() {
		return toJsonString();
	}

	public void setRawHtml(String rawHtml) {
		this.rawHtml = rawHtml;
	}

	public String getRawHtml() {
		return this.rawHtml;
	}

	public Set<String> getExtractorSignatures() {
		return extractorSignatures;
	}

	public void clearText() {
		this.text = null;
	}

	public void clearRawHtml() {
		this.rawHtml = null;
	}

	public void setPendingChangeFlag(boolean b) {
		this.pendingChangeFlag = b;
	}

	public boolean pendingChangeFlag() {
		return this.pendingChangeFlag;
	}

}
