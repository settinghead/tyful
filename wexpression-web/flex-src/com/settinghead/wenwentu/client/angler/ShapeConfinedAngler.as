/**
 * 
 */
package com.settinghead.wenwentu.client.angler {
	import com.settinghead.wenwentu.client.EngineWord;
	import com.settinghead.wenwentu.client.TemplateImage;
	
	import org.as3commons.lang.Assert;

/**
 * @author settinghead
 * 
 */
public class ShapeConfinedAngler implements WordAngler {
	var img:TemplateImage;
	private var otherwise:WordAngler;

	public function ShapeConfinedAngler(img:TemplateImage, otherwise:WordAngler) {
		this.img = img;
		this.otherwise = otherwise;
	}

	public function angleFor(eWord:EngineWord):Number {
		if (eWord.getCurrentLocation() == null)
			return otherwise.angleFor(eWord);
		// float angle = (img.getHue(
		// (int) eWord.getCurrentLocation().getpVector().x, (int) eWord
		// .getCurrentLocation().getpVector().y) + BBPolarTree.PI)
		// % BBPolarTree.TWO_PI;
		var angle:Number= (img.getHue(
				int(eWord.getCurrentLocation().getpVector().x), int(eWord
						.getCurrentLocation().getpVector().y)));
		if (isNaN(angle) || angle == 0)
			return otherwise.angleFor(eWord);
		else
			return angle;
	}
}
}