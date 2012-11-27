package com.settinghead.tyful.client.colorer
{
	import com.settinghead.tyful.client.model.vo.template.PlaceInfo;
	
	public class ColorSheetColorer implements WordColorer
	{
//		private var otherwise:WordColorer = new TwoHuesRandomSatsColorer();
		public function ColorSheetColorer()
		{
			
		}
		
		public function colorFor(place:PlaceInfo = null):uint
		{
			var color:uint = 
				place.layer.colorSheet.bitmapData.getPixel(
					place.x, place.y);
//			if(color==0){
//				Notification.show(eWord.getCurrentLocation().x.toString()+
//					", "+ eWord.getCurrentLocation().y.toString());
//			}
			return color;
//			else return otherwise.colorFor(eWord);
		}
	}
}