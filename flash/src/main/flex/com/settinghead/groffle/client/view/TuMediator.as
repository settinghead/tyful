package com.settinghead.groffle.client.view
{
	import com.settinghead.groffle.client.ApplicationFacade;
	import com.settinghead.groffle.client.model.TuProxy;
	import com.settinghead.groffle.client.model.vo.DisplayWordVO;
	import com.settinghead.groffle.client.model.vo.TuVO;
	import com.settinghead.groffle.client.view.components.TuRenderer;
	
	import flash.events.Event;
	
	import mx.controls.Alert;
	
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
			tuRenderer.addEventListener(TuRenderer.UPDATE_PROGRESS, updateProgress);
			tuRenderer.addEventListener(TuRenderer.EDIT_TEMPLATE, editTemplate);

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
				case ApplicationFacade.TU_IMAGE_GENERATED:					
					//TODO
					if(tuRenderer.autoPostToFacebook) 
					{
						tuProxy.postToFacebook();
						tuRenderer.autoPostToFacebook = false;
					}
					break;
			}
		}
		
		private function get tuRenderer ():TuRenderer
		{
			return viewComponent as TuRenderer;
		}
		
		private function updateProgress( event:Event = null ):void
		{	
			tuRenderer.perseveranceMeter.setProgress(tuProxy.failureCount, tuProxy.tu.template.perseverance);
			
		}
		
		
		private function editTemplate( event:Event = null ):void
		{
			sendNotification(ApplicationFacade.EDIT_TEMPLATE, tuRenderer.tu.template);
		}
	}
}