package com.settinghead.tyful.client.model
{
	import com.adobe.serialization.json.JSONDecoder;
	import com.settinghead.tyful.client.ApplicationFacade;
	import com.settinghead.tyful.client.model.vo.template.Layer;
	import com.settinghead.tyful.client.model.vo.template.TemplateVO;
	import com.settinghead.tyful.client.model.vo.template.WordLayer;
	import com.settinghead.tyful.client.model.zip.IZipInput;
	import com.settinghead.tyful.client.model.zip.IZipOutput;
	import com.settinghead.tyful.client.model.zip.ZipInputImpl;
	import com.settinghead.tyful.client.model.zip.ZipOutputImpl;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	import org.puremvc.as3.utilities.loadup.interfaces.ILoadupProxy;
	
	import ru.inspirit.net.MultipartURLLoader;
	import ru.inspirit.net.events.MultipartURLLoaderEvent;
	
	public class TemplateProxy extends EntityProxy implements ILoadupProxy
	{
		public static const NAME:String = "TemplateProxy";
		public static const SRNAME:String = "TemplateSRProxy";
		private var _pathToLoad:String;
		private var urlLoader : MultipartURLLoader;
		public var templateIdToLoad:String = null;
		public var loading:Boolean = false;

		public function TemplateProxy( )
		{
			super( NAME, new ArrayCollection );
		}
		
		public function set templatePath(path:String):void{
			this._pathToLoad = path;
			load();
		}
		private var loader : URLLoader;

		public function load() :void{
			loading = true;
				var request : URLRequest
				= new URLRequest  (decodeURIComponent(FlexGlobals.topLevelApplication.parameters.templateUrl) + this.templateIdToLoad);
				var urlVariables : URLVariables = new URLVariables ();
				request.data = urlVariables;
				request.method = URLRequestMethod.GET;
				loader = new URLLoader ();
				loader.addEventListener( Event.COMPLETE, fileLoaded );
				loader.dataFormat = URLLoaderDataFormat.BINARY;
				loader.load ( request );
		}
	
		public function fileLoaded(e:Event):void{
			var obj:Object = loader.data;
			var b:ByteArray = (obj as Object) as ByteArray;
			this.fromFile(b);
			loading = false;
			facade.sendNotification(ApplicationFacade.TEMPLATE_LOADED, template);
//			facade.sendNotification(ApplicationFacade.EDIT_TEMPLATE, template);
		}
		
		
		public function get template():TemplateVO{
			return this.getData() as TemplateVO;
		}
		
		public function set template(t:TemplateVO):void{
			if(t.id==null) t.id = decodeURIComponent(FlexGlobals.topLevelApplication.parameters.templateId) as String;

			this.setData(t);
		}
		
		public function toFile(template:TemplateVO = null):ByteArray{
			if(template==null) template = this.template;
			var zipOutput:IZipOutput = new ZipOutputImpl();
			zipOutput.process(template);
			var zipBytes:ByteArray = zipOutput.zipUp();
			return zipBytes;
		}
		
		public function fromFile(b:ByteArray):void{
			var zipInput:IZipInput = new ZipInputImpl();
			template = zipInput.parse(b);
		}
		
		public function newTemplate(width:int, height:int):void{
			template = new TemplateVO();

			var layer:Layer = new WordLayer("Layer1", template, width, height);
//			template.layers.addItem(new WordLayer("Layer1", template));
			facade.sendNotification(ApplicationFacade.TEMPLATE_CREATED);
		}
		
		public function uploadTemplate():void{
			var b:ByteArray = toFile();
			// set up the request & headers for the image upload;
			urlLoader = new MultipartURLLoader();
			// create the image loader & send the image to the server;
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener(Event.COMPLETE, uploadComplete);
			urlLoader.addEventListener(MultipartURLLoaderEvent.DATA_PREPARE_COMPLETE, dataPrepareComplete);
			urlLoader.addVariable("token", decodeURIComponent(FlexGlobals.topLevelApplication.parameters.token));
			urlLoader.addVariable("templateId", decodeURIComponent(FlexGlobals.topLevelApplication.parameters.templateId));
			urlLoader.addVariable("userId", decodeURIComponent(FlexGlobals.topLevelApplication.parameters.userId));
			urlLoader.addVariable("templateUuid", decodeURIComponent(FlexGlobals.topLevelApplication.parameters.templateUuid));
			urlLoader.addFile(b,"my_template.zip",'template');

			
			//			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			
			urlLoader.load( decodeURIComponent(FlexGlobals.topLevelApplication.parameters.templateUrl),true);
		}
		
		public function dataPrepareComplete(e:Event):void{
			if(urlLoader.PREPARED)
				urlLoader.startLoad();
		}
		
		public function uploadComplete(e:Event):void{
			var uuid:String = new JSONDecoder(urlLoader.loader.data,false).getValue().uuid;
			template.uuid = uuid;
			sendNotification(ApplicationFacade.TEMPLATE_UPLOADED, uuid);
		}
	}
}