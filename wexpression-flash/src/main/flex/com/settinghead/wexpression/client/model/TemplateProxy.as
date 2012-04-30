package com.settinghead.wexpression.client.model
{
	import com.adobe.serialization.json.JSONDecoder;
	import com.settinghead.wexpression.client.ApplicationFacade;
	import com.settinghead.wexpression.client.model.vo.template.Layer;
	import com.settinghead.wexpression.client.model.vo.template.TemplateVO;
	import com.settinghead.wexpression.client.model.vo.template.WordLayer;
	import com.settinghead.wexpression.client.model.zip.IZipInput;
	import com.settinghead.wexpression.client.model.zip.IZipOutput;
	import com.settinghead.wexpression.client.model.zip.ZipInputImpl;
	import com.settinghead.wexpression.client.model.zip.ZipOutputImpl;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
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

		public function TemplateProxy( )
		{
			super( NAME, new ArrayCollection );
		}
		
		public function set templatePath(path:String):void{
			this._pathToLoad = path;
			load();
		}
		
		public function load() :void{
			if(_pathToLoad!=null){
				template = new TemplateVO(_pathToLoad);
				var l:WordLayer = new WordLayer("layer1", template);
				//TODO: different path for template and layer PNG
				l.path = _pathToLoad;
				l.loadLayerFromPNG(templateLoadComplete);
			}
		}
		
		private function templateLoadComplete(event:Event):void{	
			facade.sendNotification(ApplicationFacade.TEMPLATE_LOADED, template);
			facade.sendNotification(ApplicationFacade.EDIT_TEMPLATE, template);
		}
		
		
		public function get template():TemplateVO{
			return this.getData() as TemplateVO;
		}
		
		public function set template(t:TemplateVO):void{
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
		
		public function newTemplate():void{
			template = new TemplateVO();
			var layer:Layer = new WordLayer("Layer1", template, 800, 600);
//			template.layers.addItem(new WordLayer("Layer1", template));
			facade.sendNotification(ApplicationFacade.TEMPLATE_LOADED);
		}
		
		public function uploadTemplate():void{
			var b:ByteArray = toFile();
			// set up the request & headers for the image upload;
			urlLoader = new MultipartURLLoader();
			// create the image loader & send the image to the server;
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener(Event.COMPLETE, uploadComplete);
			urlLoader.addEventListener(MultipartURLLoaderEvent.DATA_PREPARE_COMPLETE, dataPrepareComplete);
			urlLoader.addFile(b,"my_template.zip");
			
			//			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			
			urlLoader.load( FlexGlobals.topLevelApplication.parameters.templateUrl,true);
		}
		
		public function dataPrepareComplete(e:Event):void{
			if(urlLoader.PREPARED)
				urlLoader.startLoad();
		}
		
		public function uploadComplete(e:Event):void{
			var id:String = new JSONDecoder(urlLoader.loader.data,false).getValue().id;
			template.id = id;
			sendNotification(ApplicationFacade.TEMPLATE_UPLOADED, id);
		}
	}
}