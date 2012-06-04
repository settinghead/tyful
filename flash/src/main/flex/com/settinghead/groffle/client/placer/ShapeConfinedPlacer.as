package com.settinghead.groffle.client.placer {
	import com.settinghead.groffle.client.model.vo.template.PlaceInfo;
	import com.settinghead.groffle.client.density.DensityPatchIndex;
	import com.settinghead.groffle.client.density.Patch;
	import com.settinghead.groffle.client.model.vo.wordlist.WordVO;
	import com.settinghead.groffle.client.model.vo.template.TemplateVO;
	
	import flash.geom.Point;
	
	import mx.controls.Alert;


public class ShapeConfinedPlacer implements WordPlacer {

	private var img:TemplateVO;
	private var index:DensityPatchIndex;

	public function ShapeConfinedPlacer(img:TemplateVO, index:DensityPatchIndex) {
		this.setImg(img);
		this.setIndex(index);
	}

	public function place(word:WordVO, wordIndex:int, wordsCount:int,
			wordImageWidth:int, wordImageHeight:int, fieldWidth:int,
			fieldHeight:int): Vector.<PlaceInfo> {


		var patches:Vector.<Patch> = index.findPatchFor(wordImageWidth, wordImageHeight);

		index.lock();
		var places:Vector.<PlaceInfo> = new Vector.<PlaceInfo>();
		for(var i:int=0;i<patches.length;i++)
			places.push(new PlaceInfo(new Point((patches[i] as Patch).getX() + (patches[i] as Patch).getWidth() / 2, (patches[i] as Patch).getY()
			+ (patches[i] as Patch).getHeight() / 2), (patches[i] as Patch)));
		return places;
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
		
		for each(var pi:PlaceInfo in (returnedObj as Vector.<PlaceInfo>)){
			index.add(pi.patch);
		}
		
		index.unlock();
	}

	
	 public function success(returnedObj:Object):void {
		 for each(var pi:PlaceInfo in (returnedObj as Vector.<PlaceInfo>)){
			index.add(pi.patch);
		 }
		 
		 index.unlock();
	}

}
}