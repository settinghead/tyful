package com.settinghead.wexpression.client.sizers
{
	import com.settinghead.wexpression.client.model.vo.wordlist.WordVO;
	import com.settinghead.wexpression.client.math.MathUtils;
	
	public class ByWeightSizer implements WordSizer
	{
		private var minSize:int;
		private var maxSize:int;
		
		public function ByWeightSizer(minSize:int, maxSize:int)
		{
			this.minSize = minSize;
			this.maxSize = maxSize;
			
		}
		
		public function sizeFor(word:WordVO, wordRank:int, wordCount:int):Number
		{
			//			MathUtils.lerp(minSize+(maxSize-minSize)/2, maxSize, word.weight) 

			return maxSize	- Math.pow(Math.sqrt((maxSize-minSize))*wordRank/wordCount,2);
		}
	}
}