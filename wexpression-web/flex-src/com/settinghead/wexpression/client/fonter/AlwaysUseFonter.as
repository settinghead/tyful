package com.settinghead.wenwentu.client.fonter
{
	import com.settinghead.wenwentu.client.model.vo.WordVO;
	
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