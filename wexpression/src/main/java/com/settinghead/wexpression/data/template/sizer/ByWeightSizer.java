/**
 * 
 */
package com.settinghead.wexpression.data.template.sizer;

/**
 * @author settinghead
 *
 */
public class ByWeightSizer implements WordSizer {

	/**
	 * 
	 */
	private static final long serialVersionUID = -5406304426531951240L;
	private int minSize;
	private int maxSize;
	/**
	 * @param minSize the minSize to set
	 */
	public void setMinSize(int minSize) {
		this.minSize = minSize;
	}
	/**
	 * @return the minSize
	 */
	public int getMinSize() {
		return minSize;
	}
	/**
	 * @param maxSize the maxSize to set
	 */
	public void setMaxSize(int maxSize) {
		this.maxSize = maxSize;
	}
	/**
	 * @return the maxSize
	 */
	public int getMaxSize() {
		return maxSize;
	}
}
