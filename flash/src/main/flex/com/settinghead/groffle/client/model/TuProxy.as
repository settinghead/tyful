package com.settinghead.groffle.client.model
{
	import com.adobe.images.PNGEncoder;
	import com.notifications.Notification;
	import com.settinghead.groffle.client.ApplicationFacade;
	import com.settinghead.groffle.client.model.algo.RenderTuProcess;
	import com.settinghead.groffle.client.model.vo.TuVO;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	
	import org.generalrelativity.thread.GreenThread;
	import org.generalrelativity.thread.IRunnable;
	import org.generalrelativity.thread.event.GreenThreadEvent;
	import org.puremvc.as3.utilities.loadup.interfaces.ILoadupProxy;
	
	import ru.inspirit.net.MultipartURLLoader;
	import ru.inspirit.net.events.MultipartURLLoaderEvent;
	
	
	public class TuProxy extends EntityProxy implements ILoadupProxy
	{
		public static const NAME:String = "TuProxy";
		public static const SRNAME:String = "TuSRProxy";
		private static const MAX_NUM_RETRIES_BEFORE_REDUCE_SIZE:int = 2;
		private static const SNAPSHOT_INTERVAL:int = 22;
		
//		private var indexOffset:int=0;
		
		private var renderProcess:RenderTuProcess;
		private var gThread:GreenThread;
		
		private var imageGenerator:ITuImageGenerator;
		
		public function TuProxy()
		{
			super(NAME, new ArrayCollection());
			this.imageGenerator = FlexGlobals.topLevelApplication["tuImageGenerator"];
		}
		
		private var _generateTemplatePreview:Boolean = false;
		
		public function get generateTemplatePreview():Boolean{
			return _generateTemplatePreview;
		}
		
		public function set generateTemplatePreview(v:Boolean):void{
			_generateTemplatePreview = v;
		}
		
		public function startRender():void{
			tu.failureCount = 0;
			if(gThread){
				gThread.close(false);
				gThread.removeEventListener(GreenThreadEvent.PROCESS_COMPLETE, processCompleteHandler);

			}
			var processes:Vector.<IRunnable> = new Vector.<IRunnable>();
			processes.push(renderProcess);
			gThread = new GreenThread(processes,(FlexGlobals.topLevelApplication.stage as Stage).frameRate*2, 0.9);
			gThread.addEventListener( GreenThreadEvent.PROCESS_COMPLETE, processCompleteHandler );
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
				if(gThread)
					gThread.close(true);
				renderProcess = new RenderTuProcess(facade, tu, imageGenerator,false );
			}
		}
		
		private function processCompleteHandler(e:Event):void{
			//TODO
		}
		

		
		public function load() :void{
			var templateProxy:TemplateProxy = facade.retrieveProxy(TemplateProxy.NAME) as TemplateProxy;
			var wordListProxy:WordListProxy = facade.retrieveProxy(WordListProxy.NAME) as WordListProxy;

			var tu:TuVO = new TuVO(templateProxy.template, wordListProxy.currentWordList);
			templateProxy.template.generatePatchIndex();
			this.setData(tu);

		}

		
		public function generateImage():void{
			tu.generatedImage = imageGenerator.canvasImage(1500);
			facade.sendNotification(ApplicationFacade.TU_IMAGE_GENERATED);
		}
		
		
		private var urlLoader : MultipartURLLoader;
		public function postToFacebook():void{
			if(tu.generatedImage==null)
				tu.generatedImage = imageGenerator.canvasImage(1500);
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
			Notification.show("Your artwork has been shared with your friends on Facebook.","",null,8000,Notification.NOTIFICATION_POSITION_BOTTOM_LEFT);


		}
		
		public function dataPrepareComplete(e:Event):void{
			if(urlLoader.PREPARED)
				urlLoader.startLoad();
		}
		
		public function photoPostComplete(e:Event):void{
		}
	}
}