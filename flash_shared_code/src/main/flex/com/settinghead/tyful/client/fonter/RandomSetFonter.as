package com.settinghead.tyful.client.fonter
{
	import com.settinghead.tyful.client.model.vo.wordlist.WordVO;
	
	import de.polygonal.utils.PM_PRNG;
	
	public class RandomSetFonter implements WordFonter
	{
		private static const fontSets:Array = 
			[['panefresco500','permanentmarker', 'romeral']
//			,['bpreplay-kRB','fifthleg-kRB','pecita-kRB','sniglet-kRB']
			];
		
		private var fonter:PickFromFonter;
		private static var prng:PM_PRNG = new PM_PRNG();

		public function RandomSetFonter()
		{
			 fonter = new PickFromFonter( fontSets[int((Math.random()*fontSets.length))]);
		}
		
		public function fontFor(word:WordVO):String
		{
			return fonter.fontFor(word);
		}
	}
}