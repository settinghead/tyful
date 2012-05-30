package com.settinghead.wenwentu.service.model;

import java.util.ArrayList;

public class Word {
	private String word;
	private int weight;
	private ArrayList<Occurence> occurences;

	/**
	 * @return the word
	 */

	public Word() {

	}

	public Word(String word, int weight, ArrayList<Occurence> occurences) {
		this.setWord(word);
		this.setWeight(weight);
		this.setOccurences(occurences);
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

	/**
	 * @return the occurences
	 */
	public ArrayList<Occurence> getOccurences() {
		return occurences;
	}

	/**
	 * @param occurences the occurences to set
	 */
	public void setOccurences(ArrayList<Occurence> occurences) {
		this.occurences = occurences;
	}
}
