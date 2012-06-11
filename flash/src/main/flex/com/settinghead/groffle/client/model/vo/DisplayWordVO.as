package com.settinghead.groffle.client.model.vo
{
	import com.notifications.Notification;
	import com.settinghead.groffle.client.sizers.WordSizer;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	
	import mx.core.UIComponent;
	import mx.states.AddChild;

	public class DisplayWordVO extends Sprite
	{
		private var _engineWord: EngineWordVO;
		private var _textField:TextField;
		
		
		public function DisplayWordVO(eWord:EngineWordVO){
			super();
			this._engineWord = eWord;
			this.useHandCursor = true;
			this.buttonMode = true;
			this.mouseChildren = true;

		}
		
		public function set textField(t:TextField):void{
			if(t==null && _textField!=null){
				super.removeChild(_textField);
			}
			this._textField=t;
			if(_textField!=null)
				super.addChild(_textField);
		}
		
		public function get textField():TextField{
			return _textField;
		}
		
		public function get engineWord():EngineWordVO{
			return this._engineWord;
		}
		
		
	}
}