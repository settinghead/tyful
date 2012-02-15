package com.settinghead.wexpression.client.model.vo.template.fonter
{
	import com.settinghead.wexpression.client.model.vo.WordVO;
	import com.settinghead.wexpression.client.model.vo.template.WordFonter;
	
	public class AlwaysUseFonter extends WordFonter
	{
		
		private var _fontName:String;
		
		public function get fontName():String{
			return _fontName;
		}
		
		public function set fontName(f:String):void{
			this._fontName = f;
		}
		
		public function AlwaysUseFonter(fontName:String)
		{
			this._fontName = fontName;
		}
		
		public override function fontFor(word:WordVO):String
		{
			return fontName;
		}
	}
}