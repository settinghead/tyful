package com.settinghead.wexpression.client.model
{
	import com.settinghead.wexpression.client.ApplicationFacade;
	import com.settinghead.wexpression.client.model.vo.WordListVO;
	import com.settinghead.wexpression.client.model.vo.WordVO;
	
	import de.aggro.utils.CookieUtil;
	
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.xml.XMLDocument;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.messaging.Consumer;
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
		
		public function WordListProxy(data:Object=null)
		{
			super(NAME, null);
		}
		
		public function load() :void{
			if(this._list==null){
				var req : URLRequest = new URLRequest("WordList.xml");
				var loader : URLLoader = new URLLoader();
				var params : URLVariables = new URLVariables();
				params.id = CookieUtil.getCookie("wordListId");
				params.auth_token = CookieUtil.getCookie("authToken");
				req.data = params;
				req.method = URLRequestMethod.POST;
				loader.addEventListener("complete", handleResult);
				loader.load(req);
				
			}
		}
		
		private function handleResult(event:Event):void{
			var wordArray:ArrayCollection = xmlToArrayCollection(event.target.data as String);
			this._list = new WordListVO( wordArray );
			sendLoadedNotification( ApplicationFacade.WORD_LIST_LOADED, NAME, SRNAME );
		}
		
		private function handleFault(event:FaultEvent):void{
			Alert.show(event.fault.message);
		}
		
		private function xmlToArrayCollection(xmlStr:String):ArrayCollection{
			var xmlDocument:XMLDocument = new XMLDocument(xmlStr);
			var xmlDecoder:SimpleXMLDecoder = new SimpleXMLDecoder(true);
			var resultObj:Object = xmlDecoder.decodeXML(xmlDocument);
			var tmp : Object = resultObj.wordList.word;
			return resultObj.wordList.word as ArrayCollection;
		}
		
		public function get currentWordList():WordListVO{
			return _list;
		}
		
		private static function generateWords():WordListVO{
			var list:WordListVO = new WordListVO();
			for(var i:int=0;i<80;i++){
				list.add(new WordVO("Freedomize", Math.random()*5+0.5));
				list.add(new WordVO("philosophy", Math.random()*5+0.5));
				list.add(new WordVO("Ministry of Tofu", Math.random()*5+0.5));
				list.add(new WordVO("form of forms", Math.random()*5+0.5));
				list.add(new WordVO("sand", Math.random()*5+0.5));
				list.add(new WordVO("beach", Math.random()*5+0.5));
				list.add(new WordVO("for the lulz", Math.random()*5+0.5));
				list.add(new WordVO("Bloom", Math.random()*5+0.5));	
				list.add(new WordVO("MOLLY", Math.random()*5+0.5));			
				list.add(new WordVO("shake spear", Math.random()*5+0.5));
			}
			return list;
		}
	}
}