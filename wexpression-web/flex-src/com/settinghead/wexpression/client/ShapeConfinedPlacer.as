package com.settinghead.wexpression.client {
	import com.settinghead.wexpression.client.density.DensityPatchIndex;
	import com.settinghead.wexpression.client.density.Patch;
	import com.settinghead.wexpression.client.placer.WordPlacer;


public class ShapeConfinedPlacer implements WordPlacer {

	private var img:TemplateImage;
	private var index:DensityPatchIndex;

	public function ShapeConfinedPlacer(img:TemplateImage, index:DensityPatchIndex) {
		this.setImg(img);
		this.setIndex(index);
	}

	public function place(word:Word, wordIndex:int, wordsCount:int,
			wordImageWidth:int, wordImageHeight:int, fieldWidth:int,
			fieldHeight:int):PlaceInfo {
		var patch:Patch= Patch(index.findPatchFor(wordImageWidth,
				wordImageHeight));
		if (patch == null)
			return null;
		return new PlaceInfo(patch.getX() + patch.getWidth() / 2, patch.getY()
				+ patch.getHeight() / 2, patch);
	}

	private function setImg(img:TemplateImage):void {
		this.img = img;
	}

	public function getImg():TemplateImage {
		return img;
	}

	public function setIndex(index:DensityPatchIndex):void {
		this.index = index;
	}

	public function getIndex():DensityPatchIndex {
		return index;
	}

	
override public function fail(returnedObj:Object):void {
		index.unmark(Patch(returnedObj));
	}

	
override public function success(returnedObj:Object):void {
		// index.add((Patch) returnedObj);
	}

}
}