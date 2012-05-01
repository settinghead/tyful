package com.settinghead.wexpression.client.controller.template
{
	import com.settinghead.wexpression.client.ApplicationFacade;
	import com.settinghead.wexpression.client.model.TemplateProxy;
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
		
		public function result(data:Object):void
		{
			templateProxy.uploadTemplate();
			
		}
		
		public function fault(info:Object):void
		{
			CursorManager.removeBusyCursor();
			Alert.show("Error: "+ info.toString());
		}
		
		
	}
}