package com.settinghead.wenwentu.client.view
{
	import com.settinghead.wenwentu.client.ApplicationFacade;
	import com.settinghead.wenwentu.client.view.components.Application;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class ApplicationMediator extends Mediator
	{
		public static const NAME:String = "ApplicationMediator";

		public function ApplicationMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void
		{
			
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.TU_INITIALIZED,
				ApplicationFacade.TU_GENERATED,
				ApplicationFacade.EDIT_TEMPLATE
			];
		}
		
		override public function handleNotification( note:INotification ):void
		{
			switch ( note.getName() )
			{		
				case ApplicationFacade.TU_INITIALIZED:
					applicationComponent.vwStack.selectedChild = applicationComponent.tuRenderer; 
					break;
				
				case ApplicationFacade.EDIT_TEMPLATE:
					applicationComponent.vwStack.selectedChild = applicationComponent.templateEditor; 
					break;
				
				case ApplicationFacade.TU_GENERATED:
					applicationComponent.currentState = "withShop";
					break;
			}
		}
		
		private function get applicationComponent ():Application
		{
			return viewComponent as Application;
		}
	}
}