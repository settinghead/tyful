package com.settinghead.wexpression.client.model.vo.template.placer {
	import com.demonsters.debugger.MonsterDebugger;
	import com.settinghead.wexpression.client.PlaceInfo;
	import com.settinghead.wexpression.client.density.DensityPatchIndex;
	import com.settinghead.wexpression.client.density.Patch;
	import com.settinghead.wexpression.client.model.vo.WordVO;
	import com.settinghead.wexpression.client.model.vo.template.Template;
	import com.settinghead.wexpression.client.model.vo.template.WordPlacer;
	
	import flash.geom.Point;
	
	import mx.controls.Alert;


public class ShapeConfinedPlacer extends WordPlacer {

	private var _template:Template;

	public function ShapeConfinedPlacer(template:Template = null) {
		this.template = template;
	}

	public override function place(word:WordVO, wordIndex:int, wordsCount:int,
			wordImageWidth:int, wordImageHeight:int, fieldWidth:int,
			fieldHeight:int): Vector.<PlaceInfo> {


		var patches:Vector.<Patch> = template.patchIndex.findPatchFor(wordImageWidth,
				wordImageHeight);

		template.patchIndex.lock();
		var places:Vector.<PlaceInfo> = new Vector.<PlaceInfo>();
		for(var i:int=0;i<patches.length;i++)
			places.push(new PlaceInfo(new Point((patches[i] as Patch).getX() + (patches[i] as Patch).getWidth() / 2, (patches[i] as Patch).getY()
			+ (patches[i] as Patch).getHeight() / 2), (patches[i] as Patch)));
		return places;
	}

	public function set template(template:Template):void {
		this._template = template;
	}

	public function get template():Template {
		return this._template;
	}

	
 	public override function fail(returnedObj:Object):void {
		
		for each(var pi:PlaceInfo in (returnedObj as Vector.<PlaceInfo>)){
			template.patchIndex.add(pi.patch);
		}
		
		template.patchIndex.unlock();
	}

	
	 public override function success(returnedObj:Object):void {
		 for each(var pi:PlaceInfo in (returnedObj as Vector.<PlaceInfo>)){
			template.patchIndex.add(pi.patch);
		 }
		 
		 template.patchIndex.unlock();
	}

}
}