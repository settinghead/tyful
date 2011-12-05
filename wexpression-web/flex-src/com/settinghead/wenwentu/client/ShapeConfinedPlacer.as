package com.settinghead.wenwentu.client {
	import com.settinghead.wenwentu.client.density.DensityPatchIndex;
	import com.settinghead.wenwentu.client.density.Patch;
	import com.settinghead.wenwentu.client.model.vo.TemplateVO;
	import com.settinghead.wenwentu.client.placer.WordPlacer;
	
	import flash.geom.Point;
	import com.settinghead.wenwentu.client.model.vo.WordVO;


public class ShapeConfinedPlacer implements WordPlacer {

	private var img:TemplateVO;
	private var index:DensityPatchIndex;

	public function ShapeConfinedPlacer(img:TemplateVO, index:DensityPatchIndex) {
		this.setImg(img);
		this.setIndex(index);
	}

	public function place(word:WordVO, wordIndex:int, wordsCount:int,
			wordImageWidth:int, wordImageHeight:int, fieldWidth:int,
			fieldHeight:int):PlaceInfo {
		var patch:Patch= Patch(index.findPatchFor(wordImageWidth,
				wordImageHeight));
		if (patch == null)
			return null;
		return new PlaceInfo(new Point(patch.getX() + patch.getWidth() / 2, patch.getY()
				+ patch.getHeight() / 2), patch);
	}

	private function setImg(img:TemplateVO):void {
		this.img = img;
	}

	public function getImg():TemplateVO {
		return img;
	}

	public function setIndex(index:DensityPatchIndex):void {
		this.index = index;
	}

	public function getIndex():DensityPatchIndex {
		return index;
	}

	
 	public function fail(returnedObj:Object):void {
		index.unmark(Patch(returnedObj));
	}

	
	 public function success(returnedObj:Object):void {
		// index.add((Patch) returnedObj);
	}

}
}