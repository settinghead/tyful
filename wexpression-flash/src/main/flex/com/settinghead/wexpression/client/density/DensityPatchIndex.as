package com.settinghead.wexpression.client.density
{
	import com.settinghead.wexpression.client.model.vo.template.TemplateVO;
	
	import mx.controls.Alert;
	
	import org.as3commons.lang.Assert;

	public class DensityPatchIndex {
		
		private var img:TemplateVO;
		private var _map:LeveledPatchMap;
		
		public static const NUMBER_OF_DIVISIONS:int= 2;
		public static const QUEUE_ALPHA_THRESHOLD:Number= Number.NEGATIVE_INFINITY;
		public static var MARK_FILL_FACTOR:Number= 1;
		public static var NUMBER_OF_ATTEMPTED_PATCHES:int = 4;
		private var locked:Boolean = false;
		
		public function DensityPatchIndex(img:TemplateVO) {
			this.img = img;
			_map = new LeveledPatchMap(this);
		}
		
		
		
		public function findPatchFor(width:int, height:int):Vector.<Patch> {

			if(locked) throw new Error("Concurrent access of density patch index not supported.");

			var result:Vector.<Patch> = new Vector.<Patch>();

//			result.push( getBestPatchAtLevel(0));
			
			var level:int= findGranularityLevel(width, height);
			
			var area:Number = width * height;
			for(var i:int=0;i<NUMBER_OF_ATTEMPTED_PATCHES; i++){
				var p:Patch = getBestPatchAtLevel(level);
				if(p!=null) result.push(p);
			}
			Assert.isTrue(result.length>0);
			return result;
		}
		
		private function getBestPatchAtLevel(level:int):Patch {
			var result:Patch= _map.getBestPatchAtLevel(level);
//			if (result == null)
//				return getBestPatchAtLevel(level - 1);
//			else
				return result;
		}
		
		private function findGranularityLevel(width:int, height:int):int {
			var max:int= width > height ? width : height;
			max *= 2;
			var minContainerLength:int= img.width > img.height ? img
				.width : img.height;
			var squareWidth:int= minContainerLength;
			var level:int= 0;
			
			while (squareWidth > max) {
				squareWidth /= NUMBER_OF_DIVISIONS;
				level++;
			}
			
			level -= 1; 
			if(level<0) level = 0;
			return level;
		}
	
//		public function unmark(patch:Patch):void {
//			patch.unmark(patch);
//		}
//		
		public function add(patch:Patch):void{
			_map.add(patch);
		}
		
		public function getImg():TemplateVO {
			return this.img;
		}
		
		public function get map():LeveledPatchMap{
			return _map;
		}
		
		public function lock():void{
			this.locked = true;
		}
		
		public function unlock():void{
			this.locked = false;
		}
	}
}