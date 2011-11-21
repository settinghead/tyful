package com.settinghead.wenwentu.client.sizers
{
	import com.settinghead.wenwentu.client.Word;
	import com.settinghead.wenwentu.client.math.MathUtils;
	
	public class ByWeightSizer implements WordSizer
	{
		var minSize:int;
		var maxSize:int;
		
		public function ByWeightSizer(minSize:int, maxSize:int)
		{
			this.minSize = minSize;
			this.maxSize = maxSize;
			
		}
		
		public function sizeFor(word:Word, wordRank:int, wordCount:int):Number
		{
			//			MathUtils.lerp(minSize+(maxSize-minSize)/2, maxSize, word.weight) 

			return maxSize	- Math.pow(Math.sqrt((maxSize-minSize))*wordRank/wordCount,2);
		}
	}
}