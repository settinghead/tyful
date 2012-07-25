/**
 * 
 */
package com.settinghead.tyful.service.model;

/**
 * @author settinghead
 */
public class TermItem extends ScoreItem<Double> implements java.io.Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 7764190382686312894L;

	public TermItem(final String key, final double score) {
		super(key, score);
	}

	@Override
	protected void setKey(String key) {
		super.setKey(key.toLowerCase().trim());
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.settinghead.tyful.service.model.ScoreItem#clone()
	 */
	@Override
	public TermItem clone() {
		return new TermItem(getKey(), getScore());
	}

}
