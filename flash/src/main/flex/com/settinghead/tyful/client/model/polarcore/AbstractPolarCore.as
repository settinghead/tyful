package com.settinghead.tyful.client.model.polarcore
{
	import com.settinghead.tyful.client.model.vo.template.PlaceInfo;
	import com.settinghead.tyful.client.model.vo.template.TemplateVO;
	import com.settinghead.tyful.client.model.vo.wordlist.WordListVO;
	
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	public class AbstractPolarCore extends EventDispatcher
	{
		public static const RESULT:String = "result";
		public static const FEED:String = "feed";
		public static const LOAD_COMPLETE:String = "loadComplete";
		private var _place:PlaceInfo;
		
		public function get place():PlaceInfo{
			return _place;
		}
		
		public function addResultEventListener(listener:Function):void{
			addEventListener(RESULT,listener);
		}
		public function addFeedEventListener(listener:Function):void{
			addEventListener(FEED,listener);
		}
		public function load():void{
			throw new Error("Abstract class method.");
		}
		public function updateTemplate(template:TemplateVO):void{
			throw new Error("Abstract class method.");
		}
		public function startRender():void{
			throw new Error("Abstract class method.");
		}
		public function feedShape(sid:int,data:BitmapData,shrinkage:int):void{
			throw new Error("Abstract class method.");
		}
		public function updatePerseverance(perseverance:int):void{
			throw new Error("Abstract class method.");
		}
		public function pauseRender():void{
			throw new Error("Abstract class method.");
		}
		public function updateWordList(wordList:WordListVO):void{
			throw new Error("Abstract class method.");
		}
		
	}
}