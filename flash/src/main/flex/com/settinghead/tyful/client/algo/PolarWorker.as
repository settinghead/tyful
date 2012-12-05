package com.settinghead.tyful.client.algo
{	
//	import com.settinghead.tyful.client.model.polarcore.IShapeGenerator;
	import com.settinghead.tyful.client.model.IShapeGenerator;
	import com.settinghead.tyful.client.model.TextShapeGenerator;
	import com.settinghead.tyful.client.model.vo.DisplayWordListVO;
	import com.settinghead.tyful.client.model.vo.DisplayWordVO;
	import com.settinghead.tyful.client.model.vo.IShape;
	import com.settinghead.tyful.client.model.vo.template.Layer;
	import com.settinghead.tyful.client.model.vo.template.PlaceInfo;
	import com.settinghead.tyful.client.model.vo.template.TemplateVO;
	import com.settinghead.tyful.client.model.vo.template.WordLayer;
	import com.settinghead.tyful.client.model.vo.wordlist.WordListVO;
	import com.settinghead.tyful.client.model.vo.wordlist.WordVO;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.registerClassAlias;
	import flash.net.sendToURL;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.utils.ByteArray;
	
	import org.as3commons.collections.SortedList;
	
	import polartree.PolarTree.CModule;
	import polartree.PolarTree.PolarTreeAPI;
	import polartree.PolarTree.addFeedRequestEventListener;
	import polartree.PolarTree.addSlapRequestEventListener;
	import polartree.PolarTree.threadArbConds;
	import polartree.PolarTree.vfs.ISpecialFile;
	
	public class PolarWorker extends Sprite implements ISpecialFile
	{
		
		private var template:Object = null;
		private var wDict:Vector.<DisplayWordVO>;

		public static var current:PolarWorker ;
		public function PolarWorker()
		{
			initialize();
			current = this;
		}
		
		private var controlChannel:MessageChannel;
		private var resultChannel:MessageChannel;
		private var statusChannel:MessageChannel;
		
		private var shapeGenerator:IShapeGenerator;
		
		private function initialize():void
		{
			registerClassAlias("com.settinghead.tyful.client.model.vo.wordlist.WordVO", WordVO);
//			registerClassAlias("com.settinghead.tyful.client.model.vo.wordlist.WordComparator", WordComparator);
			registerClassAlias("org.as3commons.collections.SortedList", SortedList);
//			registerClassAlias("com.settinghead.tyful.client.model.vo.DisplayWordVO", DisplayWordVO);
			registerClassAlias("com.settinghead.tyful.client.model.vo.template.PlaceInfo", PlaceInfo);
			registerClassAlias("com.settinghead.tyful.client.model.vo.DisplayWordVO", DisplayWordVO);
			registerClassAlias("com.settinghead.tyful.client.model.vo.template.TemplateVO", TemplateVO);
			CModule.rootSprite = this;
			CModule.vfs.console = this;
			if(CModule.runningAsWorker()) {
				return;
			}
			// These are for sending messages to the parent worker
			resultChannel = Worker.current.getSharedProperty("resultChannel") as MessageChannel;
			statusChannel = Worker.current.getSharedProperty("statusChannel") as MessageChannel;
			// Get the MessageChannel objects to use for communicating between workers
			// This one is for receiving messages from the parent worker
			controlChannel = Worker.current.getSharedProperty("controlChannel") as MessageChannel;
			controlChannel.addEventListener(Event.CHANNEL_MESSAGE, controlCommandReceived);
			
//			addSlapRequestEventListener(this.handleSlaps);
//			addFeedRequestEventListener(this.handleFeeds);
			CModule.startAsync(this);
		}        
		
		var feedBuffer:int = 5;
		var warningLine:int = 5;
		
		private function controlCommandReceived(event:Event):void
		{

			if (!controlChannel.messageAvailable){
				return;
			}
			
			
			var message:Array = controlChannel.receive() as Array;
			
			if (message != null)
			{
				if (message[0] == "start"){
					PolarTreeAPI.setStatus(1);
					
//					PolarTreeAPI.startRendering();
					
					
//					while(PolarTreeAPI.getStatus()>0){
//						var params:Array = getNextShape();
//						var params:Array = getNextShape();
						
//						var coordPtr:int = PolarTreeAPI.slapShape(params[0],params[1],params[2],params[3]);	
//						processAndSendDw(coordPtr);
						//
						//						while (PolarTreeAPI.getNumberOfPendingShapes()<5){
						//							var params:Array = getNextShape();
						//							PolarTreeAPI.feedShape(params[0],params[1],params[2],params[3]);	
						//						}
						//						var coordPtr:int;
						//						while((coordPtr=PolarTreeAPI.getNextSlap())!=0)
						//							processAndSendDw(coordPtr);
//						controlCommandReceived(null);
//						statusChannel.send(["feedMe",warningLine+feedBuffer,PolarTreeAPI.getShrinkage()]);
					while(PolarTreeAPI.getStatus()>0){
						var shape:DisplayWordVO = getNextShape();
						var bitmapData:BitmapData = shape.toBitmapData();
						var addr:int = dataToAddr(bitmapData.getPixels(new Rectangle(0,0,bitmapData.width, bitmapData.height)));
						var slapAddr:int = PolarTreeAPI.slapShape(addr,bitmapData.width, bitmapData.height, shape.sid);
						processAndSendDw(slapAddr);
						controlCommandReceived(null);
					}
					resultChannel.send(new Object());
				}
					
				else if (message[0] == "pause"){
					pause();
				}
				else if (message[0] == "words"){
					var wordList:WordListVO = new WordListVO(message[1]);
					shapeGenerator = new TextShapeGenerator(wordList);
				}
				else if (message[0] == "template"){
					CModule.serviceUIRequests();
					//					template = message[1] as TemplateVO;
					template = message[1] as Object;
					//					var directionBitmapData:BitmapData= (template.layers[0] as WordLayer).direction;
					//TODO: complete multi-layer implementation
					//					var data:ByteArray = directionBitmapData.getPixels(new Rectangle(0,0,directionBitmapData.width, directionBitmapData.height));
					//trace("data length: "+ data.length.toString()+"\n");
					var directions:Array = template["directions"] as Array;
					var colors:Array = template["colors"] as Array;
					
					
					PolarTreeAPI.initCanvas(); 
					for(var i:int=0;i<directions.length;i++){
						var a:Array = (template["directions"] as Array)[i] as Array;
						var twidth:Number = a[0];
						var theight:Number = a[1];
						var data:ByteArray = a[2];
						var colorData:ByteArray = ((template["colors"] as Array)[i] as Array)[2];
						
						data.position = 0;
						var addr:int = CModule.malloc(data.length);
						CModule.writeBytes(addr, data.length, data);
						
						colorData.position = 0;
						var colorAddr:int = CModule.malloc(colorData.length);
						CModule.writeBytes(colorAddr, colorData.length, colorData);
						
						PolarTreeAPI.appendLayer(addr,colorAddr,twidth,theight,true);
					}
					
					wDict = new Vector.<DisplayWordVO>();
					
					
				}
				else if (message[0] == "perseverance"){
					CModule.serviceUIRequests();
					PolarTreeAPI.setPerseverance(message[1] as int);
				}
			}
			
		}
		
		
		private function pause():void{
			PolarTreeAPI.pauseRendering();
		}
		
		public function handleSlaps():void{
			var coordPtr:int = 0;
			while((coordPtr=PolarTreeAPI.getNextSlap())!=0){
				processAndSendDw(coordPtr);
			}
		}
		
		private function processAndSendDw(coordPtr:int):void{
			var msg:Object = new Object();

			if(coordPtr!=0){
				var sid:uint = CModule.read32(coordPtr);
				var fontColor:uint = CModule.read32(coordPtr + 36);
				var failureCount:int = CModule.read32(coordPtr+40);
				
				var place:PlaceInfo = new PlaceInfo(sid,CModule.readDouble(coordPtr+8), CModule.readDouble(coordPtr+16), CModule.readDouble(coordPtr+24), CModule.read32(coordPtr + 32),fontColor,failureCount);
				
				var shape:DisplayWordVO = wDict[sid];
				
				msg["word"] = shape.word;
				msg["fontSize"] = shape.fontSize;
				msg["fontName"] = shape.fontName;
				msg["sid"] = shape.sid
				msg["fontColor"] = fontColor;
				msg["sid"] = place.sid;
				msg["x"] = place.x;
				msg["y"] = place.y;
				msg["rotation"] = place.rotation;
				msg["layer"] = place.layer;
				msg["failureCount"]=failureCount;
				resultChannel.send(msg);				
			}
//			statusChannel.send(["feedMe",1,PolarTreeAPI.getShrinkage()]);

		}
		
		private var fonts:Array = ["romeral","permanentmarker","fifthleg-kRB"];
		
		private function getNextShape():DisplayWordVO{
			var word:WordVO;
			var sid:int = wDict.length;
			var shape:DisplayWordVO = shapeGenerator.nextShape(sid,PolarTreeAPI.getShrinkage()) as DisplayWordVO;
			wDict.push(shape);
			return shape;
		}
		
//		public function handleFeeds():void{
//			while(PolarTreeAPI.getNumberOfPendingShapes()<10
//				&& PolarTreeAPI.getStatus()>0){
//				var params:Array = getNextShape();
//				PolarTreeAPI.feedShape(params[0],params[1],params[2],params[3]);
//				
//			}
//		}
		
//		public function handleFeeds():void{
//			while(PolarTreeAPI.getNumberOfPendingShapes()<10
//				&& PolarTreeAPI.getStatus()>0){
//				var word:WordVO;
//				//				if(getShrinkage()>0){
//				word = wordList.next();
//				//				}
//				//				else{
//				//					word = new WordVO("DT");
//				//				}
//				CModule.serviceUIRequests();		
//				var fontSize:Number = 100*PolarTreeAPI.getShrinkage()+8;
//				var fontName:String = fonts[Math.round((Math.random()*fonts.length))];
//				var dw:DisplayWordVO = new DisplayWordVO(word, fontName, fontSize );
//				var sid:int = wDict.length;
//				wDict.push(dw);
//				var params:Array = getTextShape(dw);
//				PolarTreeAPI.feedShape(params[0],params[1],params[2],sid);
//			}
//		}
//		
//		
//		public function handleSlaps():void{
//			var coordPtr:int = 0;
//			while((coordPtr=PolarTreeAPI.getNextSlap())!=0){
//				
//				var sid:int = CModule.read32(coordPtr);
//				var dw:DisplayWordVO =wDict[sid];
//				
//				
//				var place:PlaceInfo = new PlaceInfo(CModule.readDouble(coordPtr+4), CModule.readDouble(coordPtr+12), CModule.readDouble(coordPtr+20), 0);
//				var fontColor:uint = CModule.read32(coordPtr + 28);
//				var failureCount:int = CModule.read32(coordPtr+32);
//				dw.textField.textColor = fontColor;
//				dw.putToPlace(place);
//				
//				tuProxy.tu.failureCount = failureCount;
//				
//				facade.sendNotification(ApplicationFacade.DISPLAYWORD_CREATED, dw);
//			}
//			if(PolarTreeAPI.getStatus()==0){	
//				if(tuProxy.generateTemplatePreview){
//					tuProxy.tu.template.preview = generator.canvasImage(300);
//					facade.sendNotification(ApplicationFacade.TEMPLATE_PREVIEW_GENERATED);
//				}
//				facade.sendNotification(ApplicationFacade.TU_GENERATION_LAST_CALL);
//			}
//			
//		}
		
		private function dataToAddr(data:ByteArray):int{
			data.position = 0;
			var addr:int = CModule.malloc(data.length);
			CModule.writeBytes(addr, data.length, data);
			return addr;
		}
		
		/**
		 * The callback to call when FlasCC code calls the posix exit() function. Leave null to exit silently.
		 * @private
		 */
		public var exitHook:Function;
		/**
		 * The PlayerKernel implementation will use this function to handle
		 * C process exit requests
		 */
		public function exit(code:int):Boolean
		{
			// default to unhandled
			return exitHook ? exitHook(code) : false;
		}
		
		/**
		 * The PlayerKernel implementation will use this function to handle
		 * C IO write requests to the file "/dev/tty" (e.g. output from
		 * printf will pass through this function). See the ISpecialFile
		 * documentation for more information about the arguments and return value.
		 */
		public function write(fd:int, bufPtr:int, nbyte:int, errnoPtr:int):int
		{
			var str:String = CModule.readString(bufPtr, nbyte)
			consoleWrite(str)
			return nbyte
		}
		
		/**
		 * The PlayerKernel implementation will use this function to handle
		 * C IO read requests to the file "/dev/tty" (e.g. reads from stdin
		 * will expect this function to provide the data). See the ISpecialFile
		 * documentation for more information about the arguments and return value.
		 */
		public function read(fd:int, bufPtr:int, nbyte:int, errnoPtr:int):int
		{
			return 0
		}
		
		/**
		 * The PlayerKernel implementation will use this function to handle
		 * C fcntl requests to the file "/dev/tty" 
		 * See the ISpecialFile documentation for more information about the
		 * arguments and return value.
		 */
		public function fcntl(fd:int, com:int, data:int, errnoPtr:int):int
		{
			return 0
		}
		
		/**
		 * The PlayerKernel implementation will use this function to handle
		 * C ioctl requests to the file "/dev/tty" 
		 * See the ISpecialFile documentation for more information about the
		 * arguments and return value.
		 */
		public function ioctl(fd:int, com:int, data:int, errnoPtr:int):int
		{
			return 0
		}
		
		/**
		 * Helper function that traces to the flashlog text file and also
		 * displays output in the on-screen textfield console.
		 */
		protected function consoleWrite(s:String):void
		{
			trace(s);
		}
		
		/**
		 * Provide a way to get the TextField's text.
		 */
		public function get consoleText():String
		{
			var txt:String = null;
			
			return txt;
		}
		
		
	}
}