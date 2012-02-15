package com.settinghead.wexpression.data.template;

import java.io.Serializable;

public class RenderOptions implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private int maxAttemptsToPlaceWord;
	private int maxNumberOfWordsToDraw;
	private int minShapeSize;
	private int wordPadding;
	/**
	 * @param maxAttemptsToPlaceWord the maxAttemptsToPlaceWord to set
	 */
	public void setMaxAttemptsToPlaceWord(int maxAttemptsToPlaceWord) {
		this.maxAttemptsToPlaceWord = maxAttemptsToPlaceWord;
	}
	/**
	 * @return the maxAttemptsToPlaceWord
	 */
	public int getMaxAttemptsToPlaceWord() {
		return maxAttemptsToPlaceWord;
	}
	/**
	 * @param maxNumberOfWordsToDraw the maxNumberOfWordsToDraw to set
	 */
	public void setMaxNumberOfWordsToDraw(int maxNumberOfWordsToDraw) {
		this.maxNumberOfWordsToDraw = maxNumberOfWordsToDraw;
	}
	/**
	 * @return the maxNumberOfWordsToDraw
	 */
	public int getMaxNumberOfWordsToDraw() {
		return maxNumberOfWordsToDraw;
	}
	/**
	 * @param minShapeSize the minShapeSize to set
	 */
	public void setMinShapeSize(int minShapeSize) {
		this.minShapeSize = minShapeSize;
	}
	/**
	 * @return the minShapeSize
	 */
	public int getMinShapeSize() {
		return minShapeSize;
	}
	/**
	 * @param wordPadding the wordPadding to set
	 */
	public void setWordPadding(int wordPadding) {
		this.wordPadding = wordPadding;
	}
	/**
	 * @return the wordPadding
	 */
	public int getWordPadding() {
		return wordPadding;
	}
	
}
