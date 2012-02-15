package com.settinghead.wexpression.data.template.colorer;

public class AlwaysUseColorer implements WordColorer {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1433564008206290102L;
	private int color;
	/**
	 * @param color the color to set
	 */
	public void setColor(int color) {
		this.color = color;
	}
	/**
	 * @return the color
	 */
	public int getColor() {
		return color;
	}
}
