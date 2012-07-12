package com.settinghead.tyful.client.colorer
{
	import com.notifications.Notification;
	import com.settinghead.tyful.client.model.vo.EngineWordVO;
	
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
					eWord.getCurrentLocation().x, eWord.getCurrentLocation().y);
//			if(color==0){
//				Notification.show(eWord.getCurrentLocation().x.toString()+
//					", "+ eWord.getCurrentLocation().y.toString());
//			}
			return color;
//			else return otherwise.colorFor(eWord);
		}
	}
}