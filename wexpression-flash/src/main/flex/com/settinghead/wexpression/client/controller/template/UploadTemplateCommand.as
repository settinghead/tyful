package com.settinghead.wexpression.client.controller.template
{
	import com.settinghead.wexpression.client.ApplicationFacade;
	import com.settinghead.wexpression.client.model.TemplateProxy;
	import com.settinghead.wexpression.client.model.business.TemplateDelegate;
	import com.settinghead.wexpression.client.model.business.UploadPostHelper;
	import com.settinghead.wexpression.client.model.vo.template.TemplateVO;
	
	import flash.events.Event;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	import mx.managers.CursorManager;
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	
	public class UploadTemplateCommand extends SimpleCommand implements IResponder
	{
		private var templateProxy:TemplateProxy;
		override public function execute( note:INotification ) : void    {
			var template:TemplateVO = note.getBody() as TemplateVO;
			templateProxy = facade.retrieveProxy(TemplateProxy.NAME) as TemplateProxy;
			
			templateProxy.template = template;
			
			
//			if(template.previewPNG==null){
//				sendNotification(ApplicationFacade.GENERATE_TEMPLATE_PREVIEW, this);
//			}
//			else{
			result(null);
//			}
		}
		
		private var urlLoader : URLLoader;
		public function result(data:Object):void
		{
			var b:ByteArray = templateProxy.toFile();
			// set up the request & headers for the image upload;
			var urlRequest : URLRequest = new URLRequest();
			urlRequest.url = 'templates/u';
			var header:URLRequestHeader = new URLRequestHeader("Content-type", "application/octet-stream");
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.data = b;
			urlRequest.requestHeaders.push(header);
			// create the image loader & send the image to the server;
			urlLoader = new URLLoader();
//			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			urlLoader.addEventListener(Event.COMPLETE, uploadComplete);
			urlLoader.load( urlRequest );
			
		}
		
		public function fault(info:Object):void
		{
			CursorManager.removeBusyCursor();
			Alert.show("Error: "+ info.toString());
		}
		
		public function uploadComplete(e:Event):void{
			Alert.show(urlLoader.data as String);
			sendNotification(ApplicationFacade.TEMPLATE_UPLOADED);
		}
	}
}