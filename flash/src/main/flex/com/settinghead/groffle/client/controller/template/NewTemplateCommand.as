package com.settinghead.groffle.client.controller.template
{
	import com.settinghead.groffle.client.ApplicationFacade;
	import com.settinghead.groffle.client.model.TemplateProxy;
	import com.settinghead.groffle.client.model.vo.template.TemplateVO;
	
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	import mx.managers.CursorManager;
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class NewTemplateCommand extends SimpleCommand
	{
		override public function execute( note:INotification ) : void    {
			var templateProxy:TemplateProxy = facade.retrieveProxy(TemplateProxy.NAME) as TemplateProxy;
			templateProxy.newTemplate();
			sendNotification(ApplicationFacade.EDIT_TEMPLATE);
		}
	}
}