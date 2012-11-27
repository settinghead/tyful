package com.settinghead.tyful.client.model
{
	import com.adobe.images.PNGEncoder;
	import com.notifications.Notification;
	import com.settinghead.tyful.client.ApplicationFacade;
	import com.settinghead.tyful.client.model.vo.TuVO;
	
	import flash.events.Event;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	
	import org.puremvc.as3.utilities.loadup.interfaces.ILoadupProxy;
	
	import ru.inspirit.net.MultipartURLLoader;
	import ru.inspirit.net.events.MultipartURLLoaderEvent;
	
	
	public class TuProxy extends EntityProxy implements ILoadupProxy
	{
		public static const NAME:String = "TuProxy";
		public static const SRNAME:String = "TuSRProxy";
		private static const SNAPSHOT_INTERVAL:int = 22;
		private var _generator:ITuImageGenerator = null;

		private function get generator():ITuImageGenerator{
			if(_generator==null)
				_generator = FlexGlobals.topLevelApplication["tuImageGenerator"];
			return _generator;
		}
		
//		private var indexOffset:int=0;
				
		
		public function TuProxy()
		{
			super(NAME, new ArrayCollection());
		}
		
		private var _generateTemplatePreview:Boolean = false;
		
		public function get generateTemplatePreview():Boolean{
			return _generateTemplatePreview;
		}
		
		public function set generateTemplatePreview(v:Boolean):void{
			_generateTemplatePreview = v;
		}
		
//		public function startRender():void{
//			tu.failureCount = 0;
//			if(gThread){
//				gThread.close(false);
//				gThread.removeEventListener(GreenThreadEvent.PROCESS_COMPLETE, processCompleteHandler);
//
//			}
//			var processes:Vector.<IRunnable> = new Vector.<IRunnable>();
//			processes.push(renderProcess);
//			gThread = new GreenThread(processes,(FlexGlobals.topLevelApplication.stage as Stage).frameRate*2, 0.9);
//			gThread.addEventListener( GreenThreadEvent.PROCESS_COMPLETE, processCompleteHandler );
//			gThread.open();
//		}
		
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
		}
		

		
		public function load() :void{
			var templateProxy:TemplateProxy = facade.retrieveProxy(TemplateProxy.NAME) as TemplateProxy;
			var wordListProxy:WordListProxy = facade.retrieveProxy(WordListProxy.NAME) as WordListProxy;

			var tu:TuVO = new TuVO(templateProxy.template, wordListProxy.currentWordList);
			this.setData(tu);
			sendLoadedNotification( ApplicationFacade.TU_LOADED, NAME, SRNAME);

		}

		
		public function generateImage():void{
			tu.generatedImage = generator.canvasImage(1500);
			facade.sendNotification(ApplicationFacade.TU_IMAGE_GENERATED);
		}
		
		
		private var urlLoader : MultipartURLLoader;
		public function postToFacebook():void{
			if(tu.generatedImage==null)
				tu.generatedImage = generator.canvasImage(1500);
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
			urlLoader.addVariable("title", decodeURIComponent(FlexGlobals.topLevelApplication.parameters.title));
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