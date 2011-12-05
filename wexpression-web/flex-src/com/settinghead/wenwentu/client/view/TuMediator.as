package com.settinghead.wenwentu.client.view
{
	import com.settinghead.wenwentu.client.ApplicationFacade;
	import com.settinghead.wenwentu.client.model.TuProxy;
	import com.settinghead.wenwentu.client.model.vo.DisplayWordVO;
	import com.settinghead.wenwentu.client.model.vo.TuVO;
	import com.settinghead.wenwentu.client.view.components.TuRenderer;
	
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class TuMediator extends Mediator
	{
		public static const NAME:String = "TuMediator";
		private var tuProxy:TuProxy;
		
		public function TuMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			tuRenderer.addEventListener(TuRenderer.CREAT_NEXT_DISPLAYWORD, createNextDisplayWord);
			
		}
		
		override public function onRegister():void
		{
			tuProxy = TuProxy( facade.retrieveProxy( TuProxy.NAME ) );
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.TU_CREATED,
				ApplicationFacade.DISPLAYWORD_CREATED
			];
		}
		
		override public function handleNotification( note:INotification ):void
		{
			switch ( note.getName() )
			{		
				case ApplicationFacade.TU_CREATED:
					tuRenderer.tu =  note.getBody() as TuVO;
					break;
				case ApplicationFacade.DISPLAYWORD_CREATED:
					tuRenderer.slapWord(note.getBody() as DisplayWordVO);
			}
		}
		
		private function get tuRenderer ():TuRenderer
		{
			return viewComponent as TuRenderer;
		}
		
		private function createNextDisplayWord( event:Event = null ):void
		{
			tuProxy.renderNextDisplayWord(tuRenderer.tu);
		}
	}
}