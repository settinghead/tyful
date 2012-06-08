package com.settinghead.groffle.client.model
{
	import com.adobe.serialization.json.JSONDecoder;
	import com.notifications.Notification;
	import com.settinghead.groffle.client.model.vo.wordlist.WordListVO;
	import com.settinghead.groffle.client.model.vo.wordlist.WordVO;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.setTimeout;
	
	import org.puremvc.as3.utilities.loadup.interfaces.ILoadupProxy;
	
	public class WordListProxy extends EntityProxy implements ILoadupProxy
	{
		public static const NAME:String = "WordListProxy";
		public static const SRNAME:String = "WordListSRProxy";

		private var _list:WordListVO = null;
		
		public function WordListProxy()
		{
			super(NAME, null);
		}
		
		private var loader : URLLoader;
		public function load() :void{
			if(this._list==null){
				//var wordListId:String = decodeURIComponent(FlexGlobals.topLevelApplication.parameters.wordListId) as String;
				var request : URLRequest = new URLRequest  ( "/word_list/facebook/me" );
				var urlVariables : URLVariables = new URLVariables ();
				request.data = urlVariables;
				request.method = URLRequestMethod.GET;
				loader = new URLLoader ();
				loader.addEventListener( Event.COMPLETE, jsonLoaded );
				loader.load ( request );
			}
		}
		
		public function jsonLoaded(e:Event):void{

			var obj:Object =
				new JSONDecoder(loader.data as String,false).getValue();
			if( obj.status=="pending" 
					|| obj.status=="requested"
			){

				setTimeout(load,2000);
			}
			else if(obj.error !=null )
			{
				
				Notification.show(obj.error as String,"Reminder");
				sampleWordList();
			}
			else{
				var l:Array = (obj as Object) as Array;
				var wordList:WordListVO = new WordListVO(l);
				this._list = wordList;

			}
		}
	
		
		public function get currentWordList():WordListVO{
			return _list;
		}

		public function sampleWordList():void{
			this._list = new WordListVO([
					new WordVO("Groffle", Math.random()*5+0.5),
					new WordVO("fun", Math.random()*5+0.5),
					new WordVO("create", Math.random()*5+0.5),
					new WordVO("Your name", Math.random()*5+0.5),
					new WordVO("Create your own!", Math.random()*5+0.5)
			]);
		}
	}
}