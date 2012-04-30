package com.settinghead.wexpression.client.view
{
	import com.settinghead.wexpression.client.ApplicationFacade;
	import com.settinghead.wexpression.client.view.components.Application;
	
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
				ApplicationFacade.RENDER_TU,
				ApplicationFacade.TU_GENERATED,
				ApplicationFacade.EDIT_TEMPLATE,
				ApplicationFacade.TEMPLATE_SAVED,
				
			];
		}
		
		override public function handleNotification( note:INotification ):void
		{
			switch ( note.getName() )
			{		
				case ApplicationFacade.RENDER_TU:
					hideAll();
					applicationComponent.vwStack.selectedChild = applicationComponent.tuRenderer; 
					break;
				
				case ApplicationFacade.EDIT_TEMPLATE:
					applicationComponent.vwStack.selectedChild = applicationComponent.templateEditor;
					applicationComponent.currentState = "withoutShop";

					break;
				case ApplicationFacade.TEMPLATE_SAVED:
					applicationComponent.vwStack.selectedChild = applicationComponent.templateEditor; 
					applicationComponent.currentState = "withoutShop";
					applicationComponent.parent.stage.focus = applicationComponent.templateEditor; 
					break;
				
				case ApplicationFacade.TU_GENERATED:
					applicationComponent.currentState = "withShop";
					break;
			}
		}
		
		private function hideAll():void{
			applicationComponent.tuRenderer.visible = false;
			applicationComponent.templateEditor.visible = false;
		}
		
		private function get applicationComponent ():Application
		{
			return viewComponent as Application;
		}
	}
}