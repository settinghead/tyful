package com.settinghead.tyful.client.sizers
{
	import com.settinghead.tyful.client.model.vo.wordlist.WordVO;
	import com.settinghead.tyful.client.math.MathUtils;
	
	public class ByRankWordSizer implements WordSizer
	{
		var minSize:int;
		var maxSize:int;
		
		public function ByRankWordSizer(minSize:int, maxSize:int)
		{
			this.minSize = minSize;
			this.maxSize = maxSize;
		}
		
		public function sizeFor(word:WordVO, wordRank:int, wordCount:int):Number
		{
			return MathUtils.map(wordRank, 0, wordCount, maxSize, minSize);
		}
	}
}