package com.settinghead.wenwentu.client.model.vo
{
	import com.settinghead.wenwentu.client.sizers.WordSizer;
	
	import flash.display.Sprite;
	import flash.text.TextField;

	public class DisplayWordVO extends Sprite
	{
		private var _engineWord: EngineWordVO;
		
		public function DisplayWordVO(eWord:EngineWordVO){
			super();
			this._engineWord = eWord;
		}
		
		public function get engineWord():EngineWordVO{
			return this._engineWord;
		}
	}
}