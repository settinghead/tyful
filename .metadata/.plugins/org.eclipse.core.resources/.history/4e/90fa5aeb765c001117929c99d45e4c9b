/**
 * 
 */
package com.settinghead.wexpression.client.angler {
	import com.settinghead.wexpression.client.model.vo.BBPolarTreeVO;
	import com.settinghead.wexpression.client.model.vo.EngineWordVO;
	import com.settinghead.wexpression.client.model.vo.template.Layer;
	import com.settinghead.wexpression.client.model.vo.template.TemplateVO;
	
	import org.as3commons.lang.Assert;

/**
 * @author settinghead
 * 
 */
public class ShapeConfinedAngler implements WordAngler {
	private var layer:Layer;
	private var otherwise:WordAngler;

	public function ShapeConfinedAngler(layer:Layer, otherwise:WordAngler) {
		this.layer = layer;
		this.otherwise = otherwise;
	}

	public function angleFor(eWord:EngineWordVO):Number {
		if (eWord.getCurrentLocation() == null)
			return otherwise.angleFor(eWord);
		// float angle = (img.getHue(
		// (int) eWord.getCurrentLocation().getpVector().x, (int) eWord
		// .getCurrentLocation().getpVector().y) + BBPolarTree.PI)
		// % BBPolarTree.TWO_PI;
		var angle:Number= (layer.getHue(
				int(eWord.getCurrentLocation().getpVector().x), int(eWord
						.getCurrentLocation().getpVector().y)) *BBPolarTreeVO.TWO_PI);
		if (isNaN(angle) || angle == 0)
			return otherwise.angleFor(eWord);
		else
			return angle;
	}
}
}