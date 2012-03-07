package com.settinghead.wexpression.data.template;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Lob;

import org.hibernate.annotations.GenericGenerator;


@Entity
public class Template {
	private byte[] previewPNG;	
	private byte[] data;
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
	@Id @GeneratedValue(generator="system-uuid")
	@GenericGenerator(name = "system-uuid", strategy = "uuid")
	public String getId() {
		return id;
	}

	/**
	 * @return the data
	 */
	@Lob
	public byte[] getData() {
		return data;
	}

	/**
	 * @param data the data to set
	 */
	public void setData(byte[] data) {
		this.data = data;
	}
}
