package com.settinghead.wexpression.client.controller.main
{
	import com.settinghead.wexpression.client.ApplicationFacade;
	import com.settinghead.wexpression.client.model.TemplateProxy;
	import com.settinghead.wexpression.client.model.TuProxy;
	import com.settinghead.wexpression.client.model.vo.TuVO;
	import com.settinghead.wexpression.client.model.vo.WordListVO;
	import com.settinghead.wexpression.client.model.vo.template.TemplateVO;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	
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
			
			var templates :Array = new Array(
				"resources/templates/egg.png",
				"resources/templates/face.png",
				"resources/templates/wheel_h.png",
				"resources/templates/wheel_v.png",
				"resources/templates/dog.png",
				"resources/templates/heart.png"
			);
			var randomNum:int = Math.floor(Math.random() * (templates.length));
			templateProxy.templatePath = templates[randomNum];
			
			var monitor:LoadupMonitorProxy = facade.retrieveProxy(LoadupMonitorProxy.NAME) as LoadupMonitorProxy;
			monitor.loadResources();
		}
	}
}