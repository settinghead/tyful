package com.settinghead.wexpression.wordlist;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import org.hibernate.annotations.IndexColumn;
import org.springframework.transaction.annotation.Transactional;

@Entity
@Transactional
public class Word implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = -6086016682496314563L;
	private String word;
	private double weight;
	private int id;

	public Word() {

	}

	public Word(String word, Integer weight) {
		setWord(word);
		setWeight(weight);
	}

	/**
	 * @param word
	 *            the word to set
	 */
	public void setWord(String word) {
		this.word = word;
	}

	/**
	 * @return the word
	 */
	public String getWord() {
		return word;
	}

	/**
	 * @param weight
	 *            the weight to set
	 */
	public void setWeight(double weight) {
		this.weight = weight;
	}

	/**
	 * @return the weight
	 */
	public double getWeight() {
		return weight;
	}

	/**
	 * @param id
	 *            the id to set
	 */

	public void setId(int id) {
		this.id = id;
	}

	/**
	 * @return the id
	 */
	@Id
	@GeneratedValue
	@IndexColumn(name = "id")
	public int getId() {
		return id;
	}

}
