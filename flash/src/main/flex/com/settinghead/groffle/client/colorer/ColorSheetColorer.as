package com.settinghead.groffle.client.colorer
{
	import com.settinghead.groffle.client.model.vo.EngineWordVO;
	
	public class ColorSheetColorer implements WordColorer
	{
//		private var otherwise:WordColorer = new TwoHuesRandomSatsColorer();
		public function ColorSheetColorer()
		{
			
		}
		
		public function colorFor(eWord:EngineWordVO):uint
		{
			var color:uint = 
				eWord.getCurrentLocation().patch.layer.colorSheet.bitmapData.getPixel(
					eWord.getCurrentLocation().getpVector().x, eWord.getCurrentLocation().getpVector().y);
			return color;
//			else return otherwise.colorFor(eWord);
		}
	}
}