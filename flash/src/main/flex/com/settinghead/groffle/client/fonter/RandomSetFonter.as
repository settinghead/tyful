package com.settinghead.groffle.client.fonter
{
	import com.settinghead.groffle.client.model.vo.wordlist.WordVO;
	
	import de.polygonal.utils.PM_PRNG;
	
	public class RandomSetFonter implements WordFonter
	{
		private static const fontSets:Array = 
			[['panefresco500','permanentmarker', 'romeral'],
			['communist','judson','komika-axis']];
		
		private var fonter:PickFromFonter;
		
		public function RandomSetFonter()
		{
			 var prng:PM_PRNG = new PM_PRNG();
			 fonter = new PickFromFonter( fontSets[prng.nextIntRange(0,fontSets.length)]);
		}
		
		public function fontFor(word:WordVO):String
		{
			return fonter.fontFor(word);
		}
	}
}