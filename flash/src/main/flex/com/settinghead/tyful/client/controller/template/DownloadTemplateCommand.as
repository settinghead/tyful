package com.settinghead.tyful.client.controller.template
{
	import com.settinghead.tyful.client.ApplicationFacade;
	import com.settinghead.tyful.client.model.TemplateProxy;
	
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.managers.CursorManager;
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class DownloadTemplateCommand extends SimpleCommand
	{
		override public function execute( note:INotification ) : void    {
			var templateProxy:TemplateProxy =
				facade.retrieveProxy(TemplateProxy.NAME) as TemplateProxy;
			templateProxy.templateIdToLoad = 
				decodeURIComponent(FlexGlobals.topLevelApplication.parameters.templateUuid) as String;
			templateProxy.load();
		}
		
	}
}