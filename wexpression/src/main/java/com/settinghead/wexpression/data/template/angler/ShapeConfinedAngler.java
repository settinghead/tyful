/**
 * 
 */
package com.settinghead.wexpression.data.template.angler;

import com.settinghead.wexpression.data.template.Layer;

/**
 * @author settinghead
 *
 */
public class ShapeConfinedAngler implements WordAngler {

	/**
	 * 
	 */
	private static final long serialVersionUID = -4779342097410656732L;
	private Layer layer;
	private WordAngler otherwise;
	
	/**
	 * @param layer the layer to set
	 */
	public void setLayer(Layer layer) {
		this.layer = layer;
	}
	/**
	 * @return the layer
	 */
	public Layer getLayer() {
		return layer;
	}
	/**
	 * @param otherwise the otherwise to set
	 */
	public void setOtherwise(WordAngler otherwise) {
		this.otherwise = otherwise;
	}
	/**
	 * @return the otherwise
	 */
	public WordAngler getOtherwise() {
		return otherwise;
	}
}
