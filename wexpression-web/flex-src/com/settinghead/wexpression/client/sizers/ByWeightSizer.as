package com.settinghead.wexpression.client.sizers
{
	import com.settinghead.wexpression.client.Word;
	import com.settinghead.wexpression.client.math.MathUtils;
	
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
			return MathUtils.lerp(minSize, maxSize, word.weight);
		}
	}
}