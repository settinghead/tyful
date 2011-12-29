package com.settinghead.wenwentu.client.placer {
	import com.demonsters.debugger.MonsterDebugger;
	import com.settinghead.wenwentu.client.PlaceInfo;
	import com.settinghead.wenwentu.client.density.DensityPatchIndex;
	import com.settinghead.wenwentu.client.density.Patch;
	import com.settinghead.wenwentu.client.model.vo.TemplateVO;
	import com.settinghead.wenwentu.client.model.vo.WordVO;
	
	import flash.geom.Point;


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
		var patches:Vector.<Patch> = index.findPatchFor(wordImageWidth,
				wordImageHeight);
		
		var places:Vector.<PlaceInfo> = new Vector.<PlaceInfo>();
		for(var i=0;i<patches.length;i++)
			places.push(new PlaceInfo(new Point(patches[i].getX() + patches[i].getWidth() / 2, patches[i].getY()
			+ patches[i].getHeight() / 2), patches[i]));
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
	}

	
	 public function success(returnedObj:Object):void {
		 for each(var pi:PlaceInfo in (returnedObj as Vector.<PlaceInfo>)){
			index.add(pi.patch);
		 }
	}

}
}