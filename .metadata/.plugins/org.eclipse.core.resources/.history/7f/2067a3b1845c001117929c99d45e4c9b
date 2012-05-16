package com.settinghead.wexpression.client.model.vo.template.sizer
{
	import com.settinghead.wexpression.client.math.MathUtils;
	import com.settinghead.wexpression.client.model.vo.WordVO;
	import com.settinghead.wexpression.client.model.vo.template.WordSizer;
	
	public class ByWeightSizer extends WordSizer
	{
		private var _minSize:int;
		private var _maxSize:int;
		
		public function get minSize():int{
			return this._minSize;
		}
		
		public function set minSize(s:int):void{
			this._minSize = s;
		}
		
		public function get maxSize():int{
			return this._maxSize;
		}
		
		public function set maxSize(s:int):void{
			this._maxSize = s;
		}
		
		public function ByWeightSizer(minSize:int = 10, maxSize:int = 100)
		{
			this.minSize = minSize;
			this.maxSize = maxSize;
			
		}
		
		public override function sizeFor(word:WordVO, wordRank:int, wordCount:int):Number
		{
			//			MathUtils.lerp(minSize+(maxSize-minSize)/2, maxSize, word.weight) 

			return maxSize	- Math.pow(Math.sqrt((maxSize-minSize))*wordRank/wordCount,2);
		}
	}
}