/**
 * 
 */
package com.settinghead.wexpression.client.angler {
	import com.settinghead.wexpression.client.model.vo.BBPolarTreeVO;
	import com.settinghead.wexpression.client.model.vo.EngineWordVO;
	import com.settinghead.wexpression.client.model.vo.TemplateVO;
	
	import org.as3commons.lang.Assert;

/**
 * @author settinghead
 * 
 */
public class ShapeConfinedAngler implements WordAngler {
	var img:TemplateVO;
	private var otherwise:WordAngler;

	public function ShapeConfinedAngler(img:TemplateVO, otherwise:WordAngler) {
		this.img = img;
		this.otherwise = otherwise;
	}

	public function angleFor(eWord:EngineWordVO):Number {
		if (eWord.getCurrentLocation() == null)
			return otherwise.angleFor(eWord);
		// float angle = (img.getHue(
		// (int) eWord.getCurrentLocation().getpVector().x, (int) eWord
		// .getCurrentLocation().getpVector().y) + BBPolarTree.PI)
		// % BBPolarTree.TWO_PI;
		var angle:Number= (img.getHue(
				int(eWord.getCurrentLocation().getpVector().x), int(eWord
						.getCurrentLocation().getpVector().y)) *BBPolarTreeVO.TWO_PI);
		if (isNaN(angle) || angle == 0)
			return otherwise.angleFor(eWord);
		else
			return angle;
	}
}
}