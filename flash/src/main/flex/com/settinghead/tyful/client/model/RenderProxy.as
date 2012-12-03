package com.settinghead.tyful.client.model
{
	import com.settinghead.tyful.client.ApplicationFacade;
	import com.settinghead.tyful.client.model.polarcore.AbstractPolarCore;
	import com.settinghead.tyful.client.model.polarcore.FeedEvent;
	import com.settinghead.tyful.client.model.polarcore.FlasccWorkerPolarCore;
	import com.settinghead.tyful.client.model.polarcore.NativeClientPolarCore;
	import com.settinghead.tyful.client.model.polarcore.ResultEvent;
	import com.settinghead.tyful.client.model.vo.DisplayWordVO;
	import com.settinghead.tyful.client.model.vo.template.PlaceInfo;
	import com.settinghead.tyful.client.model.vo.template.TemplateVO;
	import com.settinghead.tyful.client.model.vo.template.WordLayer;
	import com.settinghead.tyful.client.model.vo.wordlist.WordListVO;
	import com.settinghead.tyful.client.model.vo.wordlist.WordVO;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.registerClassAlias;
	import flash.system.Worker;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	
	import org.as3commons.bytecode.io.AbstractAbcDeserializer;
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.utilities.loadup.interfaces.ILoadupProxy;
	
	
	
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
		private var fonts:Array = ["romeral","permanentmarker","fifthleg-kRB"];
		
		
		private var _generator:ITuImageGenerator = null;
		private var wDict:Vector.<DisplayWordVO>;
		
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
		
		private var _wordListProxy:WordListProxy = null;
		private function get wordListProxy():WordListProxy{
			if(_tuProxy==null) _wordListProxy = facade.retrieveProxy(WordListProxy.NAME) as WordListProxy;
			return _wordListProxy;
		}
		
		
		public function RenderProxy()
		{
			super(NAME, null);
			//TODO
			registerClassAlias("com.settinghead.tyful.client.model.vo.wordlist.WordVO", WordVO);
			RenderProxy.current = this;
		}
		
		private function get core():AbstractPolarCore{
			return data as AbstractPolarCore;
		}
		
		
		public function load():void{
			if(Worker.isSupported){
				setData(new FlasccWorkerPolarCore());
			}
			else if ((ExternalInterface.call("window.navigator.userAgent.toString") as String).indexOf("Chrome")!=-1){
				setData(new NativeClientPolarCore());
			}
			else{
				Alert.show("Tyful requires Flash Player version 11.5 or newer. Place update your Flash Player by going to http://get.adobe.com/flashplayer/");
			}
			if(core!=null){
				core.addResultEventListener(handleResult);		
				core.addFeedEventListener(handleFeed);
				core.addEventListener(AbstractPolarCore.LOAD_COMPLETE,coreLoadComplete);
				core.load();
			}
		}
		
		public function updateTemplate(template:TemplateVO):void{
			core.updateTemplate(template);
			currentWordPosition = 0;
			wDict = new Vector.<DisplayWordVO>();
		}
		
		public function startRender():void{
			core.startRender();
//			core.feedShape(getNextShape(1));
		}
		
		public function updatePerseverance(perseverance:int):void{
			core.updatePerseverance(perseverance);
		}

		
		private function handleResult(event:ResultEvent):void
		{			
			var place:PlaceInfo = event.slap;
			if (place != null){
				var dw:DisplayWordVO = wDict[place.sid];
				dw.putToPlace(place);
				tuProxy.tu.failureCount = place.failureCount;
				
				facade.sendNotification(ApplicationFacade.DISPLAYWORD_CREATED, dw);
			}
			else {
				//completed
				if(tuProxy.generateTemplatePreview){
					tuProxy.tu.template.preview = generator.canvasImage(300);
					facade.sendNotification(ApplicationFacade.TEMPLATE_PREVIEW_GENERATED);
				}
				facade.sendNotification(ApplicationFacade.TU_GENERATION_LAST_CALL);
			}
			
		}
		
		private function handleFeed(event:FeedEvent):void{
			for(var i:uint=0;i<event.numFeeds;i++){
				var params:Array = getNextShape(event.shrinkage);
				core.feedShape(params[0],params[1]);
			}
		}
		
		private function coreLoadComplete(event:Event):void{
			if (this.data!=null) sendLoadedNotification( ApplicationFacade.SR_RENDER_ENGINE_LOADED, NAME, SRNAME);			
			if (this.data!=null) sendLoadedNotification( ApplicationFacade.RENDER_ENGINE_LOADED, NAME, SRNAME);	
		}
		
		private var currentWordPosition = 0;
		private function getNextShape(shrinkage:Number):Array{
			var word:WordVO;
			//				if(getShrinkage()>0){
			word = wordListProxy.wordList.at(currentWordPosition++);
			//				}
			//				else{
			//					word = new WordVO("DT");
			//				}
			var fontSize:Number = 100*shrinkage+10;
			var index:int = Math.floor((Math.random()*fonts.length));
			var fontName:String = fonts[index];
			var dw:DisplayWordVO = new DisplayWordVO(word, fontName, fontSize );
			var sid = wDict.length;
			wDict.push(dw);
			return [sid,getTextShape(dw)];
		}
		
		
		private function getTextShape(dw:DisplayWordVO, safetyBorder:Number=0):BitmapData
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
			
			
			return bmpd;
		}
		
		public override function setData(data:Object):void{			
			super.setData(data);
			if (this.data!=null) sendLoadedNotification( ApplicationFacade.SR_RENDER_ENGINE_LOADED, NAME, SRNAME);			
			if (this.data!=null) sendLoadedNotification( ApplicationFacade.RENDER_ENGINE_LOADED, NAME, SRNAME);	
		}
		
	}
}