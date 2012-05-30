package com.settinghead.groffle.client.model.vo
{
	import com.settinghead.groffle.client.sizers.WordSizer;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;

	public class DisplayWordVO extends Sprite
	{
		private var _engineWord: EngineWordVO;
		
		public function DisplayWordVO(eWord:EngineWordVO){
			super();
			this._engineWord = eWord;
			this.useHandCursor = true;
			this.buttonMode = true;
			this.mouseChildren = true;
//			this.addEventListener(MouseEvent.CLICK, handleMouseClick);
		}
		
//		private function handleMouseClick(e:MouseEvent):void{
//			if(this.engineWord.word.occurences!=null && this.engineWord.word.occurences.length>0){
//				navigateToURL(new URLRequest((this.engineWord.word.occurences[0].link) as String), '_blank');
//			}
//
//		}
		
		public function get engineWord():EngineWordVO{
			return this._engineWord;
		}
	}
}