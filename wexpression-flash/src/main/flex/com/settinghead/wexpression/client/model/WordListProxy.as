package com.settinghead.wexpression.client.model
{
	import com.adobe.serialization.json.JSONDecoder;
	import com.settinghead.wexpression.client.ApplicationFacade;
	import com.settinghead.wexpression.client.model.vo.wordlist.WordListVO;
	import com.settinghead.wexpression.client.model.vo.wordlist.WordVO;
	
	import de.aggro.utils.CookieUtil;
	
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.setTimeout;
	import flash.xml.XMLDocument;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.messaging.Consumer;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	import mx.rpc.remoting.RemoteObject;
	import mx.rpc.xml.SimpleXMLDecoder;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
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
				
				//var wordListId:String = FlexGlobals.topLevelApplication.parameters.wordListId as String;
				var request : URLRequest = new URLRequest  ( "/word_list/recent" );
				var urlVariables : URLVariables = new URLVariables ();
				request.data = urlVariables;
				request.method = URLRequestMethod.GET;
				loader = new URLLoader ();
				loader.addEventListener( Event.COMPLETE, jsonLoaded );
				loader.load ( request );

			}
		}
		
		public function jsonLoaded(e:Event):void{
			var obj:Object = new JSONDecoder(loader.data as String,false).getValue();
			if(obj is Array){
				var l:Array = (obj as Object) as Array;
				var wordList:WordListVO = new WordListVO(l);
				this._list = wordList;
			}
			else{
				//retry
				setTimeout(load,3000);
			}
		}
	
		
		public function get currentWordList():WordListVO{
			return _list;
		}

		public function sampleWordList():WordListVO{
			var list:WordListVO = new WordListVO();
			for(var i:int=0;i<1000;i++){
				list.add(new WordVO("Art", Math.random()*5+0.5));
				list.add(new WordVO("Sample", Math.random()*5+0.5));
				list.add(new WordVO("Created by Wexpression", Math.random()*5+0.5));
				list.add(new WordVO("typography", Math.random()*5+0.5));
			}
			return list;
		}
	}
}