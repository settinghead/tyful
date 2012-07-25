package com.settinghead.tyful.client.view
{
	import com.settinghead.tyful.client.ApplicationFacade;
	import com.settinghead.tyful.client.model.TuProxy;
	import com.settinghead.tyful.client.view.components.Application;
	
	import mx.controls.Alert;
	
	import net.codestore.flex.Mask;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class ApplicationMediator extends Mediator
	{
		public static const NAME:String = "ApplicationMediator";
		private var tuProxy:TuProxy;
		
		public function ApplicationMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void
		{
			this.tuProxy = facade.retrieveProxy(TuProxy.NAME) as TuProxy;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.RENDER_TU,
				ApplicationFacade.EDIT_TEMPLATE,
				ApplicationFacade.TEMPLATE_SAVED,
				ApplicationFacade.DOWNLOAD_TEMPLATE,
				ApplicationFacade.TEMPLATE_LOADED,
				ApplicationFacade.TEMPLATE_CREATED,
				ApplicationFacade.TEMPLATE_UPLOADED,
				ApplicationFacade.UPLOAD_TEMPLATE,
				ApplicationFacade.GENERATE_TEMPLATE_PREVIEW,
				ApplicationFacade.TEMPLATE_PREVIEW_GENERATED,
				ApplicationFacade.SHOW_SHOP
				
			];
		}
		
		override public function handleNotification( note:INotification ):void
		{
			switch ( note.getName() )
			{		
				case ApplicationFacade.RENDER_TU:
//					hideAll();
					applicationComponent.mainArea.currentState="render";
					break;
				
				case ApplicationFacade.EDIT_TEMPLATE:
				case ApplicationFacade.TEMPLATE_CREATED:
					applicationComponent.mainArea.currentState="edit";
					applicationComponent.currentState = "withoutShop";

					break;
				case ApplicationFacade.TEMPLATE_SAVED:
					applicationComponent.mainArea.currentState="edit";
					applicationComponent.currentState = "withoutShop";
					applicationComponent.parent.stage.focus = applicationComponent.mainArea.templateEditor; 
					break;
				
				case ApplicationFacade.SHOW_SHOP:
					if((applicationComponent as Application).mainArea.tuRenderer.visible)
						applicationComponent.currentState = "withShop";
					break;
				
				case ApplicationFacade.DOWNLOAD_TEMPLATE:
					Mask.show("Loading template... ");
					break;
				case ApplicationFacade.GENERATE_TEMPLATE_PREVIEW:
					Mask.show("Tyful is creating a sample artwork so that your artwork can be displayed in the public gallery. Just a moment.");
					break;
				case ApplicationFacade.TEMPLATE_LOADED:
				case ApplicationFacade.TEMPLATE_UPLOADED:
//				case ApplicationFacade.TEMPLATE_PREVIEW_GENERATED:
					Mask.close();
					break;
			}
		}
		
//		private function hideAll():void{
//			applicationComponent.mainArea.tuRenderer.visible = false;
//			applicationComponent.mainArea.templateEditor.visible = false;
//		}
		
		private function get applicationComponent ():Application
		{
			return viewComponent as Application;
		}
	}
}