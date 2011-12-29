package com.settinghead.wenwentu.client.model
{
	import com.settinghead.wenwentu.client.model.vo.DisplayWordListVO;
	import com.settinghead.wenwentu.client.model.vo.DisplayWordVO;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class DisplayWordListProxy extends Proxy
	{
		
		private static var NAME = "DisplayWordProxy"; 
		public function DisplayWordListProxy()
		{
			super(NAME, new DisplayWordListVO());
		}
		
		public function addDisplayWord(dWord:DisplayWordVO){
			data.addItem(dWord);
		}
		
		override function get data():DisplayWordListVO{
			return super.data as DisplayWordListVO;
		}
		
		
	}
}