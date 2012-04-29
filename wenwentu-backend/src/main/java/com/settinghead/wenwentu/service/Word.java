package com.settinghead.wenwentu.service;

public class Word {
	private String word;
	private int weight;

	/**
	 * @return the word
	 */

	public Word() {

	}

	public Word(String word, int weight) {
		this.setWord(word);
		this.setWeight(weight);
	}

	public String getWord() {
		return word;
	}

	/**
	 * @param word
	 *            the word to set
	 */
	public void setWord(String word) {
		this.word = word;
	}

	/**
	 * @return the weight
	 */
	public int getWeight() {
		return weight;
	}

	/**
	 * @param weight
	 *            the weight to set
	 */
	public void setWeight(int weight) {
		this.weight = weight;
	}
}
