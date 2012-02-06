package com.settinghead.wexpression.data.template;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Lob;


@Entity
public class Template {
	private byte[] previewPNG;
	private String id;
	
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
}
