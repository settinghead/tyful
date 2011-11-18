package com.settinghead.wexpression.client.sizers
{
	import com.settinghead.wexpression.client.Word;
	import com.settinghead.wexpression.client.math.MathUtils;
	
	public class ByRankWordSizer implements WordSizer
	{
		var minSize:int;
		var maxSize:int;
		
		public function ByRankWordSizer(minSize:int, maxSize:int)
		{
			this.minSize = minSize;
			this.maxSize = maxSize;
		}
		
		public function sizeFor(word:Word, wordRank:int, wordCount:int):Number
		{
			return MathUtils.map(wordRank, 0, wordCount, maxSize, minSize);
		}
	}
}