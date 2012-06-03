package com.settinghead.groffle.client.fonter
{
	import com.settinghead.groffle.client.model.vo.wordlist.WordVO;
	
	import de.polygonal.utils.PM_PRNG;

	public class PickFromFonter implements WordFonter
	{
		private var fonts:Array;
		private static var prng:PM_PRNG = new PM_PRNG();

		public function PickFromFonter(fonts:Array)
		{
			this.fonts = fonts;
		}
		
		public function fontFor(word:WordVO):String{
			return fonts[prng.nextIntRange(0,fonts.length-1)];

		}
	}
}