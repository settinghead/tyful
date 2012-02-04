package com.settinghead.wexpression.client.model.business
{
	
	import com.settinghead.wexpression.client.model.business.services.WordListService;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.CallResponder;
	import mx.rpc.IResponder;
	import mx.rpc.remoting.RemoteObject;
	
	
	public class WordListDelegate
	{
		private var service:WordListService;
		private var resp:IResponder;
		
		public function WordListDelegate(r:IResponder):void
		{
			service = new WordListService();
			resp = r;
		}
		
		public function getWordList(id:String):void 
		{
			var token:AsyncToken = service.getWordList(id);
			token.addResponder(resp);
		}
	
		
	}
}