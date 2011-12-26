package com.settinghead.wenwentu.client.controller
{
	import com.settinghead.wenwentu.client.ApplicationFacade;
	import com.settinghead.wenwentu.client.model.TuProxy;
	import com.settinghead.wenwentu.client.model.vo.TemplateVO;
	import com.settinghead.wenwentu.client.model.vo.TuVO;
	import com.settinghead.wenwentu.client.model.vo.WordListVO;
	
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class PrepSampleTUCommand extends SimpleCommand
	{
		private var template:TemplateVO;
		private  var tuProxy:TuProxy;
		
		public function PrepSampleTUCommand()
		{
			super();
		}
		
		override public function execute( note:INotification ) : void    
		{
			tuProxy = facade.retrieveProxy(TuProxy.NAME) as TuProxy;
			template = new TemplateVO("templates/dog.png");
			template.loadTemplate(templateLoadComplete);
		}
		
		private function templateLoadComplete(event:Event):void{

			facade.sendNotification(ApplicationFacade.EDIT_TEMPLATE, template);

		}
	}
}