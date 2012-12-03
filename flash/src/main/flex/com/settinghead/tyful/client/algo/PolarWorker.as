package com.settinghead.tyful.client.algo
{	
	import com.settinghead.tyful.client.model.vo.DisplayWordListVO;
	import com.settinghead.tyful.client.model.vo.DisplayWordVO;
	import com.settinghead.tyful.client.model.vo.template.PlaceInfo;
	import com.settinghead.tyful.client.model.vo.wordlist.WordComparator;
	import com.settinghead.tyful.client.model.vo.wordlist.WordListVO;
	import com.settinghead.tyful.client.model.vo.wordlist.WordVO;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.registerClassAlias;
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
		
		private var wordList:WordListVO = null;
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
		
		private function initialize():void
		{
			registerClassAlias("com.settinghead.tyful.client.model.vo.wordlist.WordVO", WordVO);
			registerClassAlias("com.settinghead.tyful.client.model.vo.wordlist.WordComparator", WordComparator);
			registerClassAlias("org.as3commons.collections.SortedList", SortedList);
			registerClassAlias("com.settinghead.tyful.client.model.vo.DisplayWordVO", DisplayWordVO);
			registerClassAlias("com.settinghead.tyful.client.model.vo.template.PlaceInfo", PlaceInfo);
			registerClassAlias("com.settinghead.tyful.client.model.vo.wordlist.WordListVO", WordListVO);
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
			
			addSlapRequestEventListener(this.handleSlaps);
			addFeedRequestEventListener(this.handleFeeds);
			CModule.startAsync(this);
		}        
		
		
		private function controlCommandReceived(event:Event):void
		{
			if (!controlChannel.messageAvailable)
				return;
			
			var message:Array = controlChannel.receive() as Array;
			
			if (message != null)
			{
				if(message[0] == "words")
				{
					wordList = new WordListVO((message[1] as Array));
					
				}
				else if (message[0] == "start"){
//					PolarTreeAPI.startRendering();
					PolarTreeAPI.setStatus(1);
					while(PolarTreeAPI.getStatus()>0){
					//feed the initial batch
						var params:Array = getNextShape();
						var coordPtr:int = PolarTreeAPI.slapShape(params[0],params[1],params[2],params[3]);
						processAndSendDw(coordPtr);
					}
				}
				
				else if (message[0] == "pause"){
					pause();
				}
				else if (message[0] == "template"){
					var currentWords:WordListVO = wordList.clone();
					wDict = new Vector.<DisplayWordVO>();
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
						var width:Number = a[0];
						var height:Number = a[1];
						var data:ByteArray = a[2];
						var colorData:ByteArray = ((template["colors"] as Array)[i] as Array)[2];
						
						data.position = 0;
						var addr:int = CModule.malloc(data.length);
						CModule.writeBytes(addr, data.length, data);
						
						colorData.position = 0;
						var colorAddr:int = CModule.malloc(colorData.length);
						CModule.writeBytes(colorAddr, colorData.length, colorData);
						
						PolarTreeAPI.appendLayer(addr,colorAddr,width,height,true);
					}
	
					
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
			var sid:int = CModule.read32(coordPtr);
				var dw:DisplayWordVO =wDict[sid];

	
				var place:PlaceInfo = new PlaceInfo(CModule.readDouble(coordPtr+8), CModule.readDouble(coordPtr+16), CModule.readDouble(coordPtr+24), 0);
				var fontColor:uint = CModule.read32(coordPtr + 32);
				var failureCount:int = CModule.read32(coordPtr+36);
				var msg:Object = new Object();
				
				msg["word"] = dw.word;
				msg["fontSize"] = dw.fontSize;
				msg["fontName"] = dw.fontName;
				msg["fontColor"] = fontColor;
				msg["x"] = place.x;
				msg["y"] = place.y;
				msg["rotation"] = place.rotation;
				msg["layer"] = place.layer;
				msg["failureCount"]=failureCount;
				resultChannel.send(msg);
		}

		private var fonts:Array = ["romeral","permanentmarker","fifthleg-kRB"];

		public function handleFeeds():void{
			while(PolarTreeAPI.getNumberOfPendingShapes()<10
				&& PolarTreeAPI.getStatus()>0){
				var params:Array = getNextShape();
				PolarTreeAPI.feedShape(params[0],params[1],params[2],params[3]);

			}
		}

		private function getNextShape():Array{
						var word:WordVO;
			//				if(getShrinkage()>0){
			word = wordList.next();
			//				}
			//				else{
			//					word = new WordVO("DT");
			//				}
			CModule.serviceUIRequests();		
			var fontSize:Number = 100*PolarTreeAPI.getShrinkage()+10;
			var fontName:String = fonts[Math.round((Math.random()*fonts.length))];
			var dw:DisplayWordVO = new DisplayWordVO(word, fontName, fontSize );
			var params:Array = getTextShape(dw);
			return params;
		}
		
		
		private function getTextShape(dw:DisplayWordVO, safetyBorder:Number=0):Array
		{
			var HELPER_MATRIX: Matrix = new Matrix( 1, 0, 0, 1 );
			
			var bounds: Rectangle = dw.textField.getBounds( dw.textField );
			HELPER_MATRIX.tx = -bounds.x + safetyBorder;
			HELPER_MATRIX.ty = -bounds.y + safetyBorder;
			
			
			var bmp:Bitmap = new Bitmap( new BitmapData( bounds.width + safetyBorder * 2, bounds.height + safetyBorder * 2, true, 0xFFFFFFFF ) );
			//s.width = textField.width;
			//s.height = textField.height;
			dw.x = 0;
			dw.y = 0;
			bmp.bitmapData.draw( dw );
			
			
			var data:ByteArray = bmp.bitmapData.getPixels(new Rectangle(0,0,bmp.bitmapData.width, bmp.bitmapData.height));
//			trace("width: "+s.width.toString()+", height: "+s.height.toString()+", length: "+data.length.toString()+"\n");
			data.position = 0;
			var addr:int = CModule.malloc(data.length);
			CModule.writeBytes(addr, data.length, data);
			var sid:int = wDict.length;
			wDict.push(dw);
			return [addr,bmp.width, bmp.height,sid];
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