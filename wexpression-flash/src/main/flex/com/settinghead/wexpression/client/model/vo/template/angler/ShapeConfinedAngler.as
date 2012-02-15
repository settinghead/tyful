/**
 * 
 */
package com.settinghead.wexpression.client.model.vo.template.angler {
	import com.settinghead.wexpression.client.model.vo.BBPolarTreeVO;
	import com.settinghead.wexpression.client.model.vo.EngineWordVO;
	import com.settinghead.wexpression.client.model.vo.template.Layer;
	import com.settinghead.wexpression.client.model.vo.template.Template;
	import com.settinghead.wexpression.client.model.vo.template.WordAngler;
	
	import org.as3commons.lang.Assert;

/**
 * @author settinghead
 * 
 */
public class ShapeConfinedAngler extends WordAngler {
	private var _layer:Layer;
	private var _otherwise:WordAngler;
	
	public function get layer():Layer{
		return this._layer;
	}
	
	public function set(l:Layer):void{
		this._layer = l;
	}
	
	public function get otherwise():WordAngler{
		return this._otherwise;
	}
	
	public function set otherwise(o:WordAngler):void{
		this._otherwise = o;
	}

	public function ShapeConfinedAngler(layer:Layer=null, otherwise:WordAngler = null) {
		this._layer = layer;
		this.otherwise = otherwise;
	}

	public override function angleFor(eWord:EngineWordVO):Number {
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