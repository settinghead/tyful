package com.settinghead.wenwentu.client.view
{
	import com.settinghead.wenwentu.client.ApplicationFacade;
	import com.settinghead.wenwentu.client.model.TemplateProxy;
	import com.settinghead.wenwentu.client.model.vo.TemplateVO;
	import com.settinghead.wenwentu.client.view.components.TuRenderer;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class TemplateMediator extends Mediator
	{
		
		public static const NAME:String = "TemplateMediator";
		private var templateProxy:TemplateProxy;

		public function TemplateMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void
		{
//			templateRenderer.addEventListener( TemplateForm.ADD, onAdd );
//			templateRenderer.addEventListener( TemplateForm.UPDATE, onUpdate );
//			templateRenderer.addEventListener( TemplateForm.CANCEL, onCancel );
//			
			templateProxy = TemplateProxy( facade.retrieveProxy( TemplateProxy.NAME ) );
		}
		
		override public function listNotificationInterests():Array
		{
			return [
//				ApplicationFacade.NEW_TEMPLATE,
//				ApplicationFacade.TEMPLATE_DELETED,
				ApplicationFacade.TEMPLATE_SELECTED
				
			];
		}
		
		override public function handleNotification( note:INotification ):void
		{
			switch ( note.getName() )
			{		
				case ApplicationFacade.TEMPLATE_SELECTED:
					//TODO
			}
		}
		
//		private function onAdd( event:Event ):void
//		{
//			templateProxy.addItem( templateRenderer.template );
//			sendNotification( ApplicationFacade.USER_ADDED, templateRenderer.template );
//			templateRenderer.reset();
//		}
//		
//		private function onUpdate( event:Event ):void
//		{
//			templateProxy.updateItem( templateRenderer.template );
//			sendNotification(  ApplicationFacade.USER_UPDATED, templateRenderer.template );
//			templateRenderer.reset();
//		}
//		
//		private function onCancel( event:Event ):void
//		{
//			sendNotification( ApplicationFacade.CANCEL_SELECTED );
//			templateRenderer.reset();
//		}
		
		private function get Renderer ():TuRenderer
		{
			return viewComponent as TuRenderer;
		}
	}
}