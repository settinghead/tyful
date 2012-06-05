package com.settinghead.groffle.client.view
{
	import com.notifications.Notification;
	import com.settinghead.groffle.client.ApplicationFacade;
	import com.settinghead.groffle.client.model.TuProxy;
	import com.settinghead.groffle.client.model.vo.DisplayWordVO;
	import com.settinghead.groffle.client.model.vo.TuVO;
	import com.settinghead.groffle.client.view.components.TuRenderer;
	
	import de.aggro.utils.CookieUtil;
	
	import flash.events.Event;
	import flash.net.SharedObject;
	
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class TuMediator extends Mediator
	{
		public static const NAME:String = "TuMediator";
		private var tuProxy:TuProxy;
		private var waitingForWord:Boolean = false;
		
		public function TuMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			tuRenderer.addEventListener(TuRenderer.EDIT_TEMPLATE, editTemplate);
			tuRenderer.addEventListener(TuRenderer.POST_TO_FACEBOOK, postToFacebook);
			tuRenderer.addEventListener(TuRenderer.RESUME_RENDERING, resumeRendering);
			tuRenderer.addEventListener(TuRenderer.RERENDER, rerender);

		}
		
		override public function onRegister():void
		{
			tuProxy = TuProxy( facade.retrieveProxy( TuProxy.NAME ) );
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.RENDER_TU,
				ApplicationFacade.DISPLAYWORD_CREATED,
				ApplicationFacade.TU_GENERATION_LAST_CALL
			];
		}
		
		override public function handleNotification( note:INotification ):void
		{
			switch ( note.getName() )
			{
				case ApplicationFacade.RENDER_TU:
					tuRenderer.tu =  tuProxy.tu;

					break;
				case ApplicationFacade.DISPLAYWORD_CREATED:
					if(note.getBody()!=null)
						tuRenderer.slapWord(note.getBody() as DisplayWordVO);
					break;
				case ApplicationFacade.TU_GENERATION_LAST_CALL:					
					//TODO
					if(tuRenderer.autoPostToFacebook) 
					{
						sendNotification(ApplicationFacade.POST_TO_FACEBOOK);
						tuRenderer.autoPostToFacebook = false;
					}
					
					if(!tuProxy.generateTemplatePreview)
						Notification.show("Click on words to check out where they come from.","Hint",null,10000,
							Notification.NOTIFICATION_POSITION_BOTTOM_LEFT);
					break;
			}
		}
		
		private function get tuRenderer ():TuRenderer
		{
			return viewComponent as TuRenderer;
		}

		
		
		private function editTemplate( event:Event = null ):void
		{
			sendNotification(ApplicationFacade.EDIT_TEMPLATE, tuRenderer.tu.template);
		}
		
		private function postToFacebook( event:Event = null ):void
		{
			sendNotification(ApplicationFacade.POST_TO_FACEBOOK);
		}
		
		private function resumeRendering( event:Event = null ):void
		{
			tuProxy.startRender();
		}
		private function rerender( event:Event = null ):void
		{
			sendNotification(ApplicationFacade.RENDER_TU);
		}
	}
}