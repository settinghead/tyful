package com.settinghead.wenwentu.service.model;

import java.io.Serializable;

/**
 * Abstract method an item along with its associated double-valued score. This
 * class and its subclasses are used for constructing a ScoreTable.
 * 
 * @author Xiyang Chen
 * @param <I>
 *            The class type of the item which is contained in each item.
 */
public abstract class ScoreItem<I> implements Comparable<ScoreItem<I>>,
		Cloneable, Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -4895659525865478854L;

	private double score;
	private I additionalField;
	private String key;

	/**
	 * The key value associated with the score.
	 * 
	 * @return
	 */
	public String getKey() {
		return key;
	}

	protected void setKey(String key) {
		this.key = key;
	}

	/**
	 * Get the score associated with the current item.
	 * 
	 * @return
	 */
	public double getScore() {
		return score;
	}

	public void setScore(double score) {
		this.score = score;
	}

	/**
	 * 
	 * @param key
	 *            the key associated with the current score item.
	 * @param value
	 *            the score value associated with the current score item.
	 */
	public ScoreItem(final String key, final double value) {
		setKey(key);
		score = value;
	}

	/**
	 * 
	 * @param key
	 *            the key associated with the current score item.
	 * @param value
	 *            the score value associated with the current score item.
	 * @param additionalField
	 *            the addition data required by some subclass types
	 */
	public ScoreItem(final String key, final double value,
			final I additionalField) {
		this(key, value);
		this.additionalField = additionalField;
	}

	/**
	 * Compares the current instance against a given instance.
	 * 
	 * The comparison is based on score, then by key value in lexigcoraphal
	 * order.
	 * 
	 * @return An integer value defined by standard Object.compareTo method.
	 *         That is, the value is equal to zero when the comparison result is
	 *         equal, is less than zero when the current instance is less than
	 *         the given instance, and greater than zero otherwise.
	 */
	public int compareTo(final ScoreItem<I> o) {
		int result = -Double.compare(score, o.score);
		if (result != 0 || key == null || o.key == null)
			return result;
		else
			return key.compareTo(o.key);
	}

	/**
	 * Add the given score to the current instance.
	 * 
	 * @param value
	 *            the score value to be added.
	 */
	public void addScore(final double value) {
		score += value;
	}

	public void replaceGreaterScore(final double value) {
		if (value > score)
			score = value;
	}

	@Override
	/**
	 * Output the ScoreItem in a (key, score) representation.
	 */
	public String toString() {
		return "(" + key + ", " + score + ")";
	}

	/**
	 * 
	 * @return a cloned copy of the instance.
	 */
	@Override
	public abstract ScoreItem<I> clone();

	/**
	 * 
	 * @return the addition data object associated with some subclass types.
	 */
	public I getAdditionalField() {
		return this.additionalField;
	}

}
