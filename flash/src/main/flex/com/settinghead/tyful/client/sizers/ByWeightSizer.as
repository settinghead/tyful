package com.settinghead.tyful.client.sizers
{
	import com.settinghead.tyful.client.math.MathUtils;
	import com.settinghead.tyful.client.model.vo.wordlist.WordVO;
	
	public class ByWeightSizer implements WordSizer
	{
		private var minSize:int;
		private var maxSize:int;
		private var _currentSize:Number;
		private var decr:Number;
		
		public function ByWeightSizer(minSize:int, maxSize:int)
		{
			this.minSize = minSize;
			this.maxSize = maxSize;
			reset();
		}
		
		public function sizeFor(word:WordVO, wordRank:int, wordCount:int):Number
		{
			//			MathUtils.lerp(minSize+(maxSize-minSize)/2, maxSize, word.weight) 

			return maxSize	- Math.pow(Math.sqrt((maxSize-minSize))*wordRank/wordCount,2);
		}
		
		public function switchToNextSize():Boolean{
			if(_currentSize>this.minSize){
				this._currentSize-= decr;
				if(_currentSize<this.minSize)
					_currentSize = minSize;
				return true;
			}
			else
				return false;
			
		}
		public function currentSize():Number{
			return _currentSize;
		}
		
		public function reset():void{
			_currentSize = maxSize;
			decr = (maxSize-minSize)/20;
			if(decr<1) decr=1;

		}
		public function hasNextSize():Boolean{
			return _currentSize > minSize;

		}

	}
}