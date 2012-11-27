package com.settinghead.tyful.client.algo
{	
	import com.settinghead.tyful.client.model.vo.DisplayWordVO;
	import com.settinghead.tyful.client.model.vo.template.PlaceInfo;
	import com.settinghead.tyful.client.model.vo.template.TemplateVO;
	import com.settinghead.tyful.client.model.vo.template.WordLayer;
	import com.settinghead.tyful.client.model.vo.wordlist.WordListVO;
	import com.settinghead.tyful.client.model.vo.wordlist.WordVO;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.registerClassAlias;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.text.AntiAliasType;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import polartree.PolarTree.CModule;
	import polartree.PolarTree.getShrinkage;
	import polartree.PolarTree.getStatus;
	import polartree.PolarTree.initCanvas;
	import polartree.PolarTree.slapShape;
	
	public class PolarWorker
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
		private var template:TemplateVO = null;
		public function PolarWorker()
		{
			initialize();
		}
		
		private var controlChannel:MessageChannel;
		private var resultChannel:MessageChannel;
		private var statusChannel:MessageChannel;
		public const STOPPED:String = "STOPPED";
		public const PAUSED:String = "PAUSED";
		public const RUNNING:String = "RUNNING";
		
		
		private function initialize():void
		{
			registerClassAlias("com.settinghead.tyful.client.model.vo.DisplayWordVO", DisplayWordVO);
			registerClassAlias("com.settinghead.tyful.client.model.vo.template.PlaceInfo", PlaceInfo);
			registerClassAlias("com.settinghead.tyful.client.model.vo.template.TemplateVO", TemplateVO);
			registerClassAlias("com.settinghead.tyful.client.model.vo.template.WordLayer", WordLayer);
			registerClassAlias("com.settinghead.tyful.client.model.vo.wordlist.WordListVO", WordListVO);
			registerClassAlias("com.settinghead.tyful.client.model.vo.wordlist.WordVO", WordVO);
			registerClassAlias("com.adobe.test.vo.CountResult", DisplayWordVO);

			// These are for sending messages to the parent worker
			resultChannel = Worker.current.getSharedProperty("resultChannel") as MessageChannel;
			statusChannel = Worker.current.getSharedProperty("statusChannel") as MessageChannel;
			// Get the MessageChannel objects to use for communicating between workers
			// This one is for receiving messages from the parent worker
			controlChannel = Worker.current.getSharedProperty("controlChannel") as MessageChannel;
			controlChannel.addEventListener(Event.CHANNEL_MESSAGE, controlCommandReceived);
			
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
					wordList = (message[1] as WordListVO).clone();
				}
				else if (message[0] == "start"){
					start();
				}
				else if (message[0] == "template"){
					CModule.serviceUIRequests();
					template = message[1] as TemplateVO;
					var directionBitmapData:BitmapData= (template.layers[0] as WordLayer).direction;
						//TODO: complete multi-layer implementation
					var data:ByteArray = directionBitmapData.getPixels(new Rectangle(0,0,directionBitmapData.width, directionBitmapData.height));
					//trace("data length: "+ data.length.toString()+"\n");
					data.position = 0;
					var addr:int = CModule.malloc(data.length);
					CModule.writeBytes(addr, data.length, data);
					
					initCanvas(addr,directionBitmapData.width,directionBitmapData.height); 
				}
				checkStart();
			}
		}
		private function checkStart():void{
			if(wordList!=null && template!=null && Worker.current.getSharedProperty("status")==PAUSED){
				start();
			}
		}
		
		private function start():void{
			var currentWords:WordListVO = wordList.clone();
			Worker.current.setSharedProperty("status", RUNNING);
			while(Worker.current.getSharedProperty("status")==RUNNING && getStatus()>0){
				var word:WordVO = wordList.next();
				
				CModule.serviceUIRequests()				
				
				var textField:TextField = getTextField(word.word, 100*getShrinkage()+10);
				var params:Array = getTextShape(textField);
				
				var coord:Vector.<Number> =
					slapShape(params[0],params[1],params[2]);
				
				if(coord!=null){
					var rotation:Number = coord[2];
					var place:PlaceInfo = new PlaceInfo(coord[0], coord[1], coord[2], template.layers[0] as WordLayer);
					var s:DisplayWordVO = new DisplayWordVO(word, place);
					//s.width = textField.width;
					//s.height = textField.height;
					textField.x = 0;
					textField.y = 0;
					
					s.textField = textField;
					var w:Number = s.width;
					var h:Number = s.height;
					s.x = coord[0];
					s.y = coord[1];
					
					var centerX:Number=s.x+s.width/2;
					var centerY:Number = s.y+s.height/2;
					
					//						trace("CenterX: "+centerX.toString()+", CenterY: "+centerY.toString()+", width: "+ s.width.toString() +", height: "+ s.height.toString() +" rotation: "+rotation.toString());
					
					var m:Matrix=s.transform.matrix;
					m.tx -= centerX;
					m.ty -= centerY;
					m.rotate(-rotation); // was a missing "=" here
					m.tx += centerX;
					m.ty += centerY;
					s.transform.matrix = m;
					resultChannel.send(s);
				}
				
				//      var args:Vector.<int> = new Vector.<Number>;
				//      args.push(params[0]);
				//      args.push(params[1]);
				//      args.push(params[2]);
			}
			
			if(getStatus()==0)
				statusChannel.send("complete");
		}
		
		private function processTextField(event:Event):void{
			
		}
		
		private function getTextShape(textField:TextField, safetyBorder:Number=0):Array
		{
			var HELPER_MATRIX: Matrix = new Matrix( 1, 0, 0, 1 );
			
			var bounds: Rectangle = textField.getBounds( textField );
			HELPER_MATRIX.tx = -bounds.x + safetyBorder;
			HELPER_MATRIX.ty = -bounds.y + safetyBorder;
			
			
			var bmp:Bitmap = new Bitmap( new BitmapData( bounds.width + safetyBorder * 2, bounds.height + safetyBorder * 2, true, 0xFFFFFFFF ) );
			var s:Sprite = new Sprite();
			//s.width = textField.width;
			//s.height = textField.height;
			s.x = 0;
			s.y = 0;
			s.addChild(textField);
			bmp.bitmapData.draw( s );
			
			
			var data:ByteArray = bmp.bitmapData.getPixels(new Rectangle(0,0,bmp.bitmapData.width, bmp.bitmapData.height));
			trace("width: "+s.width.toString()+", height: "+s.height.toString()+", length: "+data.length.toString()+"\n");
			data.position = 0;
			var addr:int = CModule.malloc(data.length);
			CModule.writeBytes(addr, data.length, data);
			return [addr,bmp.width, bmp.height];
		}
		
		public function getTextField(text: String, size: Number, rotation: Number = 0):TextField
		{
			var textField: TextField = new TextField();
			//      textField.setTextFormat( new TextFormat( font.fontName, size ) );
			var style:StyleSheet = new StyleSheet();
			style.parseCSS("div{font-size: "+size+"; font-family: romeral; leading: 0; text-align: center;}");
			textField.styleSheet = style;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.background = false;
			textField.selectable = false;
			textField.embedFonts = true;
			//textField.cacheAsBitmap = true;
			textField.x = 0;
			textField.y = 0;
			textField.antiAliasType = AntiAliasType.ADVANCED;
			textField.htmlText = "<div>"+text+"</div>";
			textField.filters = [new DropShadowFilter(0.5,45,0,1.0,0.5,0.5)];
			if(text.length>11){ //TODO: this is a temporary fix
				var w:Number = textField.width;
				textField.wordWrap = true;
				textField.width = w/(text.length/11)*1.1 ;
			}
			return textField;
		}
	}
}