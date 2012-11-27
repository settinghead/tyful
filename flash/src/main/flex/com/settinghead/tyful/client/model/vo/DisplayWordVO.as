package com.settinghead.tyful.client.model.vo
{	
	import com.settinghead.tyful.client.model.vo.template.PlaceInfo;
	import com.settinghead.tyful.client.model.vo.wordlist.WordVO;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class DisplayWordVO extends Sprite
	{
		private var _textField:TextField;
		private var _word:WordVO = null;
		private var _place:PlaceInfo = null;
		
		public function DisplayWordVO(word:WordVO, place:PlaceInfo){
			super();
			this.useHandCursor = true;
			this.buttonMode = true;
			this.mouseChildren = true;
			this._word = word;
			this._place = place;
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
		
		public function get word():WordVO{
			return _word;
		}
		
		public function get place():PlaceInfo{
			return _place;
		}
		
	}
}