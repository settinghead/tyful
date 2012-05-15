package com.settinghead.groffle.client.controller.main
{
	import com.settinghead.groffle.client.ApplicationFacade;
	import com.settinghead.groffle.client.model.TemplateProxy;
	import com.settinghead.groffle.client.model.TuProxy;
	import com.settinghead.groffle.client.model.vo.TuVO;
	import com.settinghead.groffle.client.model.vo.wordlist.WordListVO;
	import com.settinghead.groffle.client.model.vo.template.TemplateVO;
	
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
//				"resources/templates/egg_small.png"
//				,
				"resources/templates/face.png"
				,
				"resources/templates/wheel_h.png",
				"resources/templates/wheel_v.png",
				"resources/templates/dog.png",
				"resources/templates/heart.png",
				"resources/templates/apple.png"
			);
			var randomNum:int = Math.floor(Math.random() * (templates.length));
			templateProxy.templatePath = templates[randomNum];
			
			var monitor:LoadupMonitorProxy = facade.retrieveProxy(LoadupMonitorProxy.NAME) as LoadupMonitorProxy;
			monitor.loadResources();
		}
	}
}