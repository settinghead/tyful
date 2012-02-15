package com.settinghead.wexpression.client.model.business
{
	
	import com.settinghead.wexpression.client.model.business.services.WordListService;
	import com.settinghead.wexpression.client.model.vo.template.Template;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.CallResponder;
	import mx.rpc.IResponder;
	import mx.rpc.remoting.RemoteObject;
	import flash.net.*;
	
	
	public class TemplateDelegate
	{
		private var service:RemoteObject;
		private var resp:IResponder;
		
		public function TemplateDelegate(r:IResponder):void
		{
			service = new RemoteObject("templateService");
			resp = r;
		}
		
		public function getTemplate(id:String):void 
		{
			var token:AsyncToken = service.getTemplate(id);
			token.addResponder(resp);
		}
		
		public function saveTemplate(template:Template):void{

			var token:AsyncToken = service.saveTemplate(Template);
			token.addResponder(resp);
		}
	
		
	}
}