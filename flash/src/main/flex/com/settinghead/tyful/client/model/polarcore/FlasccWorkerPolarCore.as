package com.settinghead.tyful.client.model.polarcore
{
	import com.settinghead.tyful.client.model.vo.template.PlaceInfo;
	import com.settinghead.tyful.client.model.vo.template.TemplateVO;
	import com.settinghead.tyful.client.model.vo.wordlist.WordListVO;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	import flash.system.WorkerState;
	import flash.utils.ByteArray;
	
	import polartree.PolarTree.CModule;
	import polartree.PolarTree.PolarTreeAPI;
	import polartree.PolarTree.addFeedRequestEventListener;
	import polartree.PolarTree.addSlapRequestEventListener;
	import polartree.PolarTree.threadArbConds;
	import polartree.PolarTree.vfs.ISpecialFile;

	public class FlasccWorkerPolarCore extends AbstractPolarCore
	{
		private var worker:Worker;
		
		private var resultChannel:MessageChannel;
		private var statusChannel:MessageChannel;
		private var controlChannel:MessageChannel;
		
		public function FlasccWorkerPolarCore()
		{
			worker = WorkerDomain.current.createWorker(Workers.com_settinghead_tyful_client_algo_PolarWorker);

			controlChannel = Worker.current.createMessageChannel(renderWorker);
			renderWorker.setSharedProperty("controlChannel", controlChannel);
			
			resultChannel = renderWorker.createMessageChannel(Worker.current);
			resultChannel.addEventListener(Event.CHANNEL_MESSAGE, handleResultMessage);
			renderWorker.setSharedProperty("resultChannel", resultChannel);
			
			statusChannel = renderWorker.createMessageChannel(Worker.current);
			statusChannel.addEventListener(Event.CHANNEL_MESSAGE, handleStatusMessage);
			renderWorker.setSharedProperty("statusChannel", statusChannel);			
		}
		
		public override function load():void{
			renderWorker.addEventListener(Event.WORKER_STATE, handleBGWorkerStateChange);
			renderWorker.start();
		}
		
		
		private function get renderWorker():Worker{
			return worker as Worker;
		}
		public override function feedShape(sid:int,bmpd:BitmapData):void{
			var data:ByteArray = bmpd.getPixels(new Rectangle(0,0,bmpd.width,bmpd.height));
			controlChannel.send(["feed",sid,data,bmpd.width,bmpd.height]);
		}

		
		public override function updateTemplate(template:TemplateVO):void{
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
		
		public override function startRender():void{
			controlChannel.send(["start"]);
			//			PolarTreeAPI.startRendering();
			//			handleFeeds();
		}
		public override function pauseRender():void{
			controlChannel.send(["pause"]);
		}
		
		public override function updatePerseverance(perseverance:int):void{
			controlChannel.send(["perseverance",perseverance]);
			//			PolarTreeAPI.setPerseverance(perseverance);
		}
		
		private function handleResultMessage(event:Event):void
		{
			var msg:Object = resultChannel.receive() as Object;
			var place:PlaceInfo =null;

			if(msg["x"]!=null)
				place = new PlaceInfo(msg["sid"],msg["x"] as Number, msg["y"] as Number, msg["rotation"] as Number, msg["layer"],msg["fontColor"], msg["failureCount"]);
			
			
			dispatchEvent(new ResultEvent(place));
		}
		
		private function handleStatusMessage(event:Event):void
		{
			
			var msg:Object = statusChannel.receive() as Object;
			
			if(msg[0]=="feedMe")
				dispatchEvent(new FeedEvent(msg[1],msg[2]));
		}
		
		
		private function handleBGWorkerStateChange(event:Event):void{
			dispatchEvent(new Event(LOAD_COMPLETE));
		}
	}
}