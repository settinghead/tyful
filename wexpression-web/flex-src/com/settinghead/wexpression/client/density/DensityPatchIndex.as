package com.settinghead.wexpression.client.density
{
	import com.settinghead.wexpression.client.TemplateImage;

	public class DensityPatchIndex {
		
		private var img:TemplateImage;
		private var _map:LeveledPatchMap;
		
		public static const NUMBER_OF_DIVISIONS:int= 3;
		public static const QUEUE_ALPHA_THRESHOLD:Number= 0.01;
		public static var MARK_FILL_FACTOR:Number= 0.6;
		
		
		public function DensityPatchIndex(img:TemplateImage) {
			this.img = img;
			_map = new LeveledPatchMap(this);
		}
		
		public function findPatchFor(width:int, height:int):Patch {
			var level:int= findGranularityLevel(width, height);
			if (level < 0)
				level = 0;
			return getBestPatchAtLevel(level, width * height);
		}
		
		private function getBestPatchAtLevel(level:int, smearedArea:int):Patch {
			var result:Patch= _map.getBestPatchAtLevel(level, smearedArea);
			if (result == null)
				return getBestPatchAtLevel(level - 1, smearedArea);
			else
				return result;
		}
		
		private function findGranularityLevel(width:int, height:int):int {
			var max:int= width > height ? width : height;
			var minContainerLength:int= img.getWidth() < img.getHeight() ? img
				.getWidth() : img.getHeight();
			var squareWidth:int= minContainerLength;
			var level:int= 0;
			
			while (squareWidth > max) {
				squareWidth /= NUMBER_OF_DIVISIONS;
				level++;
			}
			
			return level - 1;
		}
	
		public function unmark(patch:Patch):void {
			patch.unmarkForParent();
		}
		
		public function getImg():TemplateImage {
			return this.img;
		}
	}
}