package com.settinghead.wexpression.data.template;

import java.io.Serializable;

import com.settinghead.wexpression.data.template.angler.WordAngler;
import com.settinghead.wexpression.data.template.colorer.WordColorer;
import com.settinghead.wexpression.data.template.fonter.WordFonter;
import com.settinghead.wexpression.data.template.nudger.WordNudger;

public class Layer implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 3433555472191437858L;

	private WordFonter fonter;
	private WordColorer colorer;
	private WordNudger nudger;
	private WordAngler angler;
	private byte[] imgPNG;

	/**
	 * @param fonter the fonter to set
	 */
	public void setFonter(WordFonter fonter) {
		this.fonter = fonter;
	}
	/**
	 * @return the fonter
	 */
	public WordFonter getFonter() {
		return fonter;
	}
	/**
	 * @param colorer the colorer to set
	 */
	public void setColorer(WordColorer colorer) {
		this.colorer = colorer;
	}
	/**
	 * @return the colorer
	 */
	public WordColorer getColorer() {
		return colorer;
	}
	/**
	 * @param nudger the nudger to set
	 */
	public void setNudger(WordNudger nudger) {
		this.nudger = nudger;
	}
	/**
	 * @return the nudger
	 */
	public WordNudger getNudger() {
		return nudger;
	}
	/**
	 * @param angler the angler to set
	 */
	public void setAngler(WordAngler angler) {
		this.angler = angler;
	}
	/**
	 * @return the angler
	 */
	public WordAngler getAngler() {
		return angler;
	}
	/**
	 * @param imgPNG the imgPNG to set
	 */
	public void setImgPNG(byte[] imgPNG) {
		this.imgPNG = imgPNG;
	}
	/**
	 * @return the imgPNG
	 */
	public byte[] getImgPNG() {
		return imgPNG;
	}

}
