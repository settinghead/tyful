package com.settinghead.tyful.client.model
{
	import com.settinghead.tyful.client.ApplicationFacade;
	import com.settinghead.tyful.client.model.vo.DisplayWordVO;
	import com.settinghead.tyful.client.model.vo.template.PlaceInfo;
	import com.settinghead.tyful.client.model.vo.template.TemplateVO;
	import com.settinghead.tyful.client.model.vo.template.WordLayer;
	import com.settinghead.tyful.client.model.vo.wordlist.WordListVO;
	import com.settinghead.tyful.client.model.vo.wordlist.WordVO;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.registerClassAlias;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	import flash.system.WorkerState;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.utilities.loadup.interfaces.ILoadupProxy;
	
	import polartree.PolarTree.CModule;
	import polartree.PolarTree.PolarTreeAPI;
	import polartree.PolarTree.addFeedRequestEventListener;
	import polartree.PolarTree.addSlapRequestEventListener;
	import polartree.PolarTree.threadArbConds;
	import polartree.PolarTree.vfs.ISpecialFile;
	
	public class RenderProxy extends EntityProxy implements IProxy, ILoadupProxy
	{
		[Embed(source="../fonter/konstellation/panefresco-500.ttf", fontFamily="panefresco500", mimeType='application/x-font',
        embedAsCFF='false', advancedAntiAliasing="true")]
		public static const Panefresco500: Class;
		[Embed(source="../fonter/konstellation/permanentmarker.ttf", fontFamily="permanentmarker", mimeType='application/x-font',
        embedAsCFF='false', advancedAntiAliasing="true")]
		public static const PermanentMarker: Class;
		[Embed(source="../fonter/konstellation/romeral.ttf", fontFamily="romeral", mimeType='application/x-font',
        embedAsCFF='false', advancedAntiAliasing="true")]
		public static const Romeral: Class;
		
		[Embed(source="../fonter/konstellation/bpreplay-kRB.ttf", fontFamily="bpreplay-kRB", mimeType='application/x-font',
        embedAsCFF='false', advancedAntiAliasing="true")]
		public static const BpreplayKRB: Class;
		[Embed(source="../fonter/konstellation/fifthleg-kRB.ttf", fontFamily="fifthleg-kRB", mimeType='application/x-font',
        embedAsCFF='false', advancedAntiAliasing="true")]
		public static const FifthlegKRB: Class;
		[Embed(source="../fonter/konstellation/pecita-kRB.ttf", fontFamily="pecita-kRB", mimeType='application/x-font',
        embedAsCFF='false', advancedAntiAliasing="true")]
		public static const PecitaKRB: Class;
		[Embed(source="../fonter/konstellation/sniglet-kRB.ttf", fontFamily="sniglet-kRB", mimeType='application/x-font',
        embedAsCFF='false', advancedAntiAliasing="true")]
		public static const snigletKRB: Class;
		
		public static const NAME:String = "RenderProxy";
		public static const SRNAME:String = "RenderSRProxy";
		public static var current:RenderProxy;
		
		private var resultChannel:MessageChannel;
		private var statusChannel:MessageChannel;
		private var controlChannel:MessageChannel;
		private var _generator:ITuImageGenerator = null;
		private var wDict:Vector.<DisplayWordVO>;
		private var wordList:WordListVO = null;
		
		private function get generator():ITuImageGenerator{
			if(_generator==null)
				_generator = FlexGlobals.topLevelApplication["tuImageGenerator"];
			return _generator;
		}
		
		private var _tuProxy:TuProxy = null;
		private function get tuProxy():TuProxy{
			if(_tuProxy==null) _tuProxy = facade.retrieveProxy(TuProxy.NAME) as TuProxy;
			return _tuProxy;
		}
		
		public function RenderProxy()
		{
			super(NAME, null);
			//TODO
			registerClassAlias("com.settinghead.tyful.client.model.vo.wordlist.WordVO", WordVO);
			RenderProxy.current = this;
			
			
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
						renderWorker.start();
			
//			setData(1);
			
		}
		
		public function updateTemplate(template:TemplateVO):void{
						controlChannel.send(["template",template.toTransferrableObject()]);
//			var currentWords:WordListVO = wordList.clone();
//			wDict = new Vector.<DisplayWordVO>();
//			CModule.serviceUIRequests();
//			
//			PolarTreeAPI.initCanvas(); 
//			for(var i:int=0;i<template.layers.length;i++){
//				if(template.layers[i] is WordLayer){
//					var l:WordLayer = template.layers[i] as WordLayer;
//					var data:ByteArray = l.direction.getPixels(new Rectangle(0,0,l.direction.width,l.direction.height));
//					var colorData:ByteArray = l.direction.getPixels(new Rectangle(0,0,l.color.width,l.color.height));
//					
//					data.position = 0;
//					var addr:int = CModule.malloc(data.length);
//					CModule.writeBytes(addr, data.length, data);
//					
//					colorData.position = 0;
//					var colorAddr:int = CModule.malloc(colorData.length);
//					CModule.writeBytes(colorAddr, colorData.length, colorData);
//					
//					PolarTreeAPI.appendLayer(addr,colorAddr,l.getWidth(),l.getHeight(),true);
//				}
//			}
			
		}
		
		public function updateWordList(wordList:WordListVO):void{
			controlChannel.send(["words",wordList.toArray()]);

//			this.wordList = wordList;
		}
		public function startRender():void{
						controlChannel.send(["start"]);
//			PolarTreeAPI.startRendering();
//			handleFeeds();
		}
		
		public function updatePerseverance(perseverance:int):void{
						controlChannel.send(["perseverance",perseverance]);
//			PolarTreeAPI.setPerseverance(perseverance);
		}
		
		public function handleSlaps():void{
			var coordPtr:int = 0;
			while((coordPtr=PolarTreeAPI.getNextSlap())!=0){
				
				var sid:int = CModule.read32(coordPtr);
				var dw:DisplayWordVO =wDict[sid];
				
				
				var place:PlaceInfo = new PlaceInfo(CModule.readDouble(coordPtr+4), CModule.readDouble(coordPtr+12), CModule.readDouble(coordPtr+20), 0);
				var fontColor:uint = CModule.read32(coordPtr + 28);
				var failureCount:int = CModule.read32(coordPtr+32);
				dw.textField.textColor = fontColor;
				dw.putToPlace(place);
				
				tuProxy.tu.failureCount = failureCount;
				
				facade.sendNotification(ApplicationFacade.DISPLAYWORD_CREATED, dw);
			}
			if(PolarTreeAPI.getStatus()==0){	
				if(tuProxy.generateTemplatePreview){
					tuProxy.tu.template.preview = generator.canvasImage(300);
					facade.sendNotification(ApplicationFacade.TEMPLATE_PREVIEW_GENERATED);
				}
				facade.sendNotification(ApplicationFacade.TU_GENERATION_LAST_CALL);
			}
			
		}
		private var fonts:Array = ["romeral","permanentmarker","fifthleg-kRB"];
		
		public function handleFeeds():void{
			while(PolarTreeAPI.getNumberOfPendingShapes()<10
				&& PolarTreeAPI.getStatus()>0){
				var word:WordVO;
				//				if(getShrinkage()>0){
				word = wordList.next();
				//				}
				//				else{
				//					word = new WordVO("DT");
				//				}
				CModule.serviceUIRequests();		
				var fontSize:Number = 100*PolarTreeAPI.getShrinkage()+8;
				var fontName:String = fonts[Math.round((Math.random()*fonts.length))];
				var dw:DisplayWordVO = new DisplayWordVO(word, fontName, fontSize );
				var sid:int = wDict.length;
				wDict.push(dw);
				var params:Array = getTextShape(dw);
				PolarTreeAPI.feedShape(params[0],params[1],params[2],sid);
			}
		}
		
		
				private function handleResultMessage(event:Event):void
				{
					var msg:Object = resultChannel.receive() as Object;
					
					var place:PlaceInfo = new PlaceInfo(msg["x"] as Number, msg["y"] as Number, msg["rotation"] as Number, msg["layer"] as int);
					var fontName:String = msg["fontName"];
					var fontSize:Number = msg["fontSize"];
					var color:uint = msg["fontColor"];
					var word:WordVO = msg["word"] as WordVO;
					var failureCount:int = msg["failureCount"];
					if (place != null){
						var dw:DisplayWordVO = new DisplayWordVO(word,fontName,fontSize,color,place);
						tuProxy.tu.failureCount = failureCount;
						
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
							facade.sendNotification(ApplicationFacade.TU_GENERATION_LAST_CALL);
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
		
		private function getTextShape(dw:DisplayWordVO, safetyBorder:Number=0):Array
		{
			var HELPER_MATRIX: Matrix = new Matrix( 1, 0, 0, 1 );
			
			var bounds: Rectangle = dw.textField.getBounds( dw.textField );
			HELPER_MATRIX.tx = -bounds.x + safetyBorder;
			HELPER_MATRIX.ty = -bounds.y + safetyBorder;
			
			
			var bmpd:BitmapData = new BitmapData( bounds.width + safetyBorder * 2, bounds.height + safetyBorder * 2, true, 0xFFFFFFFF );
			//s.width = textField.width;
			//s.height = textField.height;
			dw.x = 0;
			dw.y = 0;
			bmpd.draw( dw );
			
			
			var data:ByteArray = bmpd.getPixels(new Rectangle(0,0,bmpd.width, bmpd.height));
			//			trace("width: "+s.width.toString()+", height: "+s.height.toString()+", length: "+data.length.toString()+"\n");
			data.position = 0;
			var addr:int = CModule.malloc(data.length);
			CModule.writeBytes(addr, data.length, data);
			return [addr,bmpd.width, bmpd.height];
		}
		
	}
}