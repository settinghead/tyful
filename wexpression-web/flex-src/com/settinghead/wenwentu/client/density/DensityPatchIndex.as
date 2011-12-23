package com.settinghead.wenwentu.client.density
{
	import com.settinghead.wenwentu.client.model.vo.TemplateVO;

	public class DensityPatchIndex {
		
		private var img:TemplateVO;
		private var _map:LeveledPatchMap;
		
		public static const NUMBER_OF_DIVISIONS:int= 3;
		public static const QUEUE_ALPHA_THRESHOLD:Number= Number.NEGATIVE_INFINITY;
		public static var MARK_FILL_FACTOR:Number= 0.7;
		public static var NUMBER_OF_ATTEMPTED_PATCHES:int = 3;
		
		public function DensityPatchIndex(img:TemplateVO) {
			this.img = img;
			_map = new LeveledPatchMap(this);
		}
		
		public function findPatchFor(width:int, height:int):Vector.<Patch> {
			var level:int= findGranularityLevel(width, height);
			if (level < 0)
				level = 0;
			var result:Vector.<Patch> = new Vector.<Patch>();
			var area:Number = width * height;
			for(var i:int=0;i<NUMBER_OF_ATTEMPTED_PATCHES; i++)
				result.push(getBestPatchAtLevel(level));
			return result;
		}
		
		private function getBestPatchAtLevel(level:int):Patch {
			var result:Patch= _map.getBestPatchAtLevel(level);
			if (result == null)
				return getBestPatchAtLevel(level - 1);
			else
				return result;
		}
		
		private function findGranularityLevel(width:int, height:int):int {
			var max:int= width > height ? width : height;
			var minContainerLength:int= img.getWidth() > img.getHeight() ? img
				.getWidth() : img.getHeight();
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
	}
}