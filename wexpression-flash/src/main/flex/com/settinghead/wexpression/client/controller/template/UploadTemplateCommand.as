package com.settinghead.wexpression.client.controller.template
{
	import com.settinghead.wexpression.client.ApplicationFacade;
	import com.settinghead.wexpression.client.model.TemplateProxy;
	import com.settinghead.wexpression.client.model.vo.template.TemplateVO;
	
	import flash.events.Event;
	import flash.external.ExternalInterface;
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
	
	import net.codestore.flex.Mask;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	
	public class UploadTemplateCommand extends SimpleCommand
	{
		private var templateProxy:TemplateProxy;
		override public function execute( note:INotification ) : void
		{
			
			templateProxy = facade.retrieveProxy(TemplateProxy.NAME) as TemplateProxy;
			
			var template:TemplateVO = templateProxy.template;
			
			
			if(template.preview==null){
				sendNotification(ApplicationFacade.GENERATE_TEMPLATE_PREVIEW, this);
			}
			else{
				Mask.show("Saving template...");
				ExternalInterface.call("submitForm");
				templateProxy.uploadTemplate();
			}
		}
		
		
	}
}