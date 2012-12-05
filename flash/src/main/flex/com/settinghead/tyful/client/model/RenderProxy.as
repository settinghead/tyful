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

		public static const NAME:String = "RenderProxy";
		public static const SRNAME:String = "RenderSRProxy";
		private var _generator:ITuImageGenerator = null;
		
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
		}
		
		private function get core():AbstractPolarCore{
			return data as AbstractPolarCore;
		}
		
		
		public function load():void{
			if(Worker.isSupported && false){
				setData(new FlasccWorkerPolarCore());
			}
			else if ((ExternalInterface.call("window.navigator.userAgent.toString") as String).indexOf("Chrome")!=-1){
				setData(new NativeClientPolarCore(wordListProxy.wordList));
			}
			else{
				Alert.show("Tyful requires Flash Player version 11.5 or newer. Place update your Flash Player by going to http://get.adobe.com/flashplayer/");
			}
			if(core!=null){
				core.addResultEventListener(handleResult);		
				core.addEventListener(AbstractPolarCore.LOAD_COMPLETE,coreLoadComplete);
				core.load();
			}
		}
		
		public function updateTemplate(template:TemplateVO):void{
			core.updateTemplate(template);
			
		}
		
		public function startRender():void{
			core.updateWordList(wordListProxy.wordList);
			core.startRender();
			
//			core.feedShape(getNextShape(1));
		}
		
		public function updatePerseverance(perseverance:int):void{
			core.updatePerseverance(perseverance);
		}

		
		private function handleResult(event:ResultEvent):void
		{			
			var shape:DisplayWordVO = event.shape;
			if (shape != null){
				tuProxy.tu.failureCount = shape.place.failureCount;
				
				facade.sendNotification(ApplicationFacade.DISPLAYWORD_CREATED, shape);
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
		
		
		private function coreLoadComplete(event:Event):void{
			if (this.data!=null) sendLoadedNotification( ApplicationFacade.SR_RENDER_ENGINE_LOADED, NAME, SRNAME);			
			if (this.data!=null) sendLoadedNotification( ApplicationFacade.RENDER_ENGINE_LOADED, NAME, SRNAME);	
		}
		
		
		public override function setData(data:Object):void{			
			super.setData(data);
			if (this.data!=null) sendLoadedNotification( ApplicationFacade.SR_RENDER_ENGINE_LOADED, NAME, SRNAME);			
			if (this.data!=null) sendLoadedNotification( ApplicationFacade.RENDER_ENGINE_LOADED, NAME, SRNAME);	
		}
		
	}
}