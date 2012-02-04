package com.settinghead.wexpression.client.view
{
	import com.settinghead.wexpression.client.ApplicationFacade;
	import com.settinghead.wexpression.client.model.TuProxy;
	import com.settinghead.wexpression.client.model.vo.DisplayWordVO;
	import com.settinghead.wexpression.client.model.vo.TuVO;
	import com.settinghead.wexpression.client.view.components.TuRenderer;
	
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class TuMediator extends Mediator
	{
		public static const NAME:String = "TuMediator";
		private var tuProxy:TuProxy;
		private var waitingForWord = false;

		public function TuMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			tuRenderer.addEventListener(TuRenderer.CREAT_NEXT_DISPLAYWORD, createNextDisplayWord);
			tuRenderer.addEventListener(TuRenderer.EDIT_TEMPLATE, editTemplate);
			tuRenderer.addEventListener(TuRenderer.TU_GENERATED, tuGenerated);

		}
		
		override public function onRegister():void
		{
			tuProxy = TuProxy( facade.retrieveProxy( TuProxy.NAME ) );
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.TU_INITIALIZED,
				ApplicationFacade.DISPLAYWORD_CREATED
			];
		}
		
		override public function handleNotification( note:INotification ):void
		{
			switch ( note.getName() )
			{
				case ApplicationFacade.TU_INITIALIZED:
					tuRenderer.tu =  note.getBody() as TuVO;
					break;
				case ApplicationFacade.DISPLAYWORD_CREATED:
					if(note.getBody()!=null)
						tuRenderer.slapWord(note.getBody() as DisplayWordVO);
					break;
			}
		}
		
		private function get tuRenderer ():TuRenderer
		{
			return viewComponent as TuRenderer;
		}
		
		private function createNextDisplayWord( event:Event = null ):void
		{	
			if(!waitingForWord){
				waitingForWord = true;
				var count:int = 0;
				while(!tuRenderer.tu.finishedDisplayWordRendering && ++count<3) 
					tuProxy.renderNextDisplayWord(tuRenderer.tu);
				waitingForWord = false;
			}
			else trace("a");
		}
		
		private function editTemplate( event:Event = null ):void
		{
			sendNotification(ApplicationFacade.EDIT_TEMPLATE, tuRenderer.tu.template);
		}
		
		private function tuGenerated( event: Event = null ):void{
			//finished rendering; dispatch TU_GENERATED event
				sendNotification(ApplicationFacade.TU_GENERATED, tuRenderer.tu);
		}
	}
}