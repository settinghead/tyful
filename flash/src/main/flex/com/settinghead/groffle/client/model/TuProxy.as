package com.settinghead.groffle.client.model
{
	import com.adobe.images.PNGEncoder;
	import com.notifications.Notification;
	import com.settinghead.groffle.client.ApplicationFacade;
	import com.settinghead.groffle.client.PlaceInfo;
	import com.settinghead.groffle.client.RenderOptions;
	import com.settinghead.groffle.client.WordShaper;
	import com.settinghead.groffle.client.angler.MostlyHorizAngler;
	import com.settinghead.groffle.client.angler.ShapeConfinedAngler;
	import com.settinghead.groffle.client.angler.WordAngler;
	import com.settinghead.groffle.client.colorer.WordColorer;
	import com.settinghead.groffle.client.density.Patch;
	import com.settinghead.groffle.client.fonter.WordFonter;
	import com.settinghead.groffle.client.model.vo.DisplayWordVO;
	import com.settinghead.groffle.client.model.vo.EngineWordVO;
	import com.settinghead.groffle.client.model.vo.TextShapeVO;
	import com.settinghead.groffle.client.model.vo.TuVO;
	import com.settinghead.groffle.client.model.vo.template.TemplateVO;
	import com.settinghead.groffle.client.model.vo.wordlist.WordListVO;
	import com.settinghead.groffle.client.model.vo.wordlist.WordVO;
	import com.settinghead.groffle.client.nudger.WordNudger;
	import com.settinghead.groffle.client.placer.ShapeConfinedPlacer;
	import com.settinghead.groffle.client.placer.WordPlacer;
	import com.settinghead.groffle.client.sizers.WordSizer;
	import com.settinghead.groffle.client.view.TuMediator;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.core.FlexGlobals;
	import mx.rpc.IResponder;
	
	import org.as3commons.collections.Set;
	import org.as3commons.collections.SortedList;
	import org.as3commons.collections.framework.IIterator;
	import org.generalrelativity.thread.GreenThread;
	import org.generalrelativity.thread.IRunnable;
	import org.generalrelativity.thread.event.GreenThreadEvent;
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	import org.puremvc.as3.utilities.loadup.interfaces.ILoadupProxy;
	
	import ru.inspirit.net.MultipartURLLoader;
	import ru.inspirit.net.events.MultipartURLLoaderEvent;
	
	public class TuProxy extends EntityProxy implements ILoadupProxy
	{
		public static const NAME:String = "TuProxy";
		public static const SRNAME:String = "TuSRProxy";
		private static const MAX_NUM_RETRIES_BEFORE_REDUCE_SIZE:int = 2;
		private static const SNAPSHOT_INTERVAL:int = 22;
		
		private var _template:TemplateVO;
		private var _wordList:WordListVO;

//		private var indexOffset:int=0;
		private var _failureCount:int = 0;
		
		private var renderProcess:RenderTuProcess;
		private var gThread:GreenThread;
		
		private var imageGenerator:ITuImageGenerator;

		public function TuProxy()
		{
			super(NAME, new ArrayCollection());
			this.imageGenerator = FlexGlobals.topLevelApplication["tuImageGenerator"];
		}
		
		public function get generateTemplatePreview():Boolean{
			return renderProcess.generateTemplatePreview;
		}
		
		public function set generateTemplatePreview(v:Boolean):void{
			renderProcess.generateTemplatePreview = v;
		}
		
		public function startRender():void{
			gThread.open();
		}
		
		// return data property cast to proper type
		public function get tu():TuVO
		{
			return data as TuVO;
		}
		
		public function set tu(tu:TuVO):void
		{
			setData(tu);

		}
		
		public override function setData(data:Object):void{
			super.setData(data);
			if(tu!=null){
				renderProcess = new RenderTuProcess(facade, tu, imageGenerator);
				var processes:Vector.<IRunnable> = new Vector.<IRunnable>();
				processes.push(renderProcess);
				gThread = new GreenThread(processes,(FlexGlobals.topLevelApplication.stage as Stage).frameRate);
				gThread.addEventListener( GreenThreadEvent.PROCESS_COMPLETE, processCompleteHandler );
			}
		}
		
		private function processCompleteHandler(e:Event):void{
			//TODO
		}
		

		
		public function load() :void{
			var tu:TuVO = new TuVO(_template, _wordList);
			_template.generatePatchIndex();
			this.setData(tu);

		}
		
		public function set template(t:TemplateVO):void{
			this._template = t;
		}
		
		public function set wordList(wl:WordListVO):void{
			this._wordList = wl;
		}

		
		
		public function get failureCount():int{
			return _failureCount;
		}
		
		public function generateImage():void{
			tu.generatedImage = imageGenerator.canvasImage(1500);
			facade.sendNotification(ApplicationFacade.TU_IMAGE_GENERATED);
		}
		
		
		private var urlLoader : MultipartURLLoader;
		public function postToFacebook():void{
			var b:ByteArray = PNGEncoder.encode(tu.generatedImage);
			// set up the request & headers for the image upload;
			urlLoader = new MultipartURLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener(MultipartURLLoaderEvent.DATA_PREPARE_COMPLETE, dataPrepareComplete);
			urlLoader.addEventListener(Event.COMPLETE, photoPostComplete);
			urlLoader.addVariable("token", decodeURIComponent(FlexGlobals.topLevelApplication.parameters.token));
			urlLoader.addVariable("userId", decodeURIComponent(FlexGlobals.topLevelApplication.parameters.userId));
			urlLoader.addVariable("fbToken", decodeURIComponent(FlexGlobals.topLevelApplication.parameters.fbToken));
			urlLoader.addVariable("fbUid", decodeURIComponent(FlexGlobals.topLevelApplication.parameters.fbUid));
			urlLoader.addVariable("title", decodeURIComponent(FlexGlobals.topLevelApplication.parameters.templateTitle));
			urlLoader.addVariable("templateId", decodeURIComponent(FlexGlobals.topLevelApplication.parameters.templateId));
			urlLoader.addFile(b,"artwork.png",'image');
			urlLoader.load( decodeURIComponent(FlexGlobals.topLevelApplication.parameters.facebookUploadUrl),true);

		}
		
		public function dataPrepareComplete(e:Event):void{
			if(urlLoader.PREPARED)
				urlLoader.startLoad();
		}
		
		public function photoPostComplete(e:Event):void{
			Notification.show("Your artwork has been shared with your friends on Facebook.");
		}
	}
}