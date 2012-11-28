package com.settinghead.tyful.client.model
{
	import com.settinghead.tyful.client.ApplicationFacade;
	import com.settinghead.tyful.client.model.vo.DisplayWordVO;
	import com.settinghead.tyful.client.model.vo.template.PlaceInfo;
	import com.settinghead.tyful.client.model.vo.template.TemplateVO;
	import com.settinghead.tyful.client.model.vo.wordlist.WordListVO;
	import com.settinghead.tyful.client.model.vo.wordlist.WordVO;
	
	import flash.events.Event;
	import flash.net.registerClassAlias;
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
			super(NAME, null);
			//TODO
			registerClassAlias("com.settinghead.tyful.client.model.vo.wordlist.WordVO", WordVO);

		}
		
		private function get renderWorker():Worker{
			return getData() as Worker;
		}
		
		public function load():void{
			setData(WorkerDomain.current.createWorker(Workers.com_settinghead_tyful_client_algo_PolarWorker));
			controlChannel = Worker.current.createMessageChannel(renderWorker);
			renderWorker.setSharedProperty("controlChannel", controlChannel);
			
			resultChannel = renderWorker.createMessageChannel(Worker.current);
			resultChannel.addEventListener(Event.CHANNEL_MESSAGE, handleResultMessage);
			renderWorker.setSharedProperty("resultChannel", resultChannel);
			
			statusChannel = renderWorker.createMessageChannel(Worker.current);
			statusChannel.addEventListener(Event.CHANNEL_MESSAGE, handleStatusMessage);
			renderWorker.setSharedProperty("statusChannel", statusChannel);
			
			renderWorker.addEventListener(Event.WORKER_STATE, handleBGWorkerStateChange);
			if(tuProxy==null)tuProxy = facade.retrieveProxy(TuProxy.NAME) as TuProxy;
			
			renderWorker.start();

		}
		
		public function updateTemplate(template:TemplateVO):void{
			controlChannel.send(["template",template.toTransferrableObject()]);
		}
		
		public function updateWordList(wordList:WordListVO):void{
			controlChannel.send(["words",wordList.toArray()]);
		}
		public function startRender():void{
			controlChannel.send(["start"]);
		}
		
		private function handleResultMessage(event:Event):void
		{
			var msg:Object = resultChannel.receive() as Object;
			var place:PlaceInfo = new PlaceInfo(msg["x"] as Number, msg["y"] as Number, msg["rotation"] as Number, msg["layer"] as int);
			var fontName:String = msg["fontName"];
			var fontSize:Number = msg["fontSize"];
			var word:WordVO = msg["word"] as WordVO;
			
			if (place != null){
				var dw:DisplayWordVO = new DisplayWordVO(word,fontName,fontSize,place);
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
		
		
		public override function setData(data:Object):void{			
			super.setData(data);
			if (this.data!=null) sendLoadedNotification( ApplicationFacade.SR_RENDER_ENGINE_LOADED, NAME, SRNAME);			
			if (this.data!=null) sendLoadedNotification( ApplicationFacade.RENDER_ENGINE_LOADED, NAME, SRNAME);	
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