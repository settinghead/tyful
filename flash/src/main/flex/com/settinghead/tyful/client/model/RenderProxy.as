package com.settinghead.tyful.client.model
{
	import com.settinghead.tyful.client.ApplicationFacade;
	import com.settinghead.tyful.client.model.vo.DisplayWordVO;
	import com.settinghead.tyful.client.model.vo.template.TemplateVO;
	
	import flash.events.Event;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	import flash.system.WorkerState;
	
	import mx.core.FlexGlobals;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.utilities.loadup.interfaces.ILoadupProxy;
	
	public class RenderProxy extends EntityProxy implements IProxy, ILoadupProxy
	{
		
		public static const NAME:String = "RenderProxy";
		public static const SRNAME:String = "RenderSRProxy";
		private var renderWorker:Worker;
		private var resultChannel:MessageChannel;
		private var statusChannel:MessageChannel;
		private var controlChannel:MessageChannel;
		private var _generator:ITuImageGenerator = null;
		private function get generator():ITuImageGenerator{
			if(_generator==null)
				_generator = FlexGlobals.topLevelApplication["tuImageGenerator"];
			return _generator;
		}

		private var tuProxy:TuProxy = null;

		
		public function RenderProxy()
		{
			super(NAME, data);
			//TODO
			load();
		}
		
		public function load():void{
			renderWorker = WorkerDomain.current.createWorker(Workers.com_settinghead_tyful_client_algo_PolarWorker);
			controlChannel = Worker.current.createMessageChannel(renderWorker);
			renderWorker.setSharedProperty("controlChannel", controlChannel);
			
			resultChannel = Worker.current.createMessageChannel(renderWorker);
			resultChannel.addEventListener(Event.CHANNEL_MESSAGE, handleResultMessage);
			renderWorker.setSharedProperty("resultChannel", resultChannel);
			
			statusChannel = Worker.current.createMessageChannel(renderWorker);
			statusChannel.addEventListener(Event.CHANNEL_MESSAGE, handleStatusMessage);
			renderWorker.setSharedProperty("statusChannel", statusChannel);
			
			renderWorker.addEventListener(Event.WORKER_STATE, handleBGWorkerStateChange);
			if(tuProxy==null)tuProxy = facade.retrieveProxy(TuProxy.NAME) as TuProxy;
		}
		
		public function updateTemplate(template:TemplateVO){
			controlChannel.send(["template",template]);
		}
		public function startRender(){
			controlChannel.send(["start"]);
		}
		
		private function handleResultMessage(event:Event):void
		{
			var dw:DisplayWordVO = statusChannel.receive() as DisplayWordVO;
			if (dw != null){
				tuProxy.tu.dWords.addItem(dw);
				facade.sendNotification(ApplicationFacade.DISPLAYWORD_CREATED, dw);
			}
		}
		
		private function handleStatusMessage(event:Event):void{
			var message:Array = statusChannel.receive() as Array;
			if (message != null){
				if(message[0] == "complete"){
					if(tuProxy.generateTemplatePreview){
						tuProxy.tu.template.preview = generator.canvasImage(300);
						facade.sendNotification(ApplicationFacade.TEMPLATE_PREVIEW_GENERATED);
					}
				}
			}
		}
		
		private function handleBGWorkerStateChange(event:Event):void{
			//TODO
			if (renderWorker.state == WorkerState.RUNNING) 
			{
				sendLoadedNotification( ApplicationFacade.RENDER_ENGINE_LOADED, NAME, SRNAME);
			}
		}
		
		
	}
}