package com.settinghead.wexpression.client.controller.main
{
	import com.settinghead.wexpression.client.ApplicationFacade;
	import com.settinghead.wexpression.client.model.TemplateProxy;
	import com.settinghead.wexpression.client.model.TuProxy;
	import com.settinghead.wexpression.client.model.vo.template.TemplateVO;
	import com.settinghead.wexpression.client.model.vo.TuVO;
	import com.settinghead.wexpression.client.model.vo.WordListVO;
	
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.utilities.loadup.model.LoadupMonitorProxy;
	
	public class PrepSampleTUCommand extends SimpleCommand
	{
	
		public function PrepSampleTUCommand()
		{
			super();
		}
		
		override public function execute( note:INotification ) : void    
		{
			var templateProxy:TemplateProxy = facade.retrieveProxy(TemplateProxy.NAME) as TemplateProxy;
			templateProxy.templatePath = "resources/templates/egg.png";
			
			var monitor:LoadupMonitorProxy = facade.retrieveProxy(LoadupMonitorProxy.NAME) as LoadupMonitorProxy;
			monitor.loadResources();
		}
	}
}