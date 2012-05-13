package com.settinghead.wexpression.client.fonter
{
	import com.settinghead.wexpression.client.model.vo.wordlist.WordVO;
	
	public class AlwaysUseFonter implements WordFonter
	{
		
		private var fontName:String;
		public function AlwaysUseFonter(fontName:String)
		{
			this.fontName = fontName;
		}
		
		public function fontFor(word:WordVO):String
		{
			return fontName;
		}
	}
}