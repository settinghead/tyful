package com.settinghead.wenwentu.client.view
{
	import com.settinghead.wenwentu.client.ApplicationFacade;
	import com.settinghead.wenwentu.client.model.TemplateProxy;
	
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import com.settinghead.wenwentu.client.view.components.template.TemplateList;
	
	public class TemplateListMediator extends Mediator
	{
		private var templateProxy:TemplateProxy;
		
		public static const NAME:String = "TemplateListMediator";
		public function TemplateListMediator(viewComponent:TemplateList)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void
		{
			templateList.addEventListener( TemplateList.SELECT, onSelect );
			
			templateProxy = TemplateProxy( facade.retrieveProxy( TemplateProxy.NAME ) );
			templateList.templates = templateProxy.templates;
		}
		
		private function get templateList():TemplateList
		{
			return viewComponent as TemplateList;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
			
			];
		}
		
		override public function handleNotification( note:INotification ):void
		{
//			switch ( note.getName() )
//			{
//				case ApplicationFacade.CANCEL_SELECTED:
//					templateList.deSelect();
//					break;
//				
//				case ApplicationFacade.TEMPLATE_UPDATED:
//					templateList.deSelect();
//					break;
//				
//			}
		}
		
		
		private function onSelect( event:Event ):void
		{
			sendNotification( ApplicationFacade.TEMPLATE_SELECTED,
				templateList.selectedTemplate );
		}
	}
}