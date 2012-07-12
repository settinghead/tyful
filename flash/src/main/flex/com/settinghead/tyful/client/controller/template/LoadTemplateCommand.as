package com.settinghead.tyful.client.controller.template
{
	import com.settinghead.tyful.client.ApplicationFacade;
	import com.settinghead.tyful.client.model.TemplateProxy;
	
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	import mx.managers.CursorManager;
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class LoadTemplateCommand extends SimpleCommand
	{
		override public function execute( note:INotification ) : void    {
			var data:ByteArray = note.getBody() as ByteArray;
			var templateProxy:TemplateProxy = facade.retrieveProxy(TemplateProxy.NAME) as TemplateProxy;
			templateProxy.fromFile(data);
			sendNotification(ApplicationFacade.TEMPLATE_LOADED);
		}
	}
}