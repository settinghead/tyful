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
			tuRenderer.addEventListener(TuRenderer.CHECK_CREATE_NEXT_DISPLAYWORD, checkCreateNextDisplayWord);
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
				ApplicationFacade.RENDER_TU,
				ApplicationFacade.DISPLAYWORD_CREATED,
				ApplicationFacade.TU_GENERATION_LAST_CALL,
				ApplicationFacade.TU_IMAGE_GENERATED,
				ApplicationFacade.GENERATE_TU_IMAGE,
			];
		}
		
		override public function handleNotification( note:INotification ):void
		{
			switch ( note.getName() )
			{
				case ApplicationFacade.RENDER_TU:
					tuRenderer.tu =  tuProxy.tu;
					tuProxy.markStartRendering();
					break;
				case ApplicationFacade.DISPLAYWORD_CREATED:
					if(note.getBody()!=null)
						tuRenderer.slapWord(note.getBody() as DisplayWordVO);
					break;
				case ApplicationFacade.TU_GENERATION_LAST_CALL:
					tuRenderer.generateImage();
					if(tuProxy.generateTemplatePreview){
						tuProxy.tu.template.preview = tuRenderer.canvasImage(300);
						tuProxy.generateTemplatePreview = false;

						sendNotification(ApplicationFacade.TEMPLATE_PREVIEW_GENERATED);
						
					}
					else if(tuRenderer.tu.template.preview==null){
						tuProxy.tu.template.preview = tuRenderer.canvasImage(300);
					}
					break;
				case ApplicationFacade.TU_IMAGE_GENERATED:
					if(tuRenderer.autoPostToFacebook) tuProxy.postToFacebook();
					break;
				case ApplicationFacade.GENERATE_TU_IMAGE:
					tuRenderer.generateImage();
					break;
			}
		}
		
		private function get tuRenderer ():TuRenderer
		{
			return viewComponent as TuRenderer;
		}
		
		private function checkCreateNextDisplayWord( event:Event = null ):void
		{	
			if(tuRenderer.tu!=null){
				if(tuProxy.rendering){
					if(!waitingForWord){
						waitingForWord = true;
						var count:int = 0;
						while(tuProxy.rendering && ++count<2) 
							tuProxy.renderNextDisplayWord(tuRenderer.tu);
						waitingForWord = false;
					}				
				}
				else{
					if(tuRenderer.tu.generatedImage==null){
						facade.sendNotification(ApplicationFacade.GENERATE_TU_IMAGE);
					}
				}
			}
			
		}
		
		
		private function editTemplate( event:Event = null ):void
		{
			sendNotification(ApplicationFacade.EDIT_TEMPLATE, tuRenderer.tu.template);
		}
		
		private function tuGenerated( event: Event = null ):void{
			//finished rendering; dispatch TU_GENERATED event
			tuProxy.tu = tuRenderer.tu;
			sendNotification(ApplicationFacade.TU_IMAGE_GENERATED, tuRenderer.tu);
		}
	}
}