package com.settinghead.wexpression.data.template;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Lob;

import com.settinghead.wexpression.data.template.angler.WordAngler;
import com.settinghead.wexpression.data.template.colorer.WordColorer;
import com.settinghead.wexpression.data.template.fonter.WordFonter;
import com.settinghead.wexpression.data.template.nudger.WordNudger;
import com.settinghead.wexpression.data.template.placer.WordPlacer;
import com.settinghead.wexpression.data.template.sizer.WordSizer;


@Entity
public class Template {
	private String id;
	private Layer[] layers;
	private String path;
	private WordSizer sizer;
	private WordPlacer placer;

	private WordFonter fonter;
	private WordColorer colorer;
	private WordNudger nudger;
	private WordAngler angler;
	private RenderOptions renderOptions;
	private byte[] previewPNG;

	/**
	 * @param data the data to set
	 */
	public void setPreviewPNG(byte[] data) {
		this.previewPNG = data;
	}

	/**
	 * @return the data
	 */
	@Lob
	public byte[] getPreviewPNG() {
		return this.previewPNG;
	}

	/**
	 * @param id the id to set
	 */
	public void setId(String id) {
		this.id = id;
	}

	/**
	 * @return the id
	 */
	@Id
	@GeneratedValue
	public String getId() {
		return id;
	}

	/**
	 * @param layers the layers to set
	 */
	public void setLayers(Layer[] layers) {
		this.layers = layers;
	}

	/**
	 * @return the layers
	 */
	public Layer[] getLayers() {
		return layers;
	}

	/**
	 * @param sizer the sizer to set
	 */
	public void setSizer(WordSizer sizer) {
		this.sizer = sizer;
	}

	/**
	 * @return the sizer
	 */
	public WordSizer getSizer() {
		return sizer;
	}

	/**
	 * @param path the path to set
	 */
	public void setPath(String path) {
		this.path = path;
	}

	/**
	 * @return the path
	 */
	public String getPath() {
		return path;
	}

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
	 * @param placer the placer to set
	 */
	public void setPlacer(WordPlacer placer) {
		this.placer = placer;
	}

	/**
	 * @return the placer
	 */
	public WordPlacer getPlacer() {
		return placer;
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
	 * @param renderOptions the renderOptions to set
	 */
	public void setRenderOptions(RenderOptions renderOptions) {
		this.renderOptions = renderOptions;
	}

	/**
	 * @return the renderOptions
	 */
	public RenderOptions getRenderOptions() {
		return renderOptions;
	}


}
