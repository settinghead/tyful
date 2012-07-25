/**
 * 
 */
package com.settinghead.tyful.service.model;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Iterator;
import java.util.TreeSet;

/**
 * TODO
 * 
 * @author Xiyang Chen
 */
public abstract class ScoreTable<I extends ScoreItem<?>> extends TreeSet<I>
		implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = -1559671551387986894L;
	HashMap<String, I> map = new HashMap<String, I>();

	/**
	 * @param key
	 * @param value
	 */
	protected void addScore(final String key, final double value,
			final I newItem) {
		I item = map.get(key);
		if (item == null)
		// first time key added to table
		{
			newItem.setScore(value);
			map.put(key, newItem);
			super.add(newItem);
		} else {
			super.remove(item);
			item.addScore(value);
			super.add(item);
		}
	}

	/**
	 * @param key
	 * @param value
	 */
	protected void replaceGreaterScore(final String key, final double value,
			final I newItem) {
		I item = map.get(key);
		if (item == null)
		// first time key added to table
		{
			newItem.setScore(value);
			map.put(key, newItem);
			super.add(newItem);
		} else {
			super.remove(item);
			item.replaceGreaterScore(value);
			super.add(item);
		}
	}

	public abstract void addScore(final String key, final double value);

	public abstract void replaceGreaterScore(final String key,
			final double value);

	/**
	 * Generates a subset that contains the top n items.
	 * 
	 * @param n
	 *            the number of items in the returned ScoreTable.
	 * @return the subset generated.
	 */
	protected void getTop(final ScoreTable<I> table, final int n) {
		int count = 0;
		for (I item : this) {
			table.addScore(item.getKey(), item.getScore());
			if (++count == n)
				break;
		}
	}

	public abstract ScoreTable<I> getTop(final int n);

	public double getScore(final String key) {
		I item = map.get(key);
		if (item != null)
			return map.get(key).getScore();
		else
			return 0;
	}

	@Override
	public String toString() {
		return toWeightedQueryString();
	}

	public String toWeightedQueryString() {
		StringBuilder sb = new StringBuilder();
		Iterator<I> iterator = iterator();
		int count = 0;
		while (iterator.hasNext()) {
			I item = iterator.next();
			// String[] words = item.getKey().split(" ");
			// for (String word : words)
			sb.append('"').append(item.getKey()).append('"').append('^')
					.append(Float.toString((float) item.getScore()))
					.append(" ");
			count++;
		}
		// remove trailing space
		if (count > 0)
			sb.deleteCharAt(sb.length() - 1);
		return sb.toString();
	}

	public boolean keyExists(final String query) {
		return !(map.get(query) == null);
	}

	public I get(final String key) {
		return map.get(key);
	}

}
