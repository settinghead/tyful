/**
 * 
 */
package com.settinghead.groffle.client.angler {
	import com.settinghead.groffle.client.model.vo.EngineWordVO;
	import com.settinghead.groffle.client.model.vo.template.WordLayer;
	
	import polartree.AlchemyPolarTree;

/**
 * @author settinghead
 * 
 */
public class ShapeConfinedAngler implements WordAngler {
	private var layer:WordLayer;
	private var otherwise:WordAngler;

	public function ShapeConfinedAngler(layer:WordLayer, otherwise:WordAngler) {
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
						.getCurrentLocation().getpVector().y)) *AlchemyPolarTree.TWO_PI);
		if (isNaN(angle) || angle == 0)
			return otherwise.angleFor(eWord);
		else
			return angle;
	}
}
}