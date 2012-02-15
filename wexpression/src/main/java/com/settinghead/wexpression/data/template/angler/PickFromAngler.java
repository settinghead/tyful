package com.settinghead.wexpression.data.template.angler;

public class PickFromAngler implements WordAngler{

	/**
	 * 
	 */
	private static final long serialVersionUID = 3652695427102849011L;
	private double angles[];
	/**
	 * @param angles the angles to set
	 */
	public void setAngles(double angles[]) {
		this.angles = angles;
	}
	/**
	 * @return the angles
	 */
	public double[] getAngles() {
		return angles;
	}
	
}
